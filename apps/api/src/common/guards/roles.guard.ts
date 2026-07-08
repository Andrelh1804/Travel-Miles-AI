import { Injectable, CanActivate, ExecutionContext } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { ROLES_KEY } from "../decorators/roles.decorator";
import type { Request } from "express";
import type { User } from "@supabase/supabase-js";

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    // No @Roles() decorator — anyone (authenticated) may access
    if (!requiredRoles || requiredRoles.length === 0) return true;

    const request = context.switchToHttp().getRequest<Request & { user: User }>();
    const user = request.user;

    if (!user) return false;

    // Role is stored in Supabase user_metadata
    const userRole: string = (user.user_metadata?.["role"] as string) ?? "user";
    return requiredRoles.includes(userRole);
  }
}
