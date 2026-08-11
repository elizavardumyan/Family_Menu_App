from fastapi import APIRouter, HTTPException

from ..database import get_connection


router = APIRouter(
    prefix="/recipes",
    tags=["recipes"]
)


@router.get("")
def get_recipes():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    r.recipe_id,
                    r.recipe_code,
                    r.base_servings,
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
                GROUP BY
                    r.recipe_id,
                    r.recipe_code,
                    r.base_servings
                ORDER BY
                    r.recipe_id;
            """)

            rows = cur.fetchall()

    return [
        {
            "recipe_id": row[0],
            "recipe_code": row[1],
            "base_servings": row[2],
            "recipe_name_en": row[3],
            "recipe_name_hy": row[4]
        }
        for row in rows
    ]


@router.get("/{recipe_id}")
def get_recipe(recipe_id: int):
    with get_connection() as conn:
        with conn.cursor() as cur:

            # Get recipe information
            cur.execute("""
                SELECT
                    r.recipe_id,
                    r.recipe_code,
                    r.base_servings,
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
                    r.recipe_code,
                    r.base_servings;
            """, (recipe_id,))

            recipe = cur.fetchone()

            if recipe is None:
                raise HTTPException(
                    status_code=404,
                    detail="Recipe not found"
                )

            # Get recipe ingredients
            cur.execute("""
                SELECT
                    p.product_code,
                    MAX(CASE
                        WHEN pt.language_code = 'en'
                        THEN pt.product_name
                    END) AS ingredient_name_en,
                    MAX(CASE
                        WHEN pt.language_code = 'hy'
                        THEN pt.product_name
                    END) AS ingredient_name_hy,
                    rp.quantity,
                    u.unit_code
                FROM recipe_products AS rp
                JOIN products AS p
                    ON p.product_id = rp.product_id
                LEFT JOIN product_translations AS pt
                    ON pt.product_id = p.product_id
                JOIN units AS u
                    ON u.unit_id = rp.unit_id
                WHERE rp.recipe_id = %s
                GROUP BY
                    p.product_code,
                    rp.quantity,
                    u.unit_code
                ORDER BY
                    p.product_code;
            """, (recipe_id,))

            ingredient_rows = cur.fetchall()

    return {
        "recipe_id": recipe[0],
        "recipe_code": recipe[1],
        "base_servings": recipe[2],
        "recipe_name_en": recipe[3],
        "recipe_name_hy": recipe[4],
        "ingredients": [
            {
                "product_code": row[0],
                "ingredient_name_en": row[1],
                "ingredient_name_hy": row[2],
                "quantity": row[3],
                "unit_code": row[4]
            }
            for row in ingredient_rows
        ]
    }