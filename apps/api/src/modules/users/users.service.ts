import { Injectable, NotFoundException, Logger } from "@nestjs/common";
import { SupabaseService } from "../database/supabase.service";
import type { User } from "@supabase/supabase-js";

export interface UpdateProfileDto {
  name?: string;
  avatarUrl?: string;
  phoneNumber?: string;
  preferredCurrency?: string;
  preferredLanguage?: string;
}

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  constructor(private readonly supabase: SupabaseService) {}

  async getProfile(userId: string) {
    const { data, error } = await this.supabase.admin
      .from("users")
      .select("*, miles_accounts(count), alerts(count)")
      .eq("id", userId)
      .single();

    if (error || !data) {
      throw new NotFoundException("Usuário não encontrado");
    }

    return data;
  }

  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const { data, error } = await this.supabase.admin
      .from("users")
      .update({
        name: dto.name,
        avatar_url: dto.avatarUrl,
        phone_number: dto.phoneNumber,
        preferred_currency: dto.preferredCurrency,
        preferred_language: dto.preferredLanguage,
        updated_at: new Date().toISOString(),
      })
      .eq("id", userId)
      .select()
      .single();

    if (error) {
      throw new Error(`Failed to update profile: ${error.message}`);
    }

    return data;
  }

  async deleteAccount(userId: string) {
    // Soft-delete in users table
    await this.supabase.admin
      .from("users")
      .update({ deleted_at: new Date().toISOString(), is_active: false })
      .eq("id", userId);

    // Deactivate all alerts
    await this.supabase.admin
      .from("alerts")
      .update({ is_active: false })
      .eq("user_id", userId);

    // Delete the auth user last
    const { error } = await this.supabase.admin.auth.admin.deleteUser(userId);
    if (error) {
      this.logger.error(`Failed to delete auth user ${userId}: ${error.message}`);
    }

    return { message: "Conta excluída com sucesso" };
  }

  async getUserByAuthId(supabaseUser: User) {
    const { data } = await this.supabase.admin
      .from("users")
      .select("*")
      .eq("id", supabaseUser.id)
      .single();

    return data;
  }
}
