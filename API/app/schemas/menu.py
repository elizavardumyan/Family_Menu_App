from pydantic import BaseModel


class DayMenu(BaseModel):
    day: str
    breakfast_recipe_id: int | None = None
    lunch_recipe_id: int | None = None
    dinner_recipe_id: int | None = None
    snack_recipe_id: int | None = None


class WeeklyMenuRequest(BaseModel):
    days: list[DayMenu]