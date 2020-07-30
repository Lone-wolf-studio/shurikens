import uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get("/your-url/")
async def change_this():
    return {"message": "get call"}

@app.post("/your-url/")
async def change_this_too():
    return {"message": "post call"}

@app.put("/your-url/")
async def change_this_one_too():
    return {"message": "put call"}

@app.delete("/your-url/")
async def change_this_as_well():
    return {"message": "delete call"}






if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

