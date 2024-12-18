from datetime import datetime, timedelta
from jose import JWTError, jwt
from fastapi import HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer

# Configuration for JWT
SECRET_KEY = "QA-Techlab-1337"  # Change this to a secure, random value
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# OAuth2PasswordBearer is used to extract the token from requests
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="users/login")

# Function to create a JWT token
def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# Function to verify a JWT token
def verify_access_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")  # Het 'sub'-veld bevat vaak de gebruikersnaam
        if username is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        return {"username": username, "exp": payload.get("exp")}  # Je kunt meer velden teruggeven indien nodig
    except JWTError as e:
        raise HTTPException(status_code=401, detail="Invalid token") from e
