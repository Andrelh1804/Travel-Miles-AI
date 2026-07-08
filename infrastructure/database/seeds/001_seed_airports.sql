-- ============================================================================
-- TravelMiles AI — Seed: Principais Aeroportos Brasileiros e Internacionais
-- ============================================================================

INSERT INTO public.airports (iata_code, icao_code, name, city, state, country, country_code, timezone, latitude, longitude, is_major) VALUES
-- Brasil
('GRU', 'SBGR', 'Aeroporto Internacional de Guarulhos', 'São Paulo', 'SP', 'Brasil', 'BR', 'America/Sao_Paulo', -23.4356, -46.4731, TRUE),
('CGH', 'SBSP', 'Aeroporto de Congonhas', 'São Paulo', 'SP', 'Brasil', 'BR', 'America/Sao_Paulo', -23.6261, -46.6564, TRUE),
('GIG', 'SBGL', 'Aeroporto Internacional do Galeão', 'Rio de Janeiro', 'RJ', 'Brasil', 'BR', 'America/Sao_Paulo', -22.8099, -43.2505, TRUE),
('SDU', 'SBRJ', 'Aeroporto Santos Dumont', 'Rio de Janeiro', 'RJ', 'Brasil', 'BR', 'America/Sao_Paulo', -22.9105, -43.1631, TRUE),
('BSB', 'SBBR', 'Aeroporto Internacional de Brasília', 'Brasília', 'DF', 'Brasil', 'BR', 'America/Sao_Paulo', -15.8711, -47.9186, TRUE),
('SSA', 'SBSV', 'Aeroporto Internacional de Salvador', 'Salvador', 'BA', 'Brasil', 'BR', 'America/Bahia', -12.9086, -38.3225, TRUE),
('CNF', 'SBCF', 'Aeroporto Internacional de Confins', 'Belo Horizonte', 'MG', 'Brasil', 'BR', 'America/Sao_Paulo', -19.6244, -43.9719, TRUE),
('FOR', 'SBFZ', 'Aeroporto Internacional Pinto Martins', 'Fortaleza', 'CE', 'Brasil', 'BR', 'America/Fortaleza', -3.7762, -38.5326, TRUE),
('REC', 'SBRF', 'Aeroporto Internacional do Recife', 'Recife', 'PE', 'Brasil', 'BR', 'America/Recife', -8.1265, -34.9231, TRUE),
('POA', 'SBPA', 'Aeroporto Internacional de Porto Alegre', 'Porto Alegre', 'RS', 'Brasil', 'BR', 'America/Sao_Paulo', -29.9939, -51.1714, TRUE),
('FLN', 'SBFL', 'Aeroporto Internacional de Florianópolis', 'Florianópolis', 'SC', 'Brasil', 'BR', 'America/Sao_Paulo', -27.6703, -48.5525, FALSE),
('CWB', 'SBCT', 'Aeroporto Internacional Afonso Pena', 'Curitiba', 'PR', 'Brasil', 'BR', 'America/Sao_Paulo', -25.5285, -49.1758, TRUE),
('MAO', 'SBEG', 'Aeroporto Internacional de Manaus', 'Manaus', 'AM', 'Brasil', 'BR', 'America/Manaus', -3.0386, -60.0498, TRUE),
('BEL', 'SBBE', 'Aeroporto Internacional de Belém', 'Belém', 'PA', 'Brasil', 'BR', 'America/Belem', -1.3793, -48.4763, FALSE),
('NVT', 'SBNF', 'Aeroporto Internacional de Navegantes', 'Navegantes', 'SC', 'Brasil', 'BR', 'America/Sao_Paulo', -26.8799, -48.6514, FALSE),
-- EUA
('JFK', 'KJFK', 'John F. Kennedy International Airport', 'New York', 'NY', 'Estados Unidos', 'US', 'America/New_York', 40.6413, -73.7781, TRUE),
('MIA', 'KMIA', 'Miami International Airport', 'Miami', 'FL', 'Estados Unidos', 'US', 'America/New_York', 25.7959, -80.2870, TRUE),
('LAX', 'KLAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 'Estados Unidos', 'US', 'America/Los_Angeles', 33.9416, -118.4085, TRUE),
('ORD', 'KORD', 'O''Hare International Airport', 'Chicago', 'IL', 'Estados Unidos', 'US', 'America/Chicago', 41.9742, -87.9073, TRUE),
-- Europa
('LHR', 'EGLL', 'London Heathrow Airport', 'Londres', NULL, 'Reino Unido', 'GB', 'Europe/London', 51.4775, -0.4614, TRUE),
('CDG', 'LFPG', 'Charles de Gaulle Airport', 'Paris', NULL, 'França', 'FR', 'Europe/Paris', 49.0097, 2.5479, TRUE),
('MAD', 'LEMD', 'Adolfo Suárez Madrid–Barajas Airport', 'Madri', NULL, 'Espanha', 'ES', 'Europe/Madrid', 40.4936, -3.5668, TRUE),
('LIS', 'LPPT', 'Humberto Delgado Airport', 'Lisboa', NULL, 'Portugal', 'PT', 'Europe/Lisbon', 38.7742, -9.1342, TRUE),
-- América do Sul
('EZE', 'SAEZ', 'Ministro Pistarini International Airport', 'Buenos Aires', NULL, 'Argentina', 'AR', 'America/Argentina/Buenos_Aires', -34.8222, -58.5358, TRUE),
('SCL', 'SCEL', 'Comodoro Arturo Merino Benítez Airport', 'Santiago', NULL, 'Chile', 'CL', 'America/Santiago', -33.3930, -70.7858, TRUE),
('BOG', 'SKBO', 'El Dorado International Airport', 'Bogotá', NULL, 'Colômbia', 'CO', 'America/Bogota', 4.7016, -74.1469, TRUE),
-- Ásia / Oriente Médio
('DXB', 'OMDB', 'Dubai International Airport', 'Dubai', NULL, 'Emirados Árabes Unidos', 'AE', 'Asia/Dubai', 25.2528, 55.3644, TRUE),
('GRU', 'SBGR', 'Aeroporto Internacional de Guarulhos', 'São Paulo', 'SP', 'Brasil', 'BR', 'America/Sao_Paulo', -23.4356, -46.4731, TRUE)
ON CONFLICT (iata_code) DO NOTHING;
