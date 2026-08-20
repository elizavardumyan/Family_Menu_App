from fastapi import APIRouter

from ..schemas.shopping_list import (
    ShoppingListRequest,
    ShoppingListResponse,
)
from ..services.shopping_list import build_shopping_list


router = APIRouter(
    prefix="/shopping-list",
    tags=["shopping-list"],
)


@router.post("", response_model=ShoppingListResponse)
def create_shopping_list(request: ShoppingListRequest):
    recipe_counts = {
        item.recipe_id: item.count
        for item in request.recipes
    }

    shopping_list = build_shopping_list(recipe_counts)

    return {
        "recipes": request.recipes,
        "items": shopping_list["items"],
        "total_cost": shopping_list["total_cost"],
    }