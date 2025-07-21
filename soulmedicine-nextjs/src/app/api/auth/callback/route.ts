import { NextRequest, NextResponse } from 'next/server';
import { verifyFirebaseToken } from '@/lib/auth/server';
import { query, queryOne } from '@/lib/database';
import { ApiError, handleApiError } from '@/lib/utils';
import { User } from '@/types';

export async function POST(request: NextRequest) {
  try {
    const { idToken } = await request.json();

    if (!idToken) {
      throw new ApiError(400, 'ID token is required');
    }

    // Verify the Firebase token
    const decodedToken = await verifyFirebaseToken(idToken);
    if (!decodedToken) {
      throw new ApiError(401, 'Invalid Firebase token');
    }

    const { uid, email, email_verified, name } = decodedToken;

    // Check if user exists in database
    let user = await queryOne<User>(
      'SELECT * FROM users WHERE firebase_id = $1',
      [uid]
    );

    if (!user) {
      // Create new user
      const [newUser] = await query<User>(
        `INSERT INTO users (firebase_id, email, display_name, email_verified, terms_accepted, last_seen_at)
         VALUES ($1, $2, $3, $4, $5, NOW())
         RETURNING *`,
        [uid, email, name || 'User', email_verified, false]
      );
      user = newUser;
    } else {
      // Update last seen and sync email verification status
      await query(
        `UPDATE users 
         SET last_seen_at = NOW(), email_verified = $1, email = $2
         WHERE id = $3`,
        [email_verified, email, user.id]
      );
      user.emailVerified = email_verified;
      user.email = email;
    }

    return NextResponse.json({
      success: true,
      user: {
        id: user.id,
        displayName: user.displayName,
        firebaseId: user.firebaseId,
        email: user.email,
        emailVerified: user.emailVerified,
        termsAccepted: user.termsAccepted,
        lastSeenAt: user.lastSeenAt,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    return handleApiError(error);
  }
}