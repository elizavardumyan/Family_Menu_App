/*
===============================================================================
 Project : Family Menu App
 Script  : 11_create_recipe_import_table.sql
 Purpose : Create staging table for recipe CSV import

 Founder : Eliza Vardumyan
 Version : 1.0
===============================================================================

Description:
Creates a temporary staging table used to import recipes from a CSV file
before synchronizing them with the production tables.

Workflow:

recipes.csv
      ↓
recipe_import
      ↓
recipes
recipe_translations

Notes:
- This table is a staging table.
- Data is imported from a CSV file.
- The table is cleared before every new import.
- Recipe categories, tags, and ingredients are imported separately.

===============================================================================
*/

DROP TABLE IF EXISTS recipe_import;

CREATE TABLE recipe_import
(
    recipe_code     VARCHAR(150) NOT NULL,
    recipe_name_hy  TEXT NOT NULL,
    recipe_name_en  TEXT NOT NULL,
    base_servings   INTEGER,
    source_url      TEXT
);


COMMENT ON TABLE recipe_import IS
'Temporary staging table for recipe CSV import.';

COMMENT ON COLUMN recipe_import.recipe_code IS
'Unique business identifier for the recipe.';

COMMENT ON COLUMN recipe_import.base_servings IS
'Default number of servings for the recipe.';

COMMENT ON COLUMN recipe_import.source_url IS
'Recipe source URL (Instagram, website, etc.).';

COMMENT ON COLUMN recipe_import.recipe_name_hy IS
'Recipe name in Armenian.';

COMMENT ON COLUMN recipe_import.recipe_name_en IS
'Recipe name in English.';

-- End of Script