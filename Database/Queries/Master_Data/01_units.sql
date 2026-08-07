---------------------------------
---------------------------------
select unit table with translation units

---------------------------------
---------------------------------
SELECT
    u.unit_code,
    ut.language_code,
    ut.unit_name
FROM units AS u
JOIN unit_translations AS ut
    ON u.unit_id = ut.unit_id
ORDER BY
    u.unit_code,
    ut.language_code;