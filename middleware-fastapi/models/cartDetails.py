from pydantic import BaseModel
from typing import Optional, List

class CartItem(BaseModel):
    # article_code: int
    # article_name: Optional[str] = None
    # price: Optional[float] = None
    # quantity: int
    # total_price: Optional[float] = None
    article_code: int
    quantity: int

    class Config:
        orm_mode = True

class CartRequest(BaseModel):
    article_code: int
    quantity: Optional[int] = 1  # Default quantity is 1

class CartResponse(BaseModel):
    message: str
    items: List[CartItem]
    total_price: Optional[float]

class CartCountResponse(BaseModel):
    cart_count: int
