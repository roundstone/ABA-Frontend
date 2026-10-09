import 'server-only';

const BASE_API_URL_ENV = 'BASE_API_URL';

const REQUEST_HEADERS = ['accept', 'accept-language', 'authorization', 'content-type', 'cookie', 'user-agent'] as const;
const HOP_BY_HOP_HEADERS = new Set([
  'connection',
  'keep-alive',
  'proxy-authenticate',
  'proxy-authorization',
  'te',
  'trailer',
  'transfer-encoding',
  'upgrade',
]);
const REWRITTEN_RESPONSE_HEADERS = new Set(['content-encoding', 'content-length']);

function getBaseApiUrl(): URL {
  const configuredUrl = process.env[BASE_API_URL_ENV];

  if (!configuredUrl) {
    throw new Error(`${BASE_API_URL_ENV} is not configured.`);
  }

  let baseUrl: URL;
  try {
    baseUrl = new URL(configuredUrl);
  } catch {
    throw new Error(`${BASE_API_URL_ENV} must be a valid absolute URL.`);
  }

  if (!['http:', 'https:'].includes(baseUrl.protocol)) {
    throw new Error(`${BASE_API_URL_ENV} must use HTTP or HTTPS.`);
  }

  return baseUrl;
}

function buildUpstreamUrl(request: Request, path: string[]): URL {
  const baseUrl = getBaseApiUrl();
  const basePath = baseUrl.pathname.replace(/\/+$/, '');
  const apiPath = basePath.endsWith('/api/v1')
    ? basePath
    : basePath.endsWith('/api')
      ? `${basePath}/v1`
      : `${basePath}/api/v1`;
  const encodedPath = path.map(encodeURIComponent).join('/');
  const upstreamUrl = new URL(`${apiPath}/${encodedPath}`, baseUrl.origin);

  upstreamUrl.search = new URL(request.url).search;
  return upstreamUrl;
}

function requestHeaders(request: Request): Headers {
  const headers = new Headers();

  for (const header of REQUEST_HEADERS) {
    const value = request.headers.get(header);
    if (value) headers.set(header, value);
  }

  if (!headers.has('authorization')) {
    const token = request.headers
      .get('cookie')
      ?.split(';')
      .map((cookie) => cookie.trim())
      .find((cookie) => cookie.startsWith('aba_auth_token='))
      ?.slice('aba_auth_token='.length);

    if (token) headers.set('authorization', `Bearer ${decodeURIComponent(token)}`);
  }

  return headers;
}

function responseHeaders(upstream: Response): Headers {
  const headers = new Headers();

  upstream.headers.forEach((value, key) => {
    const normalizedKey = key.toLowerCase();
    if (
      !HOP_BY_HOP_HEADERS.has(normalizedKey) &&
      !REWRITTEN_RESPONSE_HEADERS.has(normalizedKey) &&
      normalizedKey !== 'set-cookie'
    ) {
      headers.set(key, value);
    }
  });

  const setCookies = (upstream.headers as Headers & { getSetCookie?: () => string[] }).getSetCookie?.() ?? [];
  for (const cookie of setCookies) {
    // The Nest API scopes its refresh token to `/auth`. Re-scope it to this
    // application's proxied auth namespace so refresh and logout receive it.
    headers.append('set-cookie', cookie.replace(/;\s*path=\/auth(?=;|$)/i, '; Path=/api/v1/auth'));
  }

  return headers;
}

export async function proxyApiRequest(request: Request, path: string[] = []): Promise<Response> {
  let upstreamUrl: URL;

  try {
    upstreamUrl = buildUpstreamUrl(request, path);
  } catch (error) {
    return Response.json(
      { error: error instanceof Error ? error.message : 'API proxy configuration is invalid.' },
      { status: 500 },
    );
  }

  const method = request.method.toUpperCase();
  const hasBody = !['GET', 'HEAD'].includes(method);

  try {
    const upstream = await fetch(upstreamUrl, {
      method,
      headers: requestHeaders(request),
      body: hasBody ? await request.arrayBuffer() : undefined,
      redirect: 'manual',
      cache: 'no-store',
    });

    return new Response(upstream.body, {
      status: upstream.status,
      statusText: upstream.statusText,
      headers: responseHeaders(upstream),
    });
  } catch {
    return Response.json(
      { error: 'The upstream API could not be reached.' },
      { status: 502 },
    );
  }
}
