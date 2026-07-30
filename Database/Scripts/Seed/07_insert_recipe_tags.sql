/*
------------------------------------------------------------
Project : Family Menu App
Script  : 07_insert_recipe_tags.sql
Purpose : Insert recipe tags and translations
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------
*/

BEGIN;

------------------------------------------------------------
-- 1. Recipe Tags
------------------------------------------------------------

INSERT INTO recipe_tags (tag_code)
VALUES
('vegetarian'),
('vegan'),
('kids'),
('quick'),
('healthy'),
('budget'),
('festive'),
('spicy'),
('high_protein'),
('low_calorie')
ON CONFLICT (tag_code) DO NOTHING;


------------------------------------------------------------
-- 2. Armenian Translations
------------------------------------------------------------

INSERT INTO recipe_tag_translations
    (tag_id, language_code, tag_name)

SELECT
    rt.tag_id,
    v.language_code,
    v.tag_name

FROM recipe_tags AS rt

JOIN (
    VALUES
        ('vegetarian',  'hy', 'Բուսակեր'),
        ('vegan',       'hy', 'Վեգան'),
        ('kids',        'hy', 'Մանկական'),
        ('quick',       'hy', 'Արագ'),
        ('healthy',     'hy', 'Առողջարար'),
        ('budget',      'hy', 'Բյուջետային'),
        ('festive',     'hy', 'Տոնական'),
        ('spicy',       'hy', 'Կծու'),
        ('high_protein','hy', 'Բարձր սպիտակուցային'),
        ('low_calorie', 'hy', 'Ցածր կալորիական')
) AS v(tag_code, language_code, tag_name)
ON rt.tag_code = v.tag_code

ON CONFLICT (tag_id, language_code)
DO UPDATE
SET tag_name = EXCLUDED.tag_name;


------------------------------------------------------------
-- 3. English Translations
------------------------------------------------------------

INSERT INTO recipe_tag_translations
    (tag_id, language_code, tag_name)

SELECT
    rt.tag_id,
    v.language_code,
    v.tag_name

FROM recipe_tags AS rt

JOIN (
    VALUES
        ('vegetarian',  'en', 'Vegetarian'),
        ('vegan',       'en', 'Vegan'),
        ('kids',        'en', 'Kids'),
        ('quick',       'en', 'Quick'),
        ('healthy',     'en', 'Healthy'),
        ('budget',      'en', 'Budget Friendly'),
        ('festive',     'en', 'Festive'),
        ('spicy',       'en', 'Spicy'),
        ('high_protein','en', 'High Protein'),
        ('low_calorie', 'en', 'Low Calorie')
) AS v(tag_code, language_code, tag_name)
ON rt.tag_code = v.tag_code

ON CONFLICT (tag_id, language_code)
DO UPDATE
SET tag_name = EXCLUDED.tag_name;

COMMIT;