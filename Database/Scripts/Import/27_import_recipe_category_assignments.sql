-- ============================================================
-- File: 27_import_recipe_category_assignments.sql
-- Project: Family Menu App
-- Author: Eliza Vardumyan
-- Description: Imports recipe-category assignments from the
--              staging table into the production table.
-- ============================================================

INSERT INTO recipe_category_assignments (
    recipe_id,
    category_id
)
SELECT
    r.recipe_id,
    rc.category_id
FROM recipe_category_assignments_import AS i
JOIN recipes AS r
    ON r.recipe_code = i.recipe_code
JOIN recipe_categories AS rc
    ON rc.category_code = i.category_code
ON CONFLICT (recipe_id, category_id) DO NOTHING;