from datetime import date
from pydantic import BaseModel

class GoodsReceiptBase(BaseModel):
    receipt_id = int
    order_number = int
    article_code = int
    receipt_date = str 
    receipt_quantity = int
    status = str 
    booking_number = int 
    sequence_number = int