---------------------------------
---------------------------------
select group table with translation groups

---------------------------------
---------------------------------
SELECT
    pg.group_code,
    pg.group_id,
    pgt.language_code,
    pgt.group_name
FROM product_groups AS pg
JOIN product_group_translations AS pgt
    ON pg.group_id = pgt.group_id
ORDER BY
    pg.group_code,
    pgt.language_code;