from pydantic import BaseModel

class LeverancierBase(BaseModel):
    supplier_code: int
    supplier_name: str
    address: str
    city: str

class LeverancierDetail(LeverancierBase):
    pass 

class LeverancierCreate(BaseModel):
    supplier_code: int
    supplier_name: str
    address: str
    city: str