from fastapi import APIRouter, HTTPException

from ..database import get_connection
from ..schemas.menu import WeeklyMenuRequest
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
                    
                    recipe_counts[recipe_id] = recipe_counts.get(recipe_id, 0) + 1
                    

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

                    day_result[meal_type] = {
                        "recipe_id": recipe[0],
                        "recipe_code": recipe[1],
                        "recipe_name_en": recipe[2],
                        "recipe_name_hy": recipe[3],
                    }

                result.append(day_result)

    
    shopping_list = build_shopping_list(recipe_counts)

    return { 
        "days": result,
        "shopping_list": shopping_list["items"],
        "total_cost": shopping_list["total_cost"],
    }