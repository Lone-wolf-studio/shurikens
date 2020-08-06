from fastapi import APIRouter, HTTPException

router = APIRouter()

@router.get("/")
async def get_call():
    return {"message": "get call"}

@router.post("/")
async def post_call():
    return {"message": "post call"}

@router.put("/")
async def put_call():
    return {"message": "put call"}

@router.delete("/")
async def delete_call():
    return {"message": "delete call"}

