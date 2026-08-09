from fastapi import FastAPI

from .routers.recipes import router as recipes_router


app = FastAPI(
    title="Family Menu API",
    version="1.0.0"
)


@app.get("/")
def root():
    return {
        "message": "Welcome to Family Menu API!"
    }


app.include_router(recipes_router)