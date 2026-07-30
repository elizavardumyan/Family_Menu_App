/*
===============================================================================
Project : Family Menu App
Script  : 18_verify_recipe_ingredients_import.sql
Purpose : Verify recipe ingredient data in the staging table

Founder : Eliza Vardumyan
Version : 1.0
===============================================================================

Checks:

1. Number of staging rows
2. Missing recipe codes
3. Missing product codes
4. Missing unit codes
5. Invalid quantities
6. Duplicate recipe-product combinations
===============================================================================
*/

-- =========================================================
-- 1. Number of rows in the staging table
-- =========================================================

SELECT
    COUNT(*) AS staging_rows
FROM recipe_ingredients_import;


-- =========================================================
-- 2. Recipe codes that do not exist in recipes
-- Expected result: 0 rows
-- =========================================================

SELECT DISTINCT
    rii.recipe_code
FROM recipe_ingredients_import AS rii
LEFT JOIN recipes AS r
    ON r.recipe_code = rii.recipe_code
WHERE r.recipe_id IS NULL
ORDER BY rii.recipe_code;


-- =========================================================
-- 3. Product codes that do not exist in products
-- Expected result: 0 rows
-- =========================================================

SELECT DISTINCT
    rii.product_code
FROM recipe_ingredients_import AS rii
LEFT JOIN products AS p
    ON p.product_code = rii.product_code
WHERE p.product_id IS NULL
ORDER BY rii.product_code;


-- =========================================================
-- 4. Unit codes that do not exist in units
-- Expected result: 0 rows
-- =========================================================

SELECT DISTINCT
    rii.unit_code
FROM recipe_ingredients_import AS rii
LEFT JOIN units AS u
    ON u.unit_code = rii.unit_code
WHERE u.unit_id IS NULL
ORDER BY rii.unit_code;


-- =========================================================
-- 5. Invalid quantities
-- Expected result: 0 rows
-- =========================================================

SELECT
    recipe_code,
    product_code,
    quantity,
    unit_code
FROM recipe_ingredients_import
WHERE quantity IS NULL
   OR quantity <= 0
ORDER BY recipe_code, product_code;


-- =========================================================
-- 6. Duplicate recipe-product combinations
-- Expected result: 0 rows
-- =========================================================

SELECT
    recipe_code,
    product_code,
    COUNT(*) AS duplicate_count
FROM recipe_ingredients_import
GROUP BY
    recipe_code,
    product_code
HAVING COUNT(*) > 1
ORDER BY
    recipe_code,
    product_code;