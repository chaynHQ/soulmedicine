import { NextResponse } from 'next/server';

export async function POST() {
  // In a full implementation, we would clear any server-side session here
  // For now, just return success
  return NextResponse.json({ success: true });
}