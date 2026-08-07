/*
===============================================================================
Project : Family Menu App
Script  : 22_recipe_cost.sql
Purpose : Calculate ingredient cost and total recipe cost
===============================================================================
*/

SELECT
    r.recipe_code,
    rt.recipe_name,
    p.product_code,
    pt.product_name AS ingredient,
    rp.quantity,
    u.unit_code,
    p.unit_price,

    ROUND(
        rp.quantity * p.unit_price,
        2
    ) AS ingredient_cost,

    ROUND(
        SUM(rp.quantity * p.unit_price)
            OVER (PARTITION BY r.recipe_id),
        2
    ) AS total_recipe_cost

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

--WHERE r.recipe_code = 'pancakes'

ORDER BY
    rt.recipe_name,
    pt.product_name;