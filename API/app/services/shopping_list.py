from ..database import get_connection


def build_shopping_list(recipe_counts: dict[int, int]):
    recipe_ids = list(recipe_counts.keys())

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    rp.recipe_id,
                    rp.product_id,
                    rp.unit_id,
                    rp.quantity
                FROM recipe_products AS rp
                WHERE rp.recipe_id = ANY(%s);
            """, (recipe_ids,))

            ingredient_rows = cur.fetchall()

            totals = {}

            for recipe_id, product_id, unit_id, quantity in ingredient_rows:
                count = recipe_counts[recipe_id]

                key = (product_id, unit_id)

                if key not in totals:
                    totals[key] = 0

                totals[key] += quantity * count

            items = []

            for (product_id, unit_id), total_quantity in totals.items():
                cur.execute("""
                    SELECT
                        p.product_code,
                        MAX(CASE
                            WHEN pt.language_code = 'en'
                            THEN pt.product_name
                        END) AS product_name_en,
                        MAX(CASE
                            WHEN pt.language_code = 'hy'
                            THEN pt.product_name
                        END) AS product_name_hy,
                        u.unit_code,
                        p.unit_price
                    FROM products AS p
                    LEFT JOIN product_translations AS pt
                        ON pt.product_id = p.product_id
                    JOIN units AS u
                        ON u.unit_id = %s
                    WHERE p.product_id = %s
                    GROUP BY
                        p.product_id,
                        p.product_code,
                        p.unit_price,
                        u.unit_code;
                """, (unit_id, product_id))

                row = cur.fetchone()

                total_cost = round(
                    total_quantity * row[4]
                )

                items.append(
                    {
                        "product_code": row[0],
                        "product_name_en": row[1],
                        "product_name_hy": row[2],
                        "total_quantity": total_quantity,
                        "unit_code": row[3],
                        "total_cost": total_cost,
                    }
                )

    items.sort(
        key=lambda item: item["product_code"]
    )

    total_cost = sum(
        item["total_cost"]
        for item in items
    )

    return {
        "items": items,
        "total_cost": total_cost,
    }