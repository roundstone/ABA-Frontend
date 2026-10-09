export class ApiError extends Error {
  constructor(
    public status: number,
    message: string,
    public code?: string,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

export const API_MODE = process.env.NEXT_PUBLIC_API_MODE || "mock";

export async function fetchApi<T>(
  endpoint: string,
  options?: RequestInit,
): Promise<T> {
  // Mock logic placeholder
  if (API_MODE === "mock") {
    return {} as T;
  }
  const res = await fetch(endpoint, options);
  if (!res.ok) {
    const message = await res.text();
    throw new ApiError(
      res.status,
      message || `Request failed with status ${res.status}`,
    );
  }

  if (res.status === 204 || res.headers.get("content-length") === "0") {
    return undefined as T;
  }

  return res.json() as Promise<T>;
}
