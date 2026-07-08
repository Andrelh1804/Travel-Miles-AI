import { Controller, Post, Body, HttpCode, HttpStatus, Headers, Version } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from "@nestjs/swagger";
import { AuthService } from "./auth.service";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto, ForgotPasswordDto, ResetPasswordDto } from "./dto/register.dto";
import { Public } from "../../common/decorators/roles.decorator";
import { CurrentUser } from "../../common/decorators/current-user.decorator";
import type { User } from "@supabase/supabase-js";

@ApiTags("auth")
@Controller("auth")
@Version("1")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post("register")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Criar conta" })
  @ApiResponse({ status: 201, description: "Conta criada. Verifique seu e-mail." })
  @ApiResponse({ status: 409, description: "E-mail já cadastrado" })
  register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Public()
  @Post("login")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Autenticar usuário" })
  @ApiResponse({ status: 200, description: "Login realizado com sucesso" })
  @ApiResponse({ status: 401, description: "Credenciais inválidas" })
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post("logout")
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth("supabase-jwt")
  @ApiOperation({ summary: "Encerrar sessão" })
  logout(@Headers("authorization") authHeader: string) {
    const token = authHeader?.replace("Bearer ", "") ?? "";
    return this.authService.logout(token);
  }

  @Public()
  @Post("forgot-password")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Solicitar redefinição de senha" })
  forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgotPassword(dto);
  }

  @Public()
  @Post("reset-password")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Redefinir senha com token" })
  resetPassword(
    @Body() dto: ResetPasswordDto,
    @Headers("authorization") authHeader: string,
  ) {
    const token = authHeader?.replace("Bearer ", "") ?? "";
    return this.authService.resetPassword(dto, token);
  }

  @Public()
  @Post("refresh")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Renovar access token" })
  refresh(@Body() body: { refresh_token: string }) {
    return this.authService.refreshToken(body.refresh_token);
  }

  @Post("me")
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth("supabase-jwt")
  @ApiOperation({ summary: "Retorna o usuário autenticado" })
  me(@CurrentUser() user: User) {
    return { user };
  }
}
