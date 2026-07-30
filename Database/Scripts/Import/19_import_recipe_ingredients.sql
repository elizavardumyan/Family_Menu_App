/*
===============================================================================
Project : Family Menu App
Script  : 19_import_recipe_ingredients.sql
Purpose : Import validated recipe ingredients into recipe_products

Founder : Eliza Vardumyan
Version : 1.0
===============================================================================
*/

BEGIN;

INSERT INTO recipe_products
(
    recipe_id,
    product_id,
    unit_id,
    quantity
)
SELECT
    r.recipe_id,
    p.product_id,
    u.unit_id,
    rii.quantity
FROM recipe_ingredients_import AS rii
JOIN recipes AS r
    ON r.recipe_code = rii.recipe_code
JOIN products AS p
    ON p.product_code = rii.product_code
JOIN units AS u
    ON u.unit_code = rii.unit_code
ON CONFLICT (recipe_id, product_id)
DO UPDATE SET
    unit_id = EXCLUDED.unit_id,
    quantity = EXCLUDED.quantity;

COMMIT;