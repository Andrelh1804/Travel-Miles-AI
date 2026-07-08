import { Module } from "@nestjs/common";
import { APP_GUARD } from "@nestjs/core";
import { ConfigModule } from "@nestjs/config";
import { ThrottlerModule, ThrottlerGuard } from "@nestjs/throttler";
import { validateEnv } from "./common/config/validate-env";
import { HealthModule } from "./modules/health/health.module";
import { DatabaseModule } from "./modules/database/database.module";
import { AuthModule } from "./modules/auth/auth.module";
import { UsersModule } from "./modules/users/users.module";

@Module({
  imports: [
    // Configuração global de env com validação Zod
    ConfigModule.forRoot({
      isGlobal: true,
      validate: validateEnv,
    }),

    // Rate limiting: 3 camadas (global, auth, busca)
    ThrottlerModule.forRoot([
      { name: "global", ttl: 60_000, limit: 100 },
      { name: "auth", ttl: 60_000, limit: 10 },
      { name: "search", ttl: 60_000, limit: 30 },
    ]),

    // Módulos de funcionalidade
    HealthModule,
    DatabaseModule,
    AuthModule,
    UsersModule,
  ],
  providers: [
    // Aplica ThrottlerGuard globalmente em todos os endpoints
    { provide: APP_GUARD, useClass: ThrottlerGuard },
  ],
})
export class AppModule {}
