import { NestFactory } from "@nestjs/core";
import { ValidationPipe, VersioningType } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";
import helmet from "helmet";
import { AppModule } from "./app.module";
import { AllExceptionsFilter } from "./common/filters/all-exceptions.filter";
import { LoggingInterceptor } from "./common/interceptors/logging.interceptor";
import { TransformInterceptor } from "./common/interceptors/transform.interceptor";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  // ─── Segurança ─────────────────────────────────────────────────────────────
  app.use(helmet());

  const allowedOrigins = (
    configService.get<string>("ALLOWED_ORIGINS") ?? "http://localhost:3000"
  ).split(",");
  app.enableCors({
    origin: allowedOrigins,
    credentials: true,
  });

  // ─── Versionamento ─────────────────────────────────────────────────────────
  app.enableVersioning({
    type: VersioningType.URI,
    prefix: "v",
    defaultVersion: "1",
  });
  app.setGlobalPrefix("api");

  // ─── Pipes, Filters, Interceptors ──────────────────────────────────────────
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new AllExceptionsFilter());
  app.useGlobalInterceptors(new LoggingInterceptor(), new TransformInterceptor());

  // ─── Swagger (apenas em desenvolvimento) ───────────────────────────────────
  if (configService.get("NODE_ENV") !== "production") {
    const config = new DocumentBuilder()
      .setTitle("TravelMiles AI API")
      .setDescription("Plataforma SaaS para pesquisa de passagens e milhas")
      .setVersion("1.0")
      .addBearerAuth({ type: "http", scheme: "bearer", bearerFormat: "JWT" }, "supabase-jwt")
      .build();
    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup("api/docs", app, document);
  }

  const port = configService.get<number>("PORT") ?? 8080;
  await app.listen(port, "0.0.0.0");
  console.log(`🚀 TravelMiles API rodando em http://0.0.0.0:${port}/api/v1`);
}

bootstrap();
