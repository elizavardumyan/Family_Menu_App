from datetime import date

from pydantic import BaseModel


class DayMenu(BaseModel):
    day: str
    breakfast_recipe_id: int | None = None
    lunch_recipe_id: int | None = None
    dinner_recipe_id: int | None = None
    snack_recipe_id: int | None = None


class WeeklyMenuRequest(BaseModel):
    week_start_date: date
    servings: int = 5
    days: list[DayMenu]