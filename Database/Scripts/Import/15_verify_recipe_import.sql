/*
===============================================================================
 Project : Family Menu App
 Script  : 15_verify_recipe_import.sql
 Purpose : Verify recipe import results

 Founder : Eliza Vardumyan
 Version : 1.0
===============================================================================

Description:
Checks that recipes and recipe translations were imported correctly
from the recipe_import staging table into the production tables.

Checks:
- Number of rows in the staging table
- Number of recipes in production
- Recipe names in Armenian and English
- Duplicate recipe codes
- Missing Armenian translations
- Missing English translations

===============================================================================
*/

------------------------------------------------------------------------------
-- 1. Count rows in the staging table
------------------------------------------------------------------------------

SELECT COUNT(*) AS staging_recipe_count
FROM recipe_import;

------------------------------------------------------------------------------
-- 2. Count recipes in the production table
------------------------------------------------------------------------------

SELECT COUNT(*) AS production_recipe_count
FROM recipes;

------------------------------------------------------------------------------
-- 3. Preview imported recipes and translations
------------------------------------------------------------------------------

SELECT
    r.recipe_id,
    r.recipe_code,
    r.base_servings,
    r.source_url,
    hy.recipe_name AS recipe_name_hy,
    en.recipe_name AS recipe_name_en
FROM recipes AS r

LEFT JOIN recipe_translations AS hy
    ON hy.recipe_id = r.recipe_id
   AND hy.language_code = 'hy'

LEFT JOIN recipe_translations AS en
    ON en.recipe_id = r.recipe_id
   AND en.language_code = 'en'

ORDER BY r.recipe_id
LIMIT 20;

------------------------------------------------------------------------------
-- 4. Check for duplicate recipe codes
------------------------------------------------------------------------------

SELECT
    recipe_code,
    COUNT(*) AS duplicate_count
FROM recipes
GROUP BY recipe_code
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------
-- 5. Check for missing Armenian translations
------------------------------------------------------------------------------

SELECT
    r.recipe_id,
    r.recipe_code
FROM recipes AS r

LEFT JOIN recipe_translations AS rt
    ON rt.recipe_id = r.recipe_id
   AND rt.language_code = 'hy'

WHERE rt.recipe_id IS NULL;

------------------------------------------------------------------------------
-- 6. Check for missing English translations
------------------------------------------------------------------------------

SELECT
    r.recipe_id,
    r.recipe_code
FROM recipes AS r

LEFT JOIN recipe_translations AS rt
    ON rt.recipe_id = r.recipe_id
   AND rt.language_code = 'en'

WHERE rt.recipe_id IS NULL;

-- End of Script