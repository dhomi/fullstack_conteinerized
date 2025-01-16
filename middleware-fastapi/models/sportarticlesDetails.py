from pydantic import BaseModel, Field, validator
from typing import Optional

class SportsArticle(BaseModel):
    article_name: str
    category: str
    size: str
    color: str
    price: float
    stock_quantity: int
    stock_min: int
    vat_type: str = Field(..., max_length=1)

    @validator("vat_type")
    def validate_vat_type(cls, value):
        allowed_values = {"H", "L"}
        if value not in allowed_values:
            raise ValueError("VAT type must be 'H' or 'L'")
        return value

    class Config:
        orm_mode = True
        allow_population_by_field_name = True
