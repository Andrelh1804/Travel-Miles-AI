-- ============================================================================
-- TravelMiles AI — Schema Inicial v1.0.0
-- Executar no Supabase SQL Editor ou via CLI
-- ============================================================================

-- ─── Extensions ──────────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- full-text search em nomes
CREATE EXTENSION IF NOT EXISTS "unaccent";        -- busca sem acentos

-- ─── Enums ───────────────────────────────────────────────────────────────────
CREATE TYPE user_role         AS ENUM ('super_admin', 'admin', 'user');
CREATE TYPE subscription_plan AS ENUM ('free', 'starter', 'pro', 'enterprise');
CREATE TYPE subscription_status AS ENUM ('active', 'canceled', 'past_due', 'trialing', 'incomplete');
CREATE TYPE cabin_class       AS ENUM ('economy', 'premium_economy', 'business', 'first');
CREATE TYPE alert_type        AS ENUM ('price', 'miles', 'route');
CREATE TYPE notification_channel AS ENUM ('email', 'push', 'whatsapp');
CREATE TYPE payment_provider  AS ENUM ('stripe', 'mercado_pago');
CREATE TYPE payment_status    AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE loyalty_program_type AS ENUM ('airline', 'bank', 'hotel');
CREATE TYPE trip_status       AS ENUM ('planning', 'booked', 'completed', 'canceled');
CREATE TYPE audit_action      AS ENUM ('create','update','delete','login','logout','failed_login','password_reset');
CREATE TYPE billing_cycle     AS ENUM ('monthly', 'yearly');

-- ─── users ───────────────────────────────────────────────────────────────────
-- Mirrors auth.users from Supabase Auth. Populated via trigger on signup.
CREATE TABLE IF NOT EXISTS public.users (
  id                  UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email               TEXT NOT NULL UNIQUE,
  name                TEXT,
  avatar_url          TEXT,
  role                user_role NOT NULL DEFAULT 'user',
  is_active           BOOLEAN NOT NULL DEFAULT TRUE,
  email_verified      BOOLEAN NOT NULL DEFAULT FALSE,
  phone_number        TEXT,
  subscription_plan   subscription_plan NOT NULL DEFAULT 'free',
  preferred_currency  CHAR(3) NOT NULL DEFAULT 'BRL',
  preferred_language  VARCHAR(10) NOT NULL DEFAULT 'pt-BR',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ
);
COMMENT ON TABLE public.users IS 'Perfis de usuário, espelhando auth.users do Supabase';

