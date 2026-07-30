-- ============================================================
-- File: 25_create_recipe_category_assignments_import_table.sql
-- Project: Family Menu App
-- Author: Eliza Vardumyan
-- Description: Creates the staging table for importing
--              recipe-category assignments from CSV.
-- ============================================================

DROP TABLE IF EXISTS recipe_category_assignments_import;

CREATE TABLE recipe_category_assignments_import (
    recipe_code   VARCHAR(100) NOT NULL,
    category_code VARCHAR(100) NOT NULL
);

COMMENT ON TABLE recipe_category_assignments_import IS
'Staging table for importing recipe-category assignments from CSV.';