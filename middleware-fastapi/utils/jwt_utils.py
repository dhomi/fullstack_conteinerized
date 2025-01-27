from datetime import datetime, timedelta
from jose import JWTError, jwt
from fastapi import HTTPException
import logging

# Configuration for JWT
SECRET_KEY = "django-insecure-x3my1lu5-hcc@uf8w&9-le8q=v(da!2peq^u3za%i1(szdf%kx"  # Ensure this is securely stored
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Logger setup
logger = logging.getLogger("jwt_utils")
logger.setLevel(logging.INFO)

def create_access_token(data: dict, expires_delta: timedelta = None) -> str:
    """
    Create a JWT token with additional payload fields like user_id and role.
    Args:
        data (dict): Payload data to include in the JWT token.
        expires_delta (timedelta, optional): Custom expiration time. Defaults to ACCESS_TOKEN_EXPIRE_MINUTES.

    Returns:
        str: Encoded JWT token.
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    logger.info(f"Generated JWT token for user: {data.get('sub')}")
    return encoded_jwt

def verify_access_token(token: str) -> dict:
    """
    Verify and decode a JWT token.
    Args:
        token (str): The JWT token to validate.

    Returns:
        dict: Decoded payload if token is valid.

    Raises:
        HTTPException: If the token is invalid or missing required fields.
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        logger.info(f"Decoded token payload: {payload}")
        print(payload)

        user_id: str = payload.get("user_id")
        username: str = payload.get("sub")  # The 'sub' field should represent the subject (e.g., username)
        role: str = payload.get("role")    # The 'role' field represents the user's role

        if not username or not role:
            raise HTTPException(status_code=401, detail="Invalid token: Missing essential fields")

        return {"user_id": user_id, "username": username, "role": role, "exp": payload.get("exp")}
    except JWTError as e:
        logger.error(f"JWT verification failed: {str(e)}")
        raise HTTPException(status_code=401, detail="Invalid token: JWT verification failed") from e
