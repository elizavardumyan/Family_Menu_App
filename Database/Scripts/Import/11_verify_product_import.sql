-- Total products
SELECT COUNT(*) AS total_products
FROM products;

-- Total translations
SELECT COUNT(*) AS total_translations
FROM product_translations;

-- Verify one product
SELECT
    p.product_code,
    p.unit_price,
    pt.language_code,
    pt.product_name
FROM products p
JOIN product_translations pt
    ON p.product_id = pt.product_id
WHERE p.product_code = 'ketchup'
ORDER BY pt.language_code;
SELECT
    p.product_code,
    p.unit_price,
    pt.language_code,
    pt.product_name
FROM products p
JOIN product_translations pt
    ON p.product_id = pt.product_id
WHERE p.product_code IN ('lavash', 'adjarian_dough')
ORDER BY p.product_code, pt.language_code;