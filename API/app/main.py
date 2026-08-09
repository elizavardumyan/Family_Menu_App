from fastapi import FastAPI
from .database import get_connection

app = FastAPI(
    title="Family Menu API",
    version="1.0.0"
)

@app.get("/")
def root():
    return {
        "message": "Welcome to Family Menu API!"
    }
    from .database import get_connection


@app.get("/recipes")
def get_recipes():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT recipe_id, recipe_code, base_servings
                FROM recipes
                ORDER BY recipe_id;
            """)

            rows = cur.fetchall()

    return [
        {
            "recipe_id": row[0],
            "recipe_code": row[1],
            "base_servings": row[2]
        }
        for row in rows
    ]