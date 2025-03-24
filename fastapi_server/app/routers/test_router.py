from fastapi import APIRouter
from services.test_service import test_service
from models.test_model import TestModel

router = APIRouter()

@router.get("/test", response_model=TestModel)
def test_route():
    result = test_service()
    return {"result": result}
