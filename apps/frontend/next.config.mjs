/** @type {import('next').NextConfig} */
const BACKEND_URL = process.env.BACKEND_URL || 'https://utecoffe-platform.onrender.com';

const nextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  compress: true,
  async rewrites() {
    return {
      beforeFiles: [],
      afterFiles: [],
      fallback: [
        {
          source: '/:path*',
          destination: `${BACKEND_URL}/:path*`,
        },
      ],
    };
  },
};

export default nextConfig;
