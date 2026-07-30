/*
------------------------------------------------------------
Project : Family Menu App
Script  : 04_insert_product_groups.sql
Purpose : Insert product groups and translations
Founder : Eliza Vardumyan
Version : 1.1
------------------------------------------------------------
*/

BEGIN;

------------------------------------------------------------
-- Product Groups
------------------------------------------------------------

INSERT INTO product_groups (group_code)
VALUES
('vegetables'),
('fruits'),
('meat_fish_poultry'),
('groceries'),
('dairy_eggs'),
('bakery'),
('ready_meals'),
('canned_food'),
('household_chemicals'),
('personal_care'),
('pet_products'),
('greens'),
('beverages'),
('sausages'),
('nuts'),
('spices')
ON CONFLICT (group_code) DO NOTHING;

------------------------------------------------------------
-- Armenian Translations
------------------------------------------------------------

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Բանջարեղեն'
FROM product_groups pg
WHERE pg.group_code = 'vegetables'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Մրգեր'
FROM product_groups pg
WHERE pg.group_code = 'fruits'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Միս, ձուկ, հավ'
FROM product_groups pg
WHERE pg.group_code = 'meat_fish_poultry'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Նպարեղեն'
FROM product_groups pg
WHERE pg.group_code = 'groceries'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Կաթնամթերք և ձու'
FROM product_groups pg
WHERE pg.group_code = 'dairy_eggs'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Հացաբուլկեղեն'
FROM product_groups pg
WHERE pg.group_code = 'bakery'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Պատրաստի ուտեստներ'
FROM product_groups pg
WHERE pg.group_code = 'ready_meals'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Պահածոներ'
FROM product_groups pg
WHERE pg.group_code = 'canned_food'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Կենցաղային քիմիա'
FROM product_groups pg
WHERE pg.group_code = 'household_chemicals'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Անձնական խնամք'
FROM product_groups pg
WHERE pg.group_code = 'personal_care'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Կենդանիների համար'
FROM product_groups pg
WHERE pg.group_code = 'pet_products'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Կանաչի'
FROM product_groups pg
WHERE pg.group_code = 'greens'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Ըմպելիքներ'
FROM product_groups pg
WHERE pg.group_code = 'beverages'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Երշիկեղեն'
FROM product_groups pg
WHERE pg.group_code = 'sausages'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Ընդեղեն'
FROM product_groups pg
WHERE pg.group_code = 'nuts'
ON CONFLICT DO NOTHING;

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT pg.group_id, 'hy', 'Համեմունքներ'
FROM product_groups pg
WHERE pg.group_code = 'spices'
ON CONFLICT DO NOTHING;

------------------------------------------------------------
-- English Translations
------------------------------------------------------------

INSERT INTO product_group_translations
(group_id, language_code, group_name)

SELECT
    pg.group_id,
    'en',
    REPLACE(INITCAP(pg.group_code), '_', ' ')
FROM product_groups pg
ON CONFLICT DO NOTHING;
BEGIN;

-- Add sauces group
INSERT INTO product_groups (group_code)
VALUES ('sauces')
ON CONFLICT (group_code) DO NOTHING;

-- Armenian translation
INSERT INTO product_group_translations
    (group_id, language_code, group_name)
SELECT
    pg.group_id,
    'hy',
    'Սոուսներ'
FROM product_groups AS pg
WHERE pg.group_code = 'sauces'
ON CONFLICT (group_id, language_code)
DO UPDATE
SET group_name = EXCLUDED.group_name;

-- English translation
INSERT INTO product_group_translations
    (group_id, language_code, group_name)
SELECT
    pg.group_id,
    'en',
    'Sauces'
FROM product_groups AS pg
WHERE pg.group_code = 'sauces'
ON CONFLICT (group_id, language_code)
DO UPDATE
SET group_name = EXCLUDED.group_name;

COMMIT;

COMMIT;