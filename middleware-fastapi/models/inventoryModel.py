from datetime import date
from pydantic import BaseModel
from typing import Optional


class InventoryOverview(BaseModel):
    article_code: int
    article_name: str
    category: Optional[str] = None
    size: Optional[str] = None
    color: Optional[str] = None
    price: float
    stock_quantity: int
    stock_min: int
    incoming_stock: int
    reserved_stock: int
    status: str

    class Config:
        orm_mode = True
