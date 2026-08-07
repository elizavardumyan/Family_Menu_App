from fastapi import FastAPI

app = FastAPI(
    title="Family Menu API",
    version="1.0.0"
)

@app.get("/")
def root():
    return {
        "message": "Welcome to Family Menu API!"
    }