from pydantic import BaseModel

class SportartikelDetails(BaseModel):
    artcode: int
    artikelnaam: str
    categorie: int
    maat: int
    kleur: str
    prijs: str
    vrr_aantal: float
    vrr_min: float
    BTWtype: str

    # `artcode`, `artikelnaam`, `categorie`, `maat`, `kleur`, `prijs`, `vrr_aantal`, `vrr_min`, `BTWtype`