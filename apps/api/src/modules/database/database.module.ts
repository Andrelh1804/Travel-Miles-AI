import { Module, Global } from "@nestjs/common";
import { SupabaseService } from "./supabase.service";

/**
 * Global module — SupabaseService is available everywhere without re-importing.
 */
@Global()
@Module({
  providers: [SupabaseService],
  exports: [SupabaseService],
})
export class DatabaseModule {}
