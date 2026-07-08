-- ============================================================================
-- TravelMiles AI — Triggers, Views e Row Level Security (RLS)
-- ============================================================================

-- ─── Trigger: updated_at automático ─────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_users_updated_at         BEFORE UPDATE ON public.users         FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_flights_updated_at       BEFORE UPDATE ON public.flights       FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_alerts_updated_at        BEFORE UPDATE ON public.alerts        FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_trips_updated_at         BEFORE UPDATE ON public.trips         FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER trg_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ─── Trigger: criar perfil ao cadastrar no Supabase Auth ─────────────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.users (id, email, name, email_verified)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
    COALESCE((NEW.email_confirmed_at IS NOT NULL), FALSE)
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── Trigger: audit log automático ──────────────────────────────────────────
-- Nota: TG_OP retorna 'INSERT'/'UPDATE'/'DELETE' (maiúsculas),
-- mas o enum audit_action usa 'create'/'update'/'delete' (minúsculas).
-- O CASE faz o mapeamento explícito para evitar falha de cast.
CREATE OR REPLACE FUNCTION public.log_audit()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $
DECLARE
  v_action audit_action;
BEGIN
  v_action := CASE TG_OP
    WHEN 'INSERT' THEN 'create'::audit_action
    WHEN 'UPDATE' THEN 'update'::audit_action
    WHEN 'DELETE' THEN 'delete'::audit_action
    ELSE 'create'::audit_action
  END;

  INSERT INTO public.audit_logs (action, entity_type, entity_id, old_values, new_values)
  VALUES (
    v_action,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    CASE WHEN TG_OP != 'INSERT' THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP != 'DELETE' THEN to_jsonb(NEW) ELSE NULL END
  );
  RETURN COALESCE(NEW, OLD);
END;
$;

-- Aplicar auditoria nas tabelas críticas
CREATE TRIGGER trg_audit_users         AFTER INSERT OR UPDATE OR DELETE ON public.users         FOR EACH ROW EXECUTE FUNCTION public.log_audit();
CREATE TRIGGER trg_audit_subscriptions AFTER INSERT OR UPDATE OR DELETE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.log_audit();
CREATE TRIGGER trg_audit_payments      AFTER INSERT OR UPDATE OR DELETE ON public.payments      FOR EACH ROW EXECUTE FUNCTION public.log_audit();

-- ─── View: voos com detalhes completos ───────────────────────────────────────
CREATE OR REPLACE VIEW public.v_flights_full AS
SELECT
  f.id,
  f.flight_number,
  f.departure_time,
  f.arrival_time,
  f.duration_minutes,
  f.stops,
  f.aircraft_type,
  -- Airline
  al.iata_code AS airline_iata,
  al.name      AS airline_name,
  al.logo_url  AS airline_logo,
  al.alliance  AS airline_alliance,
  -- Origin
  ao.iata_code AS origin_iata,
  ao.name      AS origin_name,
  ao.city      AS origin_city,
  ao.country   AS origin_country,
  -- Destination
  ad.iata_code AS destination_iata,
  ad.name      AS destination_name,
  ad.city      AS destination_city,
  ad.country   AS destination_country
FROM public.flights f
JOIN public.airlines al ON f.airline_id = al.id
JOIN public.airports ao ON f.origin_id = ao.id
JOIN public.airports ad ON f.destination_id = ad.id;

-- ─── View: saldo de milhas por usuário ───────────────────────────────────────
CREATE OR REPLACE VIEW public.v_user_miles_summary AS
SELECT
  ma.user_id,
  lp.name      AS program_name,
  lp.short_name,
  ma.balance_miles,
  ma.expiration_date,
  ROUND(ma.balance_miles * lp.points_per_mile, 2) AS estimated_value_brl
FROM public.miles_accounts ma
JOIN public.loyalty_programs lp ON ma.loyalty_program_id = lp.id
WHERE ma.balance_miles > 0;

-- ─── Row Level Security (RLS) ─────────────────────────────────────────────────
ALTER TABLE public.users           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trips           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.miles_accounts  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.search_history  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs      ENABLE ROW LEVEL SECURITY;

-- users: ver e editar apenas o próprio perfil
CREATE POLICY policy_users_select ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY policy_users_update ON public.users FOR UPDATE USING (auth.uid() = id);

-- alerts: CRUD apenas dos próprios alertas
CREATE POLICY policy_alerts_all ON public.alerts FOR ALL USING (auth.uid() = user_id);

-- notifications: ver apenas as próprias
CREATE POLICY policy_notifications_select ON public.notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY policy_notifications_update ON public.notifications FOR UPDATE USING (auth.uid() = user_id);

-- trips: CRUD apenas das próprias viagens
CREATE POLICY policy_trips_all ON public.trips FOR ALL USING (auth.uid() = user_id);

-- miles_accounts: CRUD apenas das próprias contas
CREATE POLICY policy_miles_all ON public.miles_accounts FOR ALL USING (auth.uid() = user_id);

-- search_history: ver apenas o próprio histórico
CREATE POLICY policy_search_history_all ON public.search_history FOR ALL USING (auth.uid() = user_id);

-- favorites: CRUD apenas dos próprios favoritos
CREATE POLICY policy_favorites_all ON public.favorites FOR ALL USING (auth.uid() = user_id);

-- subscriptions: ver apenas a própria assinatura
CREATE POLICY policy_subscriptions_select ON public.subscriptions FOR SELECT USING (auth.uid() = user_id);

-- payments: ver apenas os próprios pagamentos
CREATE POLICY policy_payments_select ON public.payments FOR SELECT USING (auth.uid() = user_id);

-- audit_logs: apenas admins podem ler
CREATE POLICY policy_audit_logs_admin ON public.audit_logs FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    )
  );

-- Tabelas públicas (leitura sem autenticação)
ALTER TABLE public.airports         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.airlines         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.loyalty_programs ENABLE ROW LEVEL SECURITY;
CREATE POLICY policy_airports_public         ON public.airports         FOR SELECT USING (TRUE);
CREATE POLICY policy_airlines_public         ON public.airlines         FOR SELECT USING (TRUE);
CREATE POLICY policy_loyalty_programs_public ON public.loyalty_programs FOR SELECT USING (TRUE);
