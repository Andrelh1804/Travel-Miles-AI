-- ============================================================================
-- TravelMiles AI — Seed: Principais Companhias Aéreas
-- ============================================================================

INSERT INTO public.airlines (iata_code, icao_code, name, country, country_code, alliance) VALUES
-- Brasil
('LA', 'LAN', 'LATAM Airlines', 'Brasil', 'BR', 'oneworld'),
('G3', 'GLO', 'Gol Linhas Aéreas', 'Brasil', 'BR', NULL),
('AD', 'AZU', 'Azul Linhas Aéreas', 'Brasil', 'BR', NULL),
-- Internacionais
('AA', 'AAL', 'American Airlines', 'Estados Unidos', 'US', 'oneworld'),
('UA', 'UAL', 'United Airlines', 'Estados Unidos', 'US', 'star_alliance'),
('DL', 'DAL', 'Delta Air Lines', 'Estados Unidos', 'US', 'skyteam'),
('BA', 'BAW', 'British Airways', 'Reino Unido', 'GB', 'oneworld'),
('AF', 'AFR', 'Air France', 'França', 'FR', 'skyteam'),
('LH', 'DLH', 'Lufthansa', 'Alemanha', 'DE', 'star_alliance'),
('IB', 'IBE', 'Iberia', 'Espanha', 'ES', 'oneworld'),
('TP', 'TAP', 'TAP Air Portugal', 'Portugal', 'PT', 'star_alliance'),
('EK', 'UAE', 'Emirates', 'Emirados Árabes Unidos', 'AE', NULL),
('QR', 'QTR', 'Qatar Airways', 'Catar', 'QA', 'oneworld'),
('TK', 'THY', 'Turkish Airlines', 'Turquia', 'TR', 'star_alliance'),
('KL', 'KLM', 'KLM Royal Dutch Airlines', 'Países Baixos', 'NL', 'skyteam'),
('AV', 'AVA', 'Avianca', 'Colômbia', 'CO', 'star_alliance'),
('CM', 'CMP', 'Copa Airlines', 'Panamá', 'PA', 'star_alliance'),
('AR', 'ARG', 'Aerolíneas Argentinas', 'Argentina', 'AR', 'skyteam'),
('JJ', 'TAM', 'LATAM Brasil', 'Brasil', 'BR', 'oneworld')
ON CONFLICT (iata_code) DO NOTHING;
