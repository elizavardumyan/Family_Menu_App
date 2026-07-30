/*
------------------------------------------------------------
Project : Family Menu App
Script  : 08_create_product_import_table.sql
Purpose : Create staging table for product CSV import
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------

Description
------------------------------------------------------------
This script creates the temporary staging table used to
import products from products.csv.

The table is created only once during the initial database
setup.

Workflow
------------------------------------------------------------
1. Create the product_import table.
2. Import products.csv into product_import using pgAdmin.
3. Run 09_import_products_from_csv.sql to synchronize
   the data with the main database.
------------------------------------------------------------
*/

-- =========================================================
-- Create Product Import Staging Table
-- Run only once during database setup
-- =========================================================

CREATE TABLE IF NOT EXISTS product_import (
    product_code     VARCHAR(150),
    group_code       VARCHAR(100),
    unit_code        VARCHAR(50),
    unit_price       NUMERIC(12,2),
    product_name_hy  VARCHAR(150),
    product_name_en  VARCHAR(150)
);

-- =========================================================
-- End of Script
-- =========================================================