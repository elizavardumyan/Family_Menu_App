from fastapi import APIRouter, HTTPException

from ..database import get_connection
from ..schemas.recipes import RecipeDetail, RecipeListItem


router = APIRouter(
    prefix="/recipes",
    tags=["recipes"],
)

@router.get("", response_model=list[RecipeListItem])
def get_recipes(
    category: str | None = None,
    search: str | None = None,
    limit: int = 20,
    offset: int = 0,
):
    with get_connection() as conn:
        with conn.cursor() as cur:

            query = """
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
            """

            conditions = []
            params = []

            if category:
                query += """
                    JOIN recipe_category_assignments AS rca
                        ON rca.recipe_id = r.recipe_id
                    JOIN recipe_categories AS rc
                        ON rc.category_id = rca.category_id
                """

                conditions.append("rc.category_code = %s")
                params.append(category)

            if search:
                conditions.append("""
                    (
                        r.recipe_code ILIKE %s
                        OR EXISTS (
                            SELECT 1
                            FROM recipe_translations AS search_rt
                            WHERE search_rt.recipe_id = r.recipe_id
                              AND search_rt.recipe_name ILIKE %s
                        )
                    )
                """)

                search_value = f"%{search}%"
                params.extend([search_value, search_value])

            if conditions:
                query += " WHERE " + " AND ".join(conditions)

            query += """
                GROUP BY
                    r.recipe_id,
                    r.recipe_code,
                    r.base_servings
                ORDER BY
                    r.recipe_id
                LIMIT %s
                OFFSET %s;
            """  
            
            params.extend([limit, offset])
            

            cur.execute(query, params)
            rows = cur.fetchall()

    return [
        {
            "recipe_id": row[0],
            "recipe_code": row[1],
            "base_servings": row[2],
            "recipe_name_en": row[3],
            "recipe_name_hy": row[4],
        }
        for row in rows
    ]


@router.get("/{recipe_id}", response_model=RecipeDetail)
def get_recipe(recipe_id: int):
    with get_connection() as conn:
        with conn.cursor() as cur:

            # 1. Get recipe information
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
                    detail="Recipe not found",
                )

            # 2. Get recipe categories
            cur.execute("""
                SELECT
                    rc.category_code,
                    MAX(CASE
                        WHEN rct.language_code = 'en'
                        THEN rct.category_name
                    END) AS category_name_en,
                    MAX(CASE
                        WHEN rct.language_code = 'hy'
                        THEN rct.category_name
                    END) AS category_name_hy
                FROM recipe_category_assignments AS rca
                JOIN recipe_categories AS rc
                    ON rc.category_id = rca.category_id
                LEFT JOIN recipe_category_translations AS rct
                    ON rct.category_id = rc.category_id
                WHERE rca.recipe_id = %s
                GROUP BY
                    rc.category_id,
                    rc.category_code
                ORDER BY
                    rc.category_code;
            """, (recipe_id,))

            category_rows = cur.fetchall()

            # 3. Calculate recipe cost
            cur.execute("""
                SELECT
                    COALESCE(
                        ROUND(SUM(rp.quantity * p.unit_price)),
                        0
                    )::int
                FROM recipe_products AS rp
                JOIN products AS p
                    ON p.product_id = rp.product_id
                WHERE rp.recipe_id = %s;
            """, (recipe_id,))

            recipe_cost = cur.fetchone()[0]

            # 4. Get recipe ingredients
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
        "recipe_cost": recipe_cost,
        "categories": [
            {
                "category_code": row[0],
                "category_name_en": row[1],
                "category_name_hy": row[2],
            }
            for row in category_rows
        ],
        "ingredients": [
            {
                "product_code": row[0],
                "ingredient_name_en": row[1],
                "ingredient_name_hy": row[2],
                "quantity": row[3],
                "unit_code": row[4],
            }
            for row in ingredient_rows
        ],
    }