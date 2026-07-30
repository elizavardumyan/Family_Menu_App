/*
===============================================================================
Project : Family Menu App
Script  : 20_verify_recipe_ingredients.sql
Purpose : Verify recipe ingredients imported into recipe_products

Founder : Eliza Vardumyan
Version : 1.0
===============================================================================
*/

-- 1. Compare staging and production row counts
SELECT
    (SELECT COUNT(*)
     FROM recipe_ingredients_import) AS staging_rows,

    (SELECT COUNT(*)
     FROM recipe_products) AS production_rows;


-- 2. Verify that every staging row exists in production
-- Expected result: 0 rows

SELECT
    rii.recipe_code,
    rii.product_code,
    rii.quantity,
    rii.unit_code
FROM recipe_ingredients_import AS rii
JOIN recipes AS r
    ON r.recipe_code = rii.recipe_code
JOIN products AS p
    ON p.product_code = rii.product_code
JOIN units AS u
    ON u.unit_code = rii.unit_code
LEFT JOIN recipe_products AS rp
    ON rp.recipe_id = r.recipe_id
   AND rp.product_id = p.product_id
   AND rp.unit_id = u.unit_id
   AND rp.quantity = rii.quantity
WHERE rp.recipe_product_id IS NULL
ORDER BY rii.recipe_code, rii.product_code;


-- 3. Check for duplicate recipe-product relationships
-- Expected result: 0 rows

SELECT
    recipe_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM recipe_products
GROUP BY
    recipe_id,
    product_id
HAVING COUNT(*) > 1
ORDER BY recipe_id, product_id;


-- 4. Display imported recipe ingredients

SELECT
    r.recipe_code,
    p.product_code,
    rp.quantity,
    u.unit_code
FROM recipe_products AS rp
JOIN recipes AS r
    ON r.recipe_id = rp.recipe_id
JOIN products AS p
    ON p.product_id = rp.product_id
JOIN units AS u
    ON u.unit_id = rp.unit_id
ORDER BY r.recipe_code, p.product_code;