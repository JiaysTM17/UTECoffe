import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

export async function GET() {
  return NextResponse.json({
    status: 'UP',
    platform: 'Vercel Edge Network',
    region: process.env.VERCEL_REGION || 'sin1',
    timestamp: new Date().toISOString(),
  });
}
