// Core types for SoulMedicine Next.js app

export interface User {
  id: string;
  displayName: string;
  firebaseId: string;
  email: string;
  emailVerified: boolean;
  termsAccepted: boolean;
  lastSeenAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface Course {
  uuid: string;
  slug: string;
  name: string;
  summary: string;
  description: string;
  image?: string;
  enabledLanguages: string[];
  createdAt: Date;
  publishedAt: Date;
  lessons: Lesson[];
  voteCount?: number;
  userVoted?: boolean;
  userSubscribed?: boolean;
}

export interface Lesson {
  slug: string;
  name: string;
  content: string;
  courseSlug: string;
}

export interface Subscription {
  id: string;
  userId: string;
  courseSlug: string;
  active: boolean;
  mainLanguage: string;
  otherLanguages: string[];
  deliveryMethod: 'email';
  daysUtc: string[];
  hoursUtc: number[];
  lessonsDelivered: string[];
  lastDeliveredAt?: Date;
  userTimezone: string;
  disguised: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface LessonReaction {
  id: string;
  userId: string;
  courseSlug: string;
  lessonSlug: string;
  reactionName: 'empowered' | 'strong' | 'knowledgeable' | 'safe' | 'motivated';
  createdAt: Date;
  updatedAt: Date;
}

export interface Vote {
  id: string;
  userId: string;
  courseSlug: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Progress {
  id: string;
  userId: string;
  courseSlug: string;
  lessonSlug: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Page {
  slug: string;
  title: string;
  description: string;
  contentHtml: string;
  fullWidth: boolean;
}

export interface Settings {
  disguisedSubjectLines: string[];
  coursesBgImage?: string;
  announcementBanner?: string;
}

export interface AuthContextType {
  user: User | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  updateProfile: (data: Partial<User>) => Promise<void>;
}

export interface ApiResponse<T> {
  data: T;
  success: boolean;
  message?: string;
}

export type Locale = 'en' | 'es' | 'fr' | 'de' | 'ar' | 'fa' | 'he' | 'ur';

export interface LocaleConfig {
  locale: Locale;
  name: string;
  rtl: boolean;
}