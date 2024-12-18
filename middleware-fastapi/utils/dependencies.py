from fastapi import Depends, HTTPException, status
from utils.jwt_utils import verify_access_token  # Je bestaande functie voor tokenvalidatie
from fastapi.security import OAuth2PasswordBearer

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="users/login")

async def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        username = verify_access_token(token)  # Ensure the token is valid
        return {"username": username}
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

