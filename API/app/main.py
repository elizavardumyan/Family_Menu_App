from fastapi import FastAPI

from .routers.recipes import router as recipes_router
from .routers.shopping_list import router as shopping_list_router


app = FastAPI(
    title="Family Menu API",
    version="1.0.0",
)


@app.get("/")
def root():
    return {"message": "Family Menu API is running"}


app.include_router(recipes_router)
app.include_router(shopping_list_router)