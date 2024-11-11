from datetime import date
from pydantic import BaseModel

class SuccessfulDeliveryBase(BaseModel):
    ordernr: int
    artcode: int
    delivery_date: date
    amount_received: int
    status: str
    external_invoice_nr: int
    serial_number: int

class SuccessfulDelivery(SuccessfulDeliveryBase):
    class Config:
        orm_mode = True
