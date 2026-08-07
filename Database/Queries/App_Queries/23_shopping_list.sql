SELECT
    p.product_code,
    pt.product_name AS ingredient,
    SUM(rp.quantity) AS total_quantity,
    u.unit_code,
    p.unit_price,
    SUM(rp.quantity * p.unit_price) AS total_product_cost,
    SUM(SUM(rp.quantity * p.unit_price)) OVER () AS shopping_list_total_cost

FROM recipe_products rp

JOIN recipes r
    ON rp.recipe_id = r.recipe_id

JOIN products p
    ON rp.product_id = p.product_id

JOIN product_translations pt
    ON p.product_id = pt.product_id
    AND pt.language_code = 'en'

JOIN units u
    ON rp.unit_id = u.unit_id

WHERE r.recipe_code IN (
    'pancakes',
    'boiled_eggs'
)

GROUP BY
    p.product_id,
    p.product_code,
    pt.product_name,
    u.unit_code,
    p.unit_price

ORDER BY
    pt.product_name;