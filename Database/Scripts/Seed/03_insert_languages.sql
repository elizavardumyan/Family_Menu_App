/*
------------------------------------------------------------
Project : Family Menu App
Script  : 03_insert_languages.sql
Purpose : Insert supported application languages
Founder : Eliza Vardumyan
Version : 1.0
------------------------------------------------------------
*/

BEGIN;

INSERT INTO languages (language_code, language_name)
VALUES
('hy', 'Հայերեն'),
('en', 'English')
ON CONFLICT (language_code) DO UPDATE
SET language_name = EXCLUDED.language_name;

COMMIT;