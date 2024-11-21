from pydantic import BaseModel, Field
from typing import Optional

class SportsArticle(BaseModel):
    article_code: int 
    article_name: str
    category: str
    size: str 
    color: str
    price: float
    stock_quantity: int
    stock_min: int 
    vat_type: str 

    class Config:
        orm_mode = True
        allow_population_by_field_name = True
