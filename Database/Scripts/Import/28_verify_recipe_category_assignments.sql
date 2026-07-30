-- ============================================================
-- File: 28_verify_recipe_category_assignments.sql
-- Project: Family Menu App
-- Author: Eliza Vardumyan
-- Description: Verifies recipe-category assignment import.
-- ============================================================

-- 1. Compare staging and production counts
SELECT
    (SELECT COUNT(*)
     FROM recipe_category_assignments_import) AS staging_rows,

    (SELECT COUNT(*)
     FROM recipe_category_assignments) AS production_rows;


-- 2. Check for recipe codes that were not matched
SELECT
    i.recipe_code
FROM recipe_category_assignments_import AS i
LEFT JOIN recipes AS r
    ON r.recipe_code = i.recipe_code
WHERE r.recipe_id IS NULL;


-- 3. Check for category codes that were not matched
SELECT
    i.category_code
FROM recipe_category_assignments_import AS i
LEFT JOIN recipe_categories AS rc
    ON rc.category_code = i.category_code
WHERE rc.category_id IS NULL;


-- 4. Show imported assignments
SELECT
    r.recipe_code,
    rc.category_code
FROM recipe_category_assignments AS rca
JOIN recipes AS r
    ON r.recipe_id = rca.recipe_id
JOIN recipe_categories AS rc
    ON rc.category_id = rca.category_id
ORDER BY
    r.recipe_code,
    rc.category_code;