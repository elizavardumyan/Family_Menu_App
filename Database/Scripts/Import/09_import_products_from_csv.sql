/*
------------------------------------------------------------
Project : Family Menu App
Script  : 09_import_products_from_csv.sql
Purpose : Synchronize imported product data with main tables
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------

Description
------------------------------------------------------------
This script reads product data from the product_import
staging table and synchronizes it with:

1. products
2. product_translations

Existing products are updated by product_code.
New products are inserted.

Workflow
------------------------------------------------------------
1. Run 10_clear_product_import.sql.
2. Import products.csv into product_import using pgAdmin.
3. Run this script.
4. Verify the imported and updated product data.
------------------------------------------------------------
*/

BEGIN;

-- =========================================================
-- 1. Insert new products or update existing products
-- =========================================================

INSERT INTO products (
    product_code,
    group_id,
    unit_id,
    unit_price
)
SELECT
    TRIM(pi.product_code),
    pg.group_id,
    u.unit_id,
    pi.unit_price
FROM product_import AS pi
JOIN product_groups AS pg
    ON pg.group_code = TRIM(pi.group_code)
JOIN units AS u
    ON u.unit_code = TRIM(pi.unit_code)
WHERE pi.product_code IS NOT NULL
  AND TRIM(pi.product_code) <> ''

ON CONFLICT (product_code)
DO UPDATE SET
    group_id   = EXCLUDED.group_id,
    unit_id    = EXCLUDED.unit_id,
    unit_price = EXCLUDED.unit_price;


-- =========================================================
-- 2. Insert or update Armenian product translations
-- =========================================================

INSERT INTO product_translations (
    product_id,
    language_code,
    product_name
)
SELECT
    p.product_id,
    'hy',
    TRIM(pi.product_name_hy)
FROM product_import AS pi
JOIN products AS p
    ON p.product_code = TRIM(pi.product_code)
WHERE pi.product_name_hy IS NOT NULL
  AND TRIM(pi.product_name_hy) <> ''

ON CONFLICT (product_id, language_code)
DO UPDATE SET
    product_name = EXCLUDED.product_name;


-- =========================================================
-- 3. Insert or update English product translations
-- =========================================================

INSERT INTO product_translations (
    product_id,
    language_code,
    product_name
)
SELECT
    p.product_id,
    'en',
    TRIM(pi.product_name_en)
FROM product_import AS pi
JOIN products AS p
    ON p.product_code = TRIM(pi.product_code)
WHERE pi.product_name_en IS NOT NULL
  AND TRIM(pi.product_name_en) <> ''

ON CONFLICT (product_id, language_code)
DO UPDATE SET
    product_name = EXCLUDED.product_name;

COMMIT;

-- =========================================================
-- End of Script
-- =========================================================