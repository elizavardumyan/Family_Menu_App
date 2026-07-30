/*
------------------------------------------------------------
Project : Family Menu App
Script  : 06_insert_recipe_categories.sql
Purpose : Insert recipe categories and translations
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------
*/

BEGIN;

------------------------------------------------------------
-- 1. Recipe Categories
------------------------------------------------------------

INSERT INTO recipe_categories (category_code)
VALUES
('breakfast'),
('lunch'),
('dinner'),
('salad'),
('main_course'),
('side_dish'),
('soup'),
('dessert'),
('sauce'),
('snack'),
('drink')
ON CONFLICT (category_code) DO NOTHING;


------------------------------------------------------------
-- 2. Armenian Translations
------------------------------------------------------------

INSERT INTO recipe_category_translations
    (category_id, language_code, category_name)

SELECT
    rc.category_id,
    v.language_code,
    v.category_name

FROM recipe_categories AS rc

JOIN (
    VALUES
        ('breakfast',   'hy', 'Նախաճաշ'),
        ('lunch',       'hy', 'Ճաշ'),
        ('dinner',      'hy', 'Ընթրիք'),
        ('salad',       'hy', 'Աղցան'),
        ('main_course', 'hy', 'Հիմնական ուտեստ'),
        ('side_dish',   'hy', 'Խավարտ'),
        ('soup',        'hy', 'Ապուր'),
        ('dessert',     'hy', 'Աղանդեր'),
        ('sauce',       'hy', 'Սոուս'),
        ('snack',       'hy', 'Խորտիկ'),
        ('drink',       'hy', 'Ըմպելիք')
) AS v(category_code, language_code, category_name)
ON rc.category_code = v.category_code

ON CONFLICT (category_id, language_code)
DO UPDATE
SET category_name = EXCLUDED.category_name;


------------------------------------------------------------
-- 3. English Translations
------------------------------------------------------------

INSERT INTO recipe_category_translations
    (category_id, language_code, category_name)

SELECT
    rc.category_id,
    v.language_code,
    v.category_name

FROM recipe_categories AS rc

JOIN (
    VALUES
        ('breakfast',   'en', 'Breakfast'),
        ('lunch',       'en', 'Lunch'),
        ('dinner',      'en', 'Dinner'),
        ('salad',       'en', 'Salad'),
        ('main_course', 'en', 'Main Course'),
        ('side_dish',   'en', 'Side Dish'),
        ('soup',        'en', 'Soup'),
        ('dessert',     'en', 'Dessert'),
        ('sauce',       'en', 'Sauce'),
        ('snack',       'en', 'Snack'),
        ('drink',       'en', 'Drink')
) AS v(category_code, language_code, category_name)
ON rc.category_code = v.category_code

ON CONFLICT (category_id, language_code)
DO UPDATE
SET category_name = EXCLUDED.category_name;

COMMIT;