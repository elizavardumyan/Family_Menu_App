-- ============================================================
-- File: 29_create_weekly_menu_tables.sql
-- Project: Family Menu App
-- Description: Creates tables for saving weekly meal plans.
-- ============================================================

CREATE TABLE weekly_menus (
    weekly_menu_id SERIAL PRIMARY KEY,
    week_start_date DATE NOT NULL,
    servings INTEGER NOT NULL CHECK (servings > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE weekly_menu_items (
    weekly_menu_item_id SERIAL PRIMARY KEY,
    weekly_menu_id INTEGER NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    meal_type VARCHAR(20) NOT NULL,
    recipe_id INTEGER NOT NULL,

    CONSTRAINT fk_weekly_menu
        FOREIGN KEY (weekly_menu_id)
        REFERENCES weekly_menus(weekly_menu_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_weekly_menu_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipes(recipe_id),

    CONSTRAINT chk_day_of_week
        CHECK (
            day_of_week IN (
                'monday',
                'tuesday',
                'wednesday',
                'thursday',
                'friday',
                'saturday',
                'sunday'
            )
        ),

    CONSTRAINT chk_meal_type
        CHECK (
            meal_type IN (
                'breakfast',
                'lunch',
                'dinner',
                'snack'
            )
        ),

    CONSTRAINT uq_weekly_menu_slot
        UNIQUE (
            weekly_menu_id,
            day_of_week,
            meal_type
        )
);