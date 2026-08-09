from fastapi import APIRouter

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