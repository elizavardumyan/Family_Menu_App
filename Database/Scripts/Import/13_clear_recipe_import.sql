/*
===============================================================================
 Project : Family Menu App
 Script  : 13_clear_recipe_import.sql
 Purpose : Clear recipe staging table before CSV import

 Founder : Eliza Vardumyan
 Version : 1.0
===============================================================================

Description:
Clears the recipe_import staging table before importing a new recipes.csv
file.

Workflow:

13_clear_recipe_import.sql
        ↓
Import recipes.csv into recipe_import
        ↓
14_import_recipes_from_csv.sql
        ↓
15_verify_recipe_import.sql

Notes:
- Run this script before every new recipe CSV import.
- Only the staging table is cleared.
- Production tables are not affected.

===============================================================================
*/

TRUNCATE TABLE recipe_import;

COMMENT ON TABLE recipe_import IS
'Temporary staging table for recipe CSV import.';

-- End of Script