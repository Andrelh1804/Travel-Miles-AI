import { SetMetadata } from "@nestjs/common";

export const ROLES_KEY = "roles";

/**
 * @Roles("admin", "super_admin") — declares which roles can access a route.
 * Enforced by the RolesGuard.
 */
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);

export const IS_PUBLIC_KEY = "isPublic";

/** @Public() — marks a route as publicly accessible (no auth required). */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
