/*
------------------------------------------------------------
Project : Family Menu App
Script  : 05_insert_units.sql
Purpose : Insert measurement units and translations
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------
*/
-- NOTE:
-- The unit list is based on the units currently used in the Family Menu App.
-- New units can be added as new recipes require them.

BEGIN;

------------------------------------------------------------
-- 1. Measurement Units
------------------------------------------------------------

INSERT INTO units (unit_code)
VALUES
('kg'),
('g'),
('liter'),
('ml'),
('pcs'),
('tbsp'),
('tsp'),
('clove'),
('bunch'),
('box')
ON CONFLICT (unit_code) DO NOTHING;


------------------------------------------------------------
-- 2. Armenian Translations
------------------------------------------------------------

INSERT INTO unit_translations
    (unit_id, language_code, unit_name)

SELECT
    u.unit_id,
    v.language_code,
    v.unit_name

FROM units AS u

JOIN (
    VALUES
        ('kg',     'hy', 'կգ'),
        ('g',      'hy', 'գ'),
        ('liter',  'hy', 'լ'),
        ('ml',     'hy', 'մլ'),
        ('pcs',    'hy', 'հատ'),
        ('tbsp',   'hy', 'ճաշի գդալ'),
        ('tsp',    'hy', 'թեյի գդալ'),
        ('clove',  'hy', 'պճեղ'),
        ('bunch',  'hy', 'կապ'),
        ('box',    'hy', 'տուփ')
) AS v(unit_code, language_code, unit_name)
ON u.unit_code = v.unit_code

ON CONFLICT (unit_id, language_code)
DO UPDATE
SET unit_name = EXCLUDED.unit_name;


------------------------------------------------------------
-- 3. English Translations
------------------------------------------------------------

INSERT INTO unit_translations
    (unit_id, language_code, unit_name)

SELECT
    u.unit_id,
    v.language_code,
    v.unit_name

FROM units AS u

JOIN (
    VALUES
        ('kg',     'en', 'Kilogram'),
        ('g',      'en', 'Gram'),
        ('liter',  'en', 'Liter'),
        ('ml',     'en', 'Milliliter'),
        ('pcs',    'en', 'Piece'),
        ('tbsp',   'en', 'Tablespoon'),
        ('tsp',    'en', 'Teaspoon'),
        ('clove',  'en', 'Clove'),
        ('bunch',  'en', 'Bunch'),
        ('box',    'en', 'Box')
) AS v(unit_code, language_code, unit_name)
ON u.unit_code = v.unit_code

ON CONFLICT (unit_id, language_code)
DO UPDATE
SET unit_name = EXCLUDED.unit_name;

COMMIT;