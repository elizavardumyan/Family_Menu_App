-- ==========================================
-- 24_weekly_menu_cost.sql
-- Family Menu App
-- Calculate Weekly Menu Cost
-- ==========================================

SELECT
    r.recipe_code,
    rt.recipe_name,

   
	ROUND(SUM(rp.quantity * p.unit_price), 0) AS recipe_cost_amd,

ROUND(
    SUM(SUM(rp.quantity * p.unit_price)) OVER (),
    0
) AS weekly_menu_total_amd

FROM recipe_products rp

JOIN recipes r
    ON rp.recipe_id = r.recipe_id

JOIN recipe_translations rt
    ON r.recipe_id = rt.recipe_id
    AND rt.language_code = 'en'

JOIN products p
    ON rp.product_id = p.product_id

WHERE r.recipe_code IN (
    'pancakes',
    'boiled_eggs',
    'mushroom_omelette'
)

GROUP BY
    r.recipe_id,
    r.recipe_code,
    rt.recipe_name

ORDER BY
    ROUND(SUM(rp.quantity * p.unit_price), 0) DESC;