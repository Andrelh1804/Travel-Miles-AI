import { Injectable, UnauthorizedException, ConflictException, Logger } from "@nestjs/common";
import { SupabaseService } from "../database/supabase.service";
import type { LoginDto } from "./dto/login.dto";
import type { RegisterDto, ForgotPasswordDto, ResetPasswordDto } from "./dto/register.dto";

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(private readonly supabase: SupabaseService) {}

  async register(dto: RegisterDto) {
    const { data, error } = await this.supabase.client.auth.signUp({
      email: dto.email,
      password: dto.password,
      options: {
        data: {
          name: dto.name,
          phone_number: dto.phoneNumber ?? null,
          role: "user",
        },
      },
    });

    if (error) {
      if (error.message.includes("already registered")) {
        throw new ConflictException("Este e-mail já está cadastrado");
      }
      throw new UnauthorizedException(error.message);
    }

    this.logger.log(`New user registered: ${dto.email}`);
    return {
      user: data.user,
      session: data.session,
      message: "Cadastro realizado! Verifique seu e-mail para confirmar a conta.",
    };
  }

  async login(dto: LoginDto) {
    const { data, error } = await this.supabase.client.auth.signInWithPassword({
      email: dto.email,
      password: dto.password,
    });

    if (error) {
      throw new UnauthorizedException("E-mail ou senha incorretos");
    }

    return {
      user: data.user,
      session: data.session,
    };
  }

  async logout(accessToken: string) {
    const client = this.supabase.client;
    await client.auth.admin;
    const { error } = await this.supabase.client.auth.signOut();
    if (error) {
      this.logger.warn(`Logout error: ${error.message}`);
    }
    void accessToken; // token used server-side for audit if needed
    return { message: "Logout realizado com sucesso" };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const { error } = await this.supabase.client.auth.resetPasswordForEmail(dto.email, {
      redirectTo: `${process.env["ALLOWED_ORIGINS"]?.split(",")[0]}/auth/reset-password`,
    });

    if (error) {
      this.logger.error(`Forgot password error for ${dto.email}: ${error.message}`);
    }

    // Always return success to prevent user enumeration
    return { message: "Se o e-mail existir, você receberá instruções para redefinir a senha." };
  }

  async resetPassword(dto: ResetPasswordDto, accessToken: string) {
    // Set the user session from the token in the reset link
    const { data: userData, error: userError } =
      await this.supabase.client.auth.getUser(accessToken);

    if (userError || !userData.user) {
      throw new UnauthorizedException("Token de redefinição inválido ou expirado");
    }

    const { error } = await this.supabase.admin.auth.admin.updateUserById(userData.user.id, {
      password: dto.password,
    });

    if (error) {
      throw new UnauthorizedException(error.message);
    }

    return { message: "Senha redefinida com sucesso" };
  }

  async refreshToken(refreshToken: string) {
    const { data, error } = await this.supabase.client.auth.refreshSession({
      refresh_token: refreshToken,
    });

    if (error || !data.session) {
      throw new UnauthorizedException("Refresh token inválido ou expirado");
    }

    return { session: data.session };
  }
}
