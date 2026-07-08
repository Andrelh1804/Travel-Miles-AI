import { Injectable, OnModuleInit, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { createClient, SupabaseClient } from "@supabase/supabase-js";

@Injectable()
export class SupabaseService implements OnModuleInit {
  private readonly logger = new Logger(SupabaseService.name);

  /** Public client — uses the anon key, respects Row Level Security. */
  public readonly client: SupabaseClient;

  /** Admin client — uses the service-role key, bypasses RLS. Use with care. */
  public readonly admin: SupabaseClient;

  constructor(private readonly config: ConfigService) {
    const url = this.config.getOrThrow<string>("SUPABASE_URL");
    const anonKey = this.config.getOrThrow<string>("SUPABASE_ANON_KEY");
    const serviceKey = this.config.getOrThrow<string>("SUPABASE_SERVICE_ROLE_KEY");

    this.client = createClient(url, anonKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    this.admin = createClient(url, serviceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
  }

  async onModuleInit(): Promise<void> {
    // Verify connectivity at startup
    const { error } = await this.admin.from("users").select("id").limit(1);

    if (error && error.code !== "PGRST116") {
      // PGRST116 = table doesn't exist yet (fresh DB before migrations)
      this.logger.warn(`Supabase connectivity check: ${error.message}`);
    } else {
      this.logger.log("✅ Supabase connected");
    }
  }
}
