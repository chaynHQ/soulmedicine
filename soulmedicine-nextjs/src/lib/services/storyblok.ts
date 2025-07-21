import Redis from 'ioredis';

// Redis client for caching
let redis: Redis | null = null;

function getRedis(): Redis {
  if (!redis) {
    redis = new Redis({
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379'),
      password: process.env.REDIS_PASSWORD,
      tls: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : undefined,
    });
  }
  return redis;
}

export class StoryblokService {
  private readonly apiToken: string;
  private readonly baseUrl = 'https://api.storyblok.com/v1/cdn';
  private readonly cacheTtl = parseInt(process.env.STORYBLOK_CACHE_TTL || '3600'); // 1 hour

  constructor() {
    this.apiToken = process.env.STORYBLOK_API_TOKEN || '';
    if (!this.apiToken) {
      throw new Error('STORYBLOK_API_TOKEN is required');
    }
  }

  private getCacheKey(path: string): string {
    return `storyblok:${path}`;
  }

  async fetch(path: string): Promise<any> {
    try {
      // Try cache first
      const redis = getRedis();
      const cacheKey = this.getCacheKey(path);
      const cached = await redis.get(cacheKey);
      
      if (cached) {
        return JSON.parse(cached);
      }

      // Fetch from Storyblok
      const response = await fetch(
        `${this.baseUrl}/stories/${path}?token=${this.apiToken}`
      );

      if (!response.ok) {
        throw new Error(`Storyblok API error: ${response.status}`);
      }

      const data = await response.json();
      
      // Cache the result
      await redis.setex(cacheKey, this.cacheTtl, JSON.stringify(data));
      
      return data;
    } catch (error) {
      console.error('Storyblok fetch error:', error);
      throw error;
    }
  }

  async fetchAll(path: string): Promise<any[]> {
    try {
      const response = await fetch(
        `${this.baseUrl}/stories?starts_with=${path}&token=${this.apiToken}`
      );

      if (!response.ok) {
        throw new Error(`Storyblok API error: ${response.status}`);
      }

      const data = await response.json();
      return data.stories || [];
    } catch (error) {
      console.error('Storyblok fetchAll error:', error);
      throw error;
    }
  }

  async invalidateCache(path?: string): Promise<void> {
    const redis = getRedis();
    if (path) {
      const cacheKey = this.getCacheKey(path);
      await redis.del(cacheKey);
    } else {
      // Clear all Storyblok cache
      const keys = await redis.keys('storyblok:*');
      if (keys.length > 0) {
        await redis.del(...keys);
      }
    }
  }
}

export const storyblokService = new StoryblokService();