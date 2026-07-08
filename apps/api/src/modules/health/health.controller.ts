import { Controller, Get, Version } from "@nestjs/common";
import { ApiTags, ApiOperation } from "@nestjs/swagger";
import { Public } from "../../common/decorators/roles.decorator";

@ApiTags("health")
@Controller("health")
export class HealthController {
  @Public()
  @Get()
  @Version("1")
  @ApiOperation({ summary: "Health check", description: "Returns API status and version." })
  check() {
    return {
      status: "ok",
      service: "TravelMiles AI API",
      version: "1.0.0",
      environment: process.env["NODE_ENV"] ?? "development",
      uptime: Math.floor(process.uptime()),
      timestamp: new Date().toISOString(),
    };
  }
}
