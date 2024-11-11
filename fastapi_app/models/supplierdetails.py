from pydantic import BaseModel

class LeverancierBase(BaseModel):
    levcode: int
    levnaam: str
    adres: str
    woonplaats: str

class LeverancierDetail(LeverancierBase):
    pass 

class LeverancierCreate(BaseModel):
    levnaam: str
    adres: str
    woonplaats: str