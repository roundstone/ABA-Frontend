import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const PUBLIC_ROUTES = [
  '/',
  '/shop',
  '/product',
  '/cart',
  '/checkout',
  '/gallery',
  '/auth',
  '/login',
  '/dev',
  '/verify-2fa',
  '/forgot-password'
];

// Helper to check if a route is public
const isPublicRoute = (pathname: string) => {
  if (PUBLIC_ROUTES.includes(pathname)) return true;
  if (pathname.startsWith('/product/')) return true;
  if (pathname.startsWith('/auth/')) return true;
  if (pathname.startsWith('/shop/')) return true;
  return false;
};

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  
  if (!isPublicRoute(pathname)) {
    const token = request.cookies.get('aba_auth_token')?.value;
    const role = request.cookies.get('aba_auth_role')?.value;

    if (!token) {
      if (pathname.startsWith('/portal')) {
        return NextResponse.redirect(new URL('/auth/login', request.url));
      }
      return NextResponse.redirect(new URL('/login', request.url));
    }

    // RBAC: Customer accessing Admin routes (ERP or POS)
    if ((pathname.startsWith('/erp') || pathname.startsWith('/pos')) && role === 'Customer') {
      return NextResponse.redirect(new URL('/portal/dashboard', request.url));
    }
    
    // RBAC: Admin accessing Customer routes
    if (pathname.startsWith('/portal') && role !== 'Customer') {
      return NextResponse.redirect(new URL('/erp/dashboard', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public assets
     */
    '/((?!api|_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