-- ─── airports ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.airports (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  iata_code       CHAR(3) NOT NULL UNIQUE,
  icao_code       CHAR(4) UNIQUE,
  name            TEXT NOT NULL,
  city            TEXT NOT NULL,
  state           TEXT,
  country         TEXT NOT NULL,
  country_code    CHAR(2) NOT NULL,
  timezone        TEXT NOT NULL,
  latitude        DOUBLE PRECISION NOT NULL,
  longitude       DOUBLE PRECISION NOT NULL,
  altitude        INTEGER,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  is_major        BOOLEAN NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE public.airports IS 'Aeroportos mundiais com localização geográfica';

-- ─── airlines ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.airlines (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  iata_code       CHAR(2) NOT NULL UNIQUE,
  icao_code       CHAR(3) UNIQUE,
  name            TEXT NOT NULL,
  logo_url        TEXT,
  country         TEXT NOT NULL,
  country_code    CHAR(2) NOT NULL,
  alliance        TEXT,                -- oneworld, star_alliance, skyteam
  iata_prefix     CHAR(3),
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE public.airlines IS 'Companhias aéreas com dados de aliança';

-- ─── loyalty_programs ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.loyalty_programs (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name                TEXT NOT NULL,
  short_name          TEXT NOT NULL,
  airline_id          UUID REFERENCES public.airlines(id) ON DELETE SET NULL,
  program_type        loyalty_program_type NOT NULL DEFAULT 'airline',
  logo_url            TEXT,
  points_per_mile     NUMERIC(6,2) NOT NULL DEFAULT 1.0,
  expiration_months   INTEGER,
  transfer_partners   TEXT[] NOT NULL DEFAULT '{}',
  is_active           BOOLEAN NOT NULL DEFAULT TRUE,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── flights ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.flights (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  flight_number    VARCHAR(10) NOT NULL,
  airline_id       UUID NOT NULL REFERENCES public.airlines(id),
  origin_id        UUID NOT NULL REFERENCES public.airports(id),
  destination_id   UUID NOT NULL REFERENCES public.airports(id),
  departure_time   TIMESTAMPTZ NOT NULL,
  arrival_time     TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
  stops            SMALLINT NOT NULL DEFAULT 0 CHECK (stops >= 0),
  aircraft_type    VARCHAR(10),
  is_codeshare     BOOLEAN NOT NULL DEFAULT FALSE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT ck_arrival_after_departure CHECK (arrival_time > departure_time)
);
COMMENT ON TABLE public.flights IS 'Voos indexados para pesquisa rápida';

-- ─── flight_prices ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.flight_prices (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  flight_id             UUID NOT NULL REFERENCES public.flights(id) ON DELETE CASCADE,
  price_brl             NUMERIC(10,2) NOT NULL CHECK (price_brl >= 0),
  price_usd             NUMERIC(10,2),
  miles_required        INTEGER,
  miles_program         TEXT,
  mile_price_brl        NUMERIC(6,4),           -- valor de R$ por milha
  cabin_class           cabin_class NOT NULL DEFAULT 'economy',
  available_seats       SMALLINT,
  baggage_included      BOOLEAN NOT NULL DEFAULT FALSE,
  baggage_allowance_kg  SMALLINT,
  taxes                 NUMERIC(10,2) NOT NULL DEFAULT 0,
  valid_until           TIMESTAMPTZ,
  scraped_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── flight_history ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.flight_history (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  flight_id        UUID NOT NULL REFERENCES public.flights(id) ON DELETE CASCADE,
  price_brl        NUMERIC(10,2) NOT NULL,
  miles_required   INTEGER,
  recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── alerts ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.alerts (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id              UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type                 alert_type NOT NULL DEFAULT 'price',
  name                 TEXT,
  origin_id            UUID REFERENCES public.airports(id),
  destination_id       UUID REFERENCES public.airports(id),
  airline_id           UUID REFERENCES public.airlines(id),
  loyalty_program_id   UUID REFERENCES public.loyalty_programs(id),
  max_price_brl        NUMERIC(10,2),
  max_miles            INTEGER,
  departure_date_from  DATE,
  departure_date_to    DATE,
  cabin_class          cabin_class,
  channels             notification_channel[] NOT NULL DEFAULT '{email}',
  is_active            BOOLEAN NOT NULL DEFAULT TRUE,
  last_triggered_at    TIMESTAMPTZ,
  triggered_count      INTEGER NOT NULL DEFAULT 0,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── notifications ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.notifications (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  alert_id    UUID REFERENCES public.alerts(id) ON DELETE SET NULL,
  channel     notification_channel NOT NULL,
  title       TEXT NOT NULL,
  body        TEXT NOT NULL,
  data        JSONB,
  sent_at     TIMESTAMPTZ,
  read_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── trips ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.trips (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name              TEXT NOT NULL,
  description       TEXT,
  status            trip_status NOT NULL DEFAULT 'planning',
  start_date        DATE,
  end_date          DATE,
  total_price_brl   NUMERIC(12,2),
  total_miles_used  INTEGER,
  total_saved_brl   NUMERIC(12,2),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── trip_segments ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.trip_segments (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trip_id           UUID NOT NULL REFERENCES public.trips(id) ON DELETE CASCADE,
  flight_id         UUID NOT NULL REFERENCES public.flights(id),
  sequence          SMALLINT NOT NULL,
  price_at_booking  NUMERIC(10,2),
  miles_at_booking  INTEGER,
  booked_at         TIMESTAMPTZ,
  UNIQUE (trip_id, sequence)
);

-- ─── hotels ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.hotels (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name            TEXT NOT NULL,
  address         TEXT,
  city            TEXT NOT NULL,
  country         TEXT NOT NULL,
  country_code    CHAR(2) NOT NULL,
  stars           SMALLINT CHECK (stars BETWEEN 1 AND 5),
  amenities       TEXT[] NOT NULL DEFAULT '{}',
  latitude        DOUBLE PRECISION,
  longitude       DOUBLE PRECISION,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── cars ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cars (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  rental_company    TEXT NOT NULL,
  model             TEXT NOT NULL,
  category          TEXT NOT NULL,   -- economy, compact, suv, luxury
  price_per_day_brl NUMERIC(8,2) NOT NULL,
  airport_id        UUID REFERENCES public.airports(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── miles_accounts ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.miles_accounts (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  loyalty_program_id  UUID NOT NULL REFERENCES public.loyalty_programs(id),
  account_number      TEXT,
  balance_miles       INTEGER NOT NULL DEFAULT 0 CHECK (balance_miles >= 0),
  expiration_date     DATE,
  last_updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, loyalty_program_id)
);

-- ─── search_history ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.search_history (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         UUID REFERENCES public.users(id) ON DELETE SET NULL,
  session_id      TEXT,
  origin_id       UUID REFERENCES public.airports(id),
  destination_id  UUID REFERENCES public.airports(id),
  departure_date  DATE NOT NULL,
  return_date     DATE,
  passengers      SMALLINT NOT NULL DEFAULT 1,
  cabin_class     cabin_class NOT NULL DEFAULT 'economy',
  results_count   INTEGER,
  searched_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── favorites ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.favorites (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  flight_id   UUID NOT NULL REFERENCES public.flights(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, flight_id)
);

-- ─── subscriptions ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.subscriptions (
  id                        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                   UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  plan                      subscription_plan NOT NULL DEFAULT 'free',
  status                    subscription_status NOT NULL DEFAULT 'active',
  price_brl                 NUMERIC(8,2) NOT NULL DEFAULT 0,
  billing_cycle             billing_cycle NOT NULL DEFAULT 'monthly',
  provider                  payment_provider,
  provider_subscription_id  TEXT UNIQUE,
  current_period_start      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  current_period_end        TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '1 month'),
  cancel_at_period_end      BOOLEAN NOT NULL DEFAULT FALSE,
  canceled_at               TIMESTAMPTZ,
  trial_end                 TIMESTAMPTZ,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── payments ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.payments (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id              UUID NOT NULL REFERENCES public.users(id),
  subscription_id      UUID REFERENCES public.subscriptions(id),
  amount_brl           NUMERIC(10,2) NOT NULL,
  currency             CHAR(3) NOT NULL DEFAULT 'BRL',
  provider             payment_provider NOT NULL,
  provider_payment_id  TEXT NOT NULL UNIQUE,
  status               payment_status NOT NULL DEFAULT 'pending',
  description          TEXT,
  metadata             JSONB,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── coupons ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.coupons (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code             TEXT NOT NULL UNIQUE,
  discount_percent NUMERIC(5,2) CHECK (discount_percent BETWEEN 0 AND 100),
  discount_brl     NUMERIC(8,2),
  max_uses         INTEGER,
  uses_count       INTEGER NOT NULL DEFAULT 0,
  valid_until      TIMESTAMPTZ,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT ck_has_discount CHECK (
    discount_percent IS NOT NULL OR discount_brl IS NOT NULL
  )
);

-- ─── audit_logs ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID REFERENCES public.users(id) ON DELETE SET NULL,
  action       audit_action NOT NULL,
  entity_type  TEXT NOT NULL,
  entity_id    UUID,
  old_values   JSONB,
  new_values   JSONB,
  ip_address   INET,
  user_agent   TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE public.audit_logs IS 'Log imutável de todas as ações críticas (LGPD, auditoria)';
