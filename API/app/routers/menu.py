from fastapi import APIRouter, HTTPException

from ..database import get_connection
from ..schemas.menu import (
    WeeklyMenuRequest,
    WeeklyMenuUpdateRequest,
)
from ..services.shopping_list import build_shopping_list


router = APIRouter(
    prefix="/weekly-menu",
    tags=["weekly-menu"],
)


@router.post("")
def create_weekly_menu(request: WeeklyMenuRequest):
    result = []
    recipe_counts = {}

    with get_connection() as conn:
        with conn.cursor() as cur:

            # 1. Create weekly menu
            cur.execute("""
                INSERT INTO weekly_menus (
                    week_start_date,
                    servings
                )
                VALUES (%s, %s)
                RETURNING weekly_menu_id;
            """, (
                request.week_start_date,
                request.servings,
            ))

            weekly_menu_id = cur.fetchone()[0]

            # 2. Process each day
            for day in request.days:
                day_result = {
                    "day": day.day,
                    "breakfast": None,
                    "lunch": None,
                    "dinner": None,
                    "snack": None,
                }

                meal_slots = {
                    "breakfast": day.breakfast_recipe_id,
                    "lunch": day.lunch_recipe_id,
                    "dinner": day.dinner_recipe_id,
                    "snack": day.snack_recipe_id,
                }

                for meal_type, recipe_id in meal_slots.items():
                    if recipe_id is None:
                        continue

                    recipe_counts[recipe_id] = (
                        recipe_counts.get(recipe_id, 0) + 1
                    )

                    # 3. Check recipe and get names
                    cur.execute("""
                        SELECT
                            r.recipe_id,
                            r.recipe_code,
                            MAX(CASE
                                WHEN rt.language_code = 'en'
                                THEN rt.recipe_name
                            END) AS recipe_name_en,
                            MAX(CASE
                                WHEN rt.language_code = 'hy'
                                THEN rt.recipe_name
                            END) AS recipe_name_hy
                        FROM recipes AS r
                        LEFT JOIN recipe_translations AS rt
                            ON rt.recipe_id = r.recipe_id
                        WHERE r.recipe_id = %s
                        GROUP BY
                            r.recipe_id,
                            r.recipe_code;
                    """, (recipe_id,))

                    recipe = cur.fetchone()

                    if recipe is None:
                        raise HTTPException(
                            status_code=404,
                            detail=f"Recipe {recipe_id} not found",
                        )

                    # 4. Save meal
                    cur.execute("""
                        INSERT INTO weekly_menu_items (
                            weekly_menu_id,
                            day_of_week,
                            meal_type,
                            recipe_id
                        )
                        VALUES (%s, %s, %s, %s);
                    """, (
                        weekly_menu_id,
                        day.day,
                        meal_type,
                        recipe_id,
                    ))

                    day_result[meal_type] = {
                        "recipe_id": recipe[0],
                        "recipe_code": recipe[1],
                        "recipe_name_en": recipe[2],
                        "recipe_name_hy": recipe[3],
                    }

                result.append(day_result)

    # 5. Build shopping list
    shopping_list = build_shopping_list(
        recipe_counts,
        request.servings,
    )

    return {
        "weekly_menu_id": weekly_menu_id,
        "week_start_date": request.week_start_date,
        "servings": request.servings,
        "days": result,
        "shopping_list": shopping_list["items"],
        "total_cost": shopping_list["total_cost"],
    }
@router.get("/{weekly_menu_id}")
def get_weekly_menu(weekly_menu_id: int):
    with get_connection() as conn:
        with conn.cursor() as cur:

            # 1. Get weekly menu
            cur.execute("""
                SELECT
                    weekly_menu_id,
                    week_start_date,
                    servings,
                    created_at
                FROM weekly_menus
                WHERE weekly_menu_id = %s;
            """, (weekly_menu_id,))

            weekly_menu = cur.fetchone()

            if weekly_menu is None:
                raise HTTPException(
                    status_code=404,
                    detail=f"Weekly menu {weekly_menu_id} not found",
                )

            # 2. Get saved meals
            cur.execute("""
                SELECT
                    wmi.day_of_week,
                    wmi.meal_type,
                    r.recipe_id,
                    r.recipe_code,
                    MAX(CASE
                        WHEN rt.language_code = 'en'
                        THEN rt.recipe_name
                    END) AS recipe_name_en,
                    MAX(CASE
                        WHEN rt.language_code = 'hy'
                        THEN rt.recipe_name
                    END) AS recipe_name_hy
                FROM weekly_menu_items AS wmi
                JOIN recipes AS r
                    ON r.recipe_id = wmi.recipe_id
                LEFT JOIN recipe_translations AS rt
                    ON rt.recipe_id = r.recipe_id
                WHERE wmi.weekly_menu_id = %s
                GROUP BY
                    wmi.weekly_menu_item_id,
                    wmi.day_of_week,
                    wmi.meal_type,
                    r.recipe_id,
                    r.recipe_code
                ORDER BY
                    wmi.weekly_menu_item_id;
            """, (weekly_menu_id,))

            meal_rows = cur.fetchall()

    meals = [
        {
            "day": row[0],
            "meal_type": row[1],
            "recipe_id": row[2],
            "recipe_code": row[3],
            "recipe_name_en": row[4],
            "recipe_name_hy": row[5],
        }
        for row in meal_rows
    ]

    return {
        "weekly_menu_id": weekly_menu[0],
        "week_start_date": weekly_menu[1],
        "servings": weekly_menu[2],
        "created_at": weekly_menu[3],
        "meals": meals,
    }
    
