/*
===============================================================================
Project : Family Menu App
Script  : 17_clear_recipe_ingredients_import.sql
Purpose : Clear the recipe ingredient staging table before CSV import

Founder : Eliza Vardumyan
Version : 1.0
===============================================================================
*/

TRUNCATE TABLE recipe_ingredients_import;

COMMENT ON TABLE recipe_ingredients_import IS
'Staging table cleared before importing recipe_ingredients.csv.';