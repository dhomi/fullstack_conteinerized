from starlette.middleware.base import BaseHTTPMiddleware
from fastapi.responses import JSONResponse
from fastapi import HTTPException
from utils.jwt_utils import verify_access_token
import logging

logger = logging.getLogger(__name__)

class AuthenticationMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        # Allow unauthenticated OPTIONS requests
        if request.method == "OPTIONS":
            return await call_next(request)

        # Allow specific paths without authentication
        if request.url.path in ["/users/login", "/users/register", "/docs", "/redoc", "/openapi.json"]:
            return await call_next(request)

        token = request.headers.get("Authorization")
        if token and token.startswith("Bearer "):
            token = token.split(" ")[1]
            try:
                verify_access_token(token)
            except HTTPException as e:
                return JSONResponse(status_code=e.status_code, content={"detail": e.detail})
        else:
            return JSONResponse(status_code=401, content={"detail": "Unauthorized: Missing token"})

        return await call_next(request)


