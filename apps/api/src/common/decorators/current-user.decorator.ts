import { createParamDecorator, ExecutionContext } from "@nestjs/common";
import { Request } from "express";
import type { User } from "@supabase/supabase-js";

/**
 * @CurrentUser() — extracts the authenticated Supabase user from the request.
 * Requires SupabaseAuthGuard to be applied first.
 */
export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): User => {
    const request = ctx.switchToHttp().getRequest<Request & { user: User }>();
    return request.user;
  },
);
