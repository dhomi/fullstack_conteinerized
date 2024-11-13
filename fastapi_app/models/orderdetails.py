from pydantic import BaseModel

class BestellingBase(BaseModel):
    bestelnr: int
    levcode: int
    besteldat: str
    leverdat: str
    bedrag: float
    status: str

class BestellingDetail(BestellingBase):
    pass

class BestellingDetailBase(BaseModel):
    bestelnr: int
    artcode: int
    aantal: int

class BestellingDetailCreate(BaseModel):
    levcode: int
    besteldat: str
    leverdat: str
    bedrag: float
    status: str

class BestellingDetailUpdate(BestellingDetailBase):
    pass

class BestellingDetails(BaseModel):
    suppliercode: str
    ordernr: int
    artcode: int
    artikelnaam: str
    orderprice: float
    orderdate: str
    deliverydate: str
    status: str

class BestellingDetailsArt(BaseModel):
    ordernr: int
    artcode: int
    amount: int
    orderprice: float