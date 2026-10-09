import { API_MODE, fetchApi } from "@/lib/api";
import {
  LoginInput,
  ForgotPasswordInput,
  ResetPasswordInput,
  SignupInput,
} from "../schemas";
import { LoginResponse, User, UserRole } from "../types";

// Mock delays
const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

type BackendRole = { name?: string };
type BackendUser = {
  id: number | string;
  first_name: string;
  middle_name?: string | null;
  last_name: string;
  email: string;
  phone?: string | null;
  user_type?: { name?: string } | null;
  roles?: BackendRole[];
  createdAt?: string;
  created_at?: string;
};

const USER_ROLES: readonly UserRole[] = [
  "Super Admin",
  "Admin",
  "Customer",
  "Vendor",
  "Marketer",
  "Merchant user",
  "Auditor",
  "Staff",
];

function asUserRole(value: string | undefined): UserRole | undefined {
  return USER_ROLES.includes(value as UserRole) ? (value as UserRole) : undefined;
}

function toUser(user: BackendUser): User {
  const roles = (user.roles ?? [])
    .map((role) => asUserRole(role.name))
    .filter((role): role is UserRole => Boolean(role));
  const userType = asUserRole(user.user_type?.name);

  return {
    id: String(user.id),
    name: [user.first_name, user.middle_name, user.last_name]
      .filter(Boolean)
      .join(" "),
    firstName: user.first_name,
    lastName: user.last_name,
    email: user.email,
    phone: user.phone ?? undefined,
    roles,
    userType,
    status: "Active",
    twoFactorEnabled: false,
    createdAt: user.createdAt ?? user.created_at ?? new Date().toISOString(),
  };
}

export const login = async (data: LoginInput): Promise<LoginResponse> => {
  console.log("API_MODE:", API_MODE);
  if (API_MODE !== "mock") {
    const { access_token } = await fetchApi<{ access_token: string }>("/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: data.email, password: data.password }),
    });

    const profile = await fetchApi<BackendUser>("/api/v1/auth/me", {
      headers: { Authorization: `Bearer ${access_token}` },
    });

    return { token: access_token, user: toUser(profile) };
  }

  await delay(800);
  if (data.email === "locked@buynigeria.example.com") {
    throw new Error(
      "Account locked. Try again in 15 minutes or reset your password",
    );
  }
  if (data.email === "suspended@buynigeria.example.com") {
    throw new Error("Your account is suspended. Contact your administrator");
  }
  if (data.email === "wrong@buynigeria.example.com") {
    throw new Error("Email/phone or password is incorrect");
  }

  return {
    token: "mock-jwt-token-123",
    user: {
      id: "usr-1",
      name: "Admin User",
      email: data.email,
      roles: ["Admin"],
      status: "Active",
      twoFactorEnabled: false,
      createdAt: new Date().toISOString(),
    },
    requires2FA: data.email === "2fa@buynigeria.example.com",
  };
};

export function getUserHome(user: User): string {
  switch (user.userType) {
    case "Customer":
      return "/portal/dashboard";
    case "Marketer":
      return "/erp/referrals";
    default:
      return "/erp/dashboard";
  }
}

export const signup = async (data: SignupInput): Promise<unknown> => {
  if (API_MODE === "mock") {
    await delay(800);
    return undefined;
  }

  return fetchApi<unknown>("/api/v1/auth/signup", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      ...data,
      referralCode: data.referralCode || undefined,
    }),
  });
};

export const logout = async (): Promise<void> => {
  if (API_MODE === "mock") return;

  await fetchApi<void>("/api/v1/auth/logout", { method: "POST" });
};

export const forgotPassword = async (
  data: ForgotPasswordInput,
): Promise<void> => {
  void data;
  await delay(800);
  // Always resolves successfully as per specs
};

export const resetPassword = async (
  data: ResetPasswordInput,
  token: string,
): Promise<void> => {
  await delay(800);
  if (token === "expired") {
    throw new Error("Token is expired or invalid");
  }
};