@router.get("")
def get_weekly_menus():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    weekly_menu_id,
                    week_start_date,
                    servings,
                    created_at
                FROM weekly_menus
                ORDER BY week_start_date DESC;
            """)

            rows = cur.fetchall()

    return [
        {
            "weekly_menu_id": row[0],
            "week_start_date": row[1],
            "servings": row[2],
            "created_at": row[3],
        }
        for row in rows
    ]
@router.put("/{weekly_menu_id}")
def update_weekly_menu(
    weekly_menu_id: int,
    request: WeeklyMenuUpdateRequest,
):
    recipe_counts = {}

    with get_connection() as conn:
        with conn.cursor() as cur:

            # 1. Check that the weekly menu exists
            cur.execute("""
                SELECT weekly_menu_id
                FROM weekly_menus
                WHERE weekly_menu_id = %s;
            """, (weekly_menu_id,))

            existing_menu = cur.fetchone()

            if existing_menu is None:
                raise HTTPException(
                    status_code=404,
                    detail=f"Weekly menu {weekly_menu_id} not found",
                )

            # 2. Update main weekly menu information
            cur.execute("""
                UPDATE weekly_menus
                SET
                    week_start_date = %s,
                    servings = %s
                WHERE weekly_menu_id = %s;
            """, (
                request.week_start_date,
                request.servings,
                weekly_menu_id,
            ))

            # 3. Remove old meal slots
            cur.execute("""
                DELETE FROM weekly_menu_items
                WHERE weekly_menu_id = %s;
            """, (weekly_menu_id,))

            result = []

            # 4. Insert the new meal plan
            for day in request.days:
                day_result = {
                    "day": day.day,
                    "breakfast": None,
                    "lunch": None,
                    "dinner": None,
                    "snack": None,
                }

                meal_slots = {
                    "breakfast": day.breakfast_recipe_id,
                    "lunch": day.lunch_recipe_id,
                    "dinner": day.dinner_recipe_id,
                    "snack": day.snack_recipe_id,
                }

                for meal_type, recipe_id in meal_slots.items():
                    if recipe_id is None:
                        continue

                    cur.execute("""
                        SELECT
                            r.recipe_id,
                            r.recipe_code,
                            MAX(CASE
                                WHEN rt.language_code = 'en'
                                THEN rt.recipe_name
                            END) AS recipe_name_en,
                            MAX(CASE
                                WHEN rt.language_code = 'hy'
                                THEN rt.recipe_name
                            END) AS recipe_name_hy
                        FROM recipes AS r
                        LEFT JOIN recipe_translations AS rt
                            ON rt.recipe_id = r.recipe_id
                        WHERE r.recipe_id = %s
                        GROUP BY
                            r.recipe_id,
                            r.recipe_code;
                    """, (recipe_id,))

                    recipe = cur.fetchone()

                    if recipe is None:
                        raise HTTPException(
                            status_code=404,
                            detail=f"Recipe {recipe_id} not found",
                        )

                    recipe_counts[recipe_id] = (
                        recipe_counts.get(recipe_id, 0) + 1
                    )

                    cur.execute("""
                        INSERT INTO weekly_menu_items (
                            weekly_menu_id,
                            day_of_week,
                            meal_type,
                            recipe_id
                        )
                        VALUES (%s, %s, %s, %s);
                    """, (
                        weekly_menu_id,
                        day.day,
                        meal_type,
                        recipe_id,
                    ))

                    day_result[meal_type] = {
                        "recipe_id": recipe[0],
                        "recipe_code": recipe[1],
                        "recipe_name_en": recipe[2],
                        "recipe_name_hy": recipe[3],
                    }

                result.append(day_result)

    shopping_list = build_shopping_list(
        recipe_counts,
        request.servings,
    )

    return {
        "weekly_menu_id": weekly_menu_id,
        "week_start_date": request.week_start_date,
        "servings": request.servings,
        "days": result,
        "shopping_list": shopping_list["items"],
        "total_cost": shopping_list["total_cost"],
    }
@router.delete("/{weekly_menu_id}")
def delete_weekly_menu(weekly_menu_id: int):
    with get_connection() as conn:
        with conn.cursor() as cur:

            # Check whether the menu exists
            cur.execute("""
                SELECT weekly_menu_id
                FROM weekly_menus
                WHERE weekly_menu_id = %s;
            """, (weekly_menu_id,))

            weekly_menu = cur.fetchone()

            if weekly_menu is None:
                raise HTTPException(
                    status_code=404,
                    detail=f"Weekly menu {weekly_menu_id} not found",
                )

            # Delete the weekly menu
            cur.execute("""
                DELETE FROM weekly_menus
                WHERE weekly_menu_id = %s;
            """, (weekly_menu_id,))

    return {
        "message": f"Weekly menu {weekly_menu_id} deleted successfully"
    }