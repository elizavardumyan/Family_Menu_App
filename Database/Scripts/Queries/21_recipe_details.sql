/*
===============================================================================
Project : Family Menu App
Script  : 21_recipe_details.sql
Purpose : Display recipes with ingredients
===============================================================================
*/

SELECT
    r.recipe_code,
    rt.recipe_name,
    p.product_code,
    pt.product_name AS ingredient,
    rp.quantity,
    u.unit_code
FROM recipe_products rp

JOIN recipes r
    ON rp.recipe_id = r.recipe_id

JOIN recipe_translations rt
    ON r.recipe_id = rt.recipe_id
   AND rt.language_code = 'en'

JOIN products p
    ON rp.product_id = p.product_id

JOIN product_translations pt
    ON p.product_id = pt.product_id
   AND pt.language_code = 'en'

JOIN units u
    ON rp.unit_id = u.unit_id

ORDER BY
    rt.recipe_name,
    pt.product_name;


-- ==========================================================
-- Examples
-- ==========================================================

-- Show one recipe
-- WHERE r.recipe_code = 'adjarian_khachapuri';

-- Show all recipes containing eggs
-- WHERE p.product_code = 'chicken_egg';

-- Show recipes that use cheese
-- WHERE p.product_code = 'lori_cheese';