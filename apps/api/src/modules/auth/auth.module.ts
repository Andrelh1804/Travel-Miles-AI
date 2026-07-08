import { Module } from "@nestjs/common";
import { APP_GUARD } from "@nestjs/core";
import { AuthController } from "./auth.controller";
import { AuthService } from "./auth.service";
import { SupabaseAuthGuard } from "./guards/supabase-auth.guard";
import { RolesGuard } from "../../common/guards/roles.guard";

@Module({
  controllers: [AuthController],
  providers: [
    AuthService,
    // Apply SupabaseAuthGuard globally — routes marked @Public() are exempt
    { provide: APP_GUARD, useClass: SupabaseAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
  ],
  exports: [AuthService],
})
export class AuthModule {}
