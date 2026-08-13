from pydantic import BaseModel


class IngredientResponse(BaseModel):
    product_code: str
    ingredient_name_en: str | None
    ingredient_name_hy: str | None
    quantity: float
    unit_code: str


class CategoryResponse(BaseModel):
    category_code: str
    category_name_en: str | None
    category_name_hy: str | None


class RecipeListItem(BaseModel):
    recipe_id: int
    recipe_code: str
    base_servings: int
    recipe_name_en: str | None
    recipe_name_hy: str | None


class RecipeDetail(RecipeListItem):
    categories: list[CategoryResponse]
    ingredients: list[IngredientResponse]