/*
===============================================================================
 Project : Family Menu App
 Script  : 14_import_recipes_from_csv.sql
 Purpose : Import recipes from recipe_import into production tables

 Founder : Eliza Vardumyan
 Version : 1.0
===============================================================================

Description:
Imports recipe data from the recipe_import staging table into the
production tables.

Workflow:

13_clear_recipe_import.sql
        ↓
Import recipes.csv into recipe_import
        ↓
14_import_recipes_from_csv.sql
        ↓
15_verify_recipe_import.sql

Notes:
- Existing recipes are updated.
- New recipes are inserted.
- Armenian and English translations are synchronized.
- Categories, tags, and recipe ingredients are imported separately.

===============================================================================
*/

BEGIN;

------------------------------------------------------------------------------
-- Import Recipes
------------------------------------------------------------------------------

INSERT INTO recipes (
    recipe_code,
    base_servings,
    source_url
)
SELECT
    recipe_code,
    base_servings,
    source_url
FROM recipe_import

ON CONFLICT (recipe_code)
DO UPDATE
SET
    base_servings = EXCLUDED.base_servings,
    source_url    = EXCLUDED.source_url;

------------------------------------------------------------------------------
-- Import Armenian Recipe Names
------------------------------------------------------------------------------

INSERT INTO recipe_translations (
    recipe_id,
    language_code,
    recipe_name
)
SELECT
    r.recipe_id,
    'hy',
    ri.recipe_name_hy
FROM recipe_import AS ri
JOIN recipes AS r
    ON r.recipe_code = ri.recipe_code

ON CONFLICT (recipe_id, language_code)
DO UPDATE
SET
    recipe_name = EXCLUDED.recipe_name;

------------------------------------------------------------------------------
-- Import English Recipe Names
------------------------------------------------------------------------------

INSERT INTO recipe_translations (
    recipe_id,
    language_code,
    recipe_name
)
SELECT
    r.recipe_id,
    'en',
    ri.recipe_name_en
FROM recipe_import AS ri
JOIN recipes AS r
    ON r.recipe_code = ri.recipe_code

ON CONFLICT (recipe_id, language_code)
DO UPDATE
SET
    recipe_name = EXCLUDED.recipe_name;

COMMIT;

-- End of Script