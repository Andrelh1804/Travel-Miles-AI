-- ============================================================================
-- TravelMiles AI — Seed: Programas de Fidelidade
-- ============================================================================

INSERT INTO public.loyalty_programs (name, short_name, program_type, points_per_mile, expiration_months, transfer_partners) VALUES
-- Brasileiros
('LATAM Pass',          'latam_pass',  'airline', 1.0,  24,  ARRAY['Smiles','Livelo']),
('Smiles (Gol)',        'smiles',      'airline', 1.0,  36,  ARRAY['LATAM Pass','Livelo']),
('TudoAzul',           'tudoazul',    'airline', 1.0,  NULL, ARRAY['Livelo']),
('Livelo',             'livelo',      'bank',    1.0,  24,  ARRAY['LATAM Pass','Smiles','TudoAzul']),
('Esfera',             'esfera',      'bank',    1.0,  24,  ARRAY['LATAM Pass','Smiles']),
('Itaú Personnalité',  'itau_pers',   'bank',    1.0,  24,  ARRAY['LATAM Pass','Smiles']),
-- Internacionais
('AAdvantage (AA)',     'aadvantage',  'airline', 1.0,  NULL, ARRAY[]::TEXT[]),
('MileagePlus (UA)',    'mileageplus', 'airline', 1.0,  NULL, ARRAY[]::TEXT[]),
('SkyMiles (DL)',       'skymiles',    'airline', 1.0,  NULL, ARRAY[]::TEXT[]),
('Executive Club (BA)', 'avios',      'airline', 1.0,  NULL, ARRAY['IberiaPLus']),
('Miles&More (LH)',    'miles_more',  'airline', 1.0,  36,  ARRAY[]::TEXT[]),
('Skywards (EK)',       'skywards',   'airline', 1.0,  NULL, ARRAY[]::TEXT[]),
('Privilege Club (QR)', 'qmiles',    'airline', 1.0,  NULL, ARRAY[]::TEXT[])
ON CONFLICT DO NOTHING;
