import { proxyApiRequest } from '@/lib/server/apiProxy';

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  return proxyApiRequest(request);
}

export async function POST(request: Request) {
  return proxyApiRequest(request);
}

export async function PUT(request: Request) {
  return proxyApiRequest(request);
}

export async function PATCH(request: Request) {
  return proxyApiRequest(request);
}

export async function DELETE(request: Request) {
  return proxyApiRequest(request);
}

export async function HEAD(request: Request) {
  return proxyApiRequest(request);
}
