from pydantic import BaseModel
from typing import Optional

class BestellingBase(BaseModel):
    order_number: int
    supplier_code: int
    order_date: str  # Overweeg datetime.date
    delivery_date: str  # Overweeg datetime.date
    amount: float
    status: str
    status_description: str

class BestellingDetail(BestellingBase):
    pass

class BestellingDetailBase(BaseModel):
    order_number: int
    article_code: int
    quantity: int

class BestellingDetailCreate(BaseModel):
    order_number: int
    supplier_code: int
    order_date: str  # Overweeg datetime.date
    delivery_date: str  # Overweeg datetime.date
    amount: float
    status: str
    status_description: str
    

class BestellingDetailUpdate(BestellingDetailBase):
    pass

class BestellingDetails(BaseModel):
    supplier_code: str
    order_number: int
    article_code: int
    article_name: str
    order_price: float
    order_date: str  # Overweeg datetime.date
    delivery_date: str
    status: str

class BestellingDetailsArt(BaseModel):
    order_number: int
    article_code: int
    quantity: int
    order_price: float