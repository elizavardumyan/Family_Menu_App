from pydantic import BaseModel, Field


class RecipeSelection(BaseModel):
    recipe_id: int
    count: int = Field(default=1, ge=1)


class ShoppingListRequest(BaseModel):
    recipes: list[RecipeSelection]


class ShoppingListItem(BaseModel):
    product_code: str
    product_name_en: str | None
    product_name_hy: str | None
    total_quantity: float
    unit_code: str
    total_cost: int


class ShoppingListResponse(BaseModel):
    recipes: list[RecipeSelection]
    items: list[ShoppingListItem]
    total_cost: int