-- ============================================================================
-- TravelMiles AI — Índices para performance
-- ============================================================================

-- users
CREATE INDEX idx_users_email        ON public.users (email);
CREATE INDEX idx_users_role         ON public.users (role) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_subscription ON public.users (subscription_plan);
CREATE INDEX idx_users_deleted      ON public.users (deleted_at) WHERE deleted_at IS NOT NULL;

-- airports (lookup por IATA + busca textual)
CREATE INDEX idx_airports_iata        ON public.airports (iata_code);
CREATE INDEX idx_airports_country     ON public.airports (country_code);
CREATE INDEX idx_airports_active      ON public.airports (is_active, is_major);
CREATE INDEX idx_airports_name_trgm   ON public.airports USING gin (name gin_trgm_ops);
CREATE INDEX idx_airports_city_trgm   ON public.airports USING gin (city gin_trgm_ops);

-- airlines
CREATE INDEX idx_airlines_iata        ON public.airlines (iata_code);
CREATE INDEX idx_airlines_active      ON public.airlines (is_active);
CREATE INDEX idx_airlines_alliance    ON public.airlines (alliance) WHERE alliance IS NOT NULL;

-- flights (pesquisa principal — cobrindo as colunas mais acessadas)
CREATE INDEX idx_flights_route          ON public.flights (origin_id, destination_id, departure_time);
CREATE INDEX idx_flights_departure_date ON public.flights (DATE(departure_time));
CREATE INDEX idx_flights_airline        ON public.flights (airline_id);
CREATE INDEX idx_flights_departure_time ON public.flights (departure_time);

-- flight_prices (filtragem de preços)
CREATE INDEX idx_flight_prices_flight      ON public.flight_prices (flight_id);
CREATE INDEX idx_flight_prices_brl         ON public.flight_prices (price_brl);
CREATE INDEX idx_flight_prices_miles       ON public.flight_prices (miles_required) WHERE miles_required IS NOT NULL;
CREATE INDEX idx_flight_prices_cabin       ON public.flight_prices (cabin_class);
CREATE INDEX idx_flight_prices_scraped     ON public.flight_prices (scraped_at DESC);
CREATE INDEX idx_flight_prices_valid_until ON public.flight_prices (valid_until) WHERE valid_until IS NOT NULL;

-- flight_history (série temporal)
CREATE INDEX idx_flight_history_flight      ON public.flight_history (flight_id, recorded_at DESC);
CREATE INDEX idx_flight_history_recorded_at ON public.flight_history (recorded_at DESC);

-- alerts
CREATE INDEX idx_alerts_user     ON public.alerts (user_id, is_active);
CREATE INDEX idx_alerts_active   ON public.alerts (is_active) WHERE is_active = TRUE;
CREATE INDEX idx_alerts_route    ON public.alerts (origin_id, destination_id) WHERE is_active = TRUE;

-- notifications
CREATE INDEX idx_notifications_user   ON public.notifications (user_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON public.notifications (user_id) WHERE read_at IS NULL;

-- trips
CREATE INDEX idx_trips_user   ON public.trips (user_id, created_at DESC);
CREATE INDEX idx_trips_status ON public.trips (status);

-- miles_accounts
CREATE INDEX idx_miles_accounts_user ON public.miles_accounts (user_id);

-- search_history
CREATE INDEX idx_search_history_user    ON public.search_history (user_id, searched_at DESC) WHERE user_id IS NOT NULL;
CREATE INDEX idx_search_history_route   ON public.search_history (origin_id, destination_id, departure_date);
CREATE INDEX idx_search_history_date    ON public.search_history (searched_at DESC);

-- favorites
CREATE INDEX idx_favorites_user ON public.favorites (user_id);

-- subscriptions
CREATE INDEX idx_subscriptions_user   ON public.subscriptions (user_id);
CREATE INDEX idx_subscriptions_status ON public.subscriptions (status);
CREATE INDEX idx_subscriptions_period ON public.subscriptions (current_period_end) WHERE status = 'active';

-- payments
CREATE INDEX idx_payments_user   ON public.payments (user_id, created_at DESC);
CREATE INDEX idx_payments_status ON public.payments (status);

-- audit_logs (nunca deletar, particionar por data em produção)
CREATE INDEX idx_audit_logs_user        ON public.audit_logs (user_id, created_at DESC);
CREATE INDEX idx_audit_logs_entity      ON public.audit_logs (entity_type, entity_id);
CREATE INDEX idx_audit_logs_action      ON public.audit_logs (action, created_at DESC);
CREATE INDEX idx_audit_logs_created_at  ON public.audit_logs (created_at DESC);
