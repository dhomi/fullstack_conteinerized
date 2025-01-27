from fastapi import Depends, HTTPException, status
from utils.jwt_utils import verify_access_token  # Your updated function for token validation
from fastapi.security import OAuth2PasswordBearer

# oauth2_scheme = OAuth2PasswordBearerWithCookie(tokenUrl="users/login")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="users/login")

async def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    Validate the token and extract user details including user_id, username, and role.
    """
    try:
        # Verify the token and get user details
        token_data = verify_access_token(token)
        return {
            "user_id": token_data.get("user_id"),
            "username": token_data.get("username"),
            "role": token_data.get("role")
        }
    except HTTPException as e:
        # Re-raise HTTP exceptions (e.g., Invalid token)
        raise e
    except Exception:
        # Handle unexpected exceptions
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )