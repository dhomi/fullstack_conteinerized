from pydantic import BaseModel, EmailStr
from typing import Optional

class RegisterUser(BaseModel):
    username: str
    email: EmailStr
    password: str
    role: Optional[str] = "customer"