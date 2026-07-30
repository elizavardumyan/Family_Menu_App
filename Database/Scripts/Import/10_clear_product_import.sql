/*
------------------------------------------------------------
Project : Family Menu App
Script  : 10_clear_product_import.sql
Purpose : Clear the product import staging table
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------

Description
------------------------------------------------------------
This script removes all records from the product_import
staging table before importing a new products.csv file.

The table structure remains unchanged.

Workflow
------------------------------------------------------------
1. Run this script.
2. Import products.csv into product_import using pgAdmin.
3. Run 09_import_products_from_csv.sql.
------------------------------------------------------------
*/

-- =========================================================
-- Clear Product Import Staging Table
-- =========================================================

TRUNCATE TABLE product_import;

-- =========================================================
-- End of Script
-- =========================================================