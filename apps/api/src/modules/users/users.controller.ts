import {
  Controller,
  Get,
  Patch,
  Delete,
  Body,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { UsersService, UpdateProfileDto } from "./users.service";
import { CurrentUser } from "../../common/decorators/current-user.decorator";
import type { User } from "@supabase/supabase-js";

@ApiTags("users")
@Controller({ path: "users", version: "1" })
@ApiBearerAuth("supabase-jwt")
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get("me")
  @ApiOperation({ summary: "Perfil do usuário autenticado" })
  getProfile(@CurrentUser() user: User) {
    return this.usersService.getProfile(user.id);
  }

  @Patch("me")
  @ApiOperation({ summary: "Atualizar perfil" })
  updateProfile(@CurrentUser() user: User, @Body() dto: UpdateProfileDto) {
    return this.usersService.updateProfile(user.id, dto);
  }

  @Delete("me")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Excluir conta (soft-delete)" })
  deleteAccount(@CurrentUser() user: User) {
    return this.usersService.deleteAccount(user.id);
  }
}
