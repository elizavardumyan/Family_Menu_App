/*
===============================================================================
Project : Family Menu App
Script  : 16_create_recipe_ingredients_import_table.sql
Purpose : Create staging table for recipe ingredient CSV import

Founder : Eliza Vardumyan
Version : 1.0
===============================================================================

CSV column order:

recipe_code
product_code
quantity
unit_code
===============================================================================
*/

DROP TABLE IF EXISTS recipe_ingredients_import;

CREATE TABLE recipe_ingredients_import
(
    recipe_code  VARCHAR(150) NOT NULL,
    product_code VARCHAR(150) NOT NULL,
    quantity     NUMERIC(12,3) NOT NULL,
    unit_code    VARCHAR(50) NOT NULL
);

COMMENT ON TABLE recipe_ingredients_import IS
'Staging table for importing recipe ingredients from CSV.';