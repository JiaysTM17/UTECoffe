import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

export async function GET() {
  const backendUrl = process.env.BACKEND_URL || 'https://utecoffe-platform.onrender.com';
  const startTime = Date.now();
  try {
    const res = await fetch(`${backendUrl}/ping`, {
      cache: 'no-store',
      headers: {
        'User-Agent': 'Vercel-Cron-KeepAlive/1.0',
      },
    });
    const duration = Date.now() - startTime;
    const text = await res.text();
    return NextResponse.json({
      status: 'success',
      keepAlive: true,
      httpStatus: res.status,
      latencyMs: duration,
      timestamp: new Date().toISOString(),
      backendResponse: text.trim(),
      message: 'Render container keep-alive successfully triggered from Vercel Edge.',
    });
  } catch (err) {
    return NextResponse.json({
      status: 'error',
      keepAlive: false,
      timestamp: new Date().toISOString(),
      error: err.message || 'Unknown network error',
    }, { status: 502 });
  }
}
