from datetime import datetime
from fastapi import FastAPI, HTTPException, Request, Depends, status, APIRouter
from fastapi.openapi.models import OAuthFlows as OAuthFlowsModel, OAuthFlowPassword
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm, OAuth2
from fastapi.responses import HTMLResponse
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
from models.supplierdetails import LeverancierBase, LeverancierDetail, LeverancierCreate
from models.orderdetails import BestellingBase, BestellingDetail, BestellingDetailBase, BestellingDetailCreate, BestellingDetailUpdate, BestellingDetails, BestellingDetailsArt
from models.deliverydetails import SuccessfulDelivery, SuccessfulDeliveryBase
from models.sportarticlesDetails import SportsArticle
from models.goodsReceiptModel import GoodsReceiptBase
from models.inventoryModel import InventoryOverview
from models.cartDetails import CartItem, CartRequest, CartResponse, CartCountResponse
from models.User import RegisterUser
from utils.db import DatabaseConnection
from utils.dependencies import get_current_user
from middleware.authentication_middleware import AuthenticationMiddleware
from services.cart import Cart
from services.leveranciers import Leveranciers
from services.bestellingen import Bestellingen
from services.sportArtikelen import SportsArticlesService
from services.delivery import Delivery
from services.goodsReceipts import GoodsReceipts
from services.inventory import Inventory
from typing import Dict
from utils.OAuthToPassword import OAuth2PasswordBearerWithCookie
from utils.jwt_utils import create_access_token, verify_access_token
from pydantic import BaseModel
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from loguru import logger
from typing import Optional
import uvicorn

# Error Response Model
class ErrorResponse(BaseModel):
    detail: str

oauth2_scheme = OAuth2PasswordBearerWithCookie(tokenUrl="users/login")

# FastAPI App Initialization
app = FastAPI(
    title="Welcome to the Quality Accelerators API playground",
    responses={
        400: {"model": ErrorResponse, "description": "Bad Request"},
        401: {"model": ErrorResponse, "description": "Unauthorized"},
        403: {"model": ErrorResponse, "description": "Forbidden"},
        404: {"model": ErrorResponse, "description": "Not Found"},
        409: {"model": ErrorResponse, "description": "Conflict"},
        500: {"model": ErrorResponse, "description": "Internal Server Error"}
    }
)

router = APIRouter()
# Password Hashing Context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
hashed = pwd_context.hash("password")
print(pwd_context.verify("password", hashed))

# Middleware Configuration
app.add_middleware(CORSMiddleware, allow_origins=["http://localhost:8001"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])
app.add_middleware(AuthenticationMiddleware)

# Include routers
app.include_router(router)

# Dependency: Database Session
async def get_db():
    db = DatabaseConnection()
    try:
        yield db
    finally:
        db.close()

# Custom Error Handling
@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    logger.exception("Unexpected error occurred")
    return JSONResponse(
        status_code=500,
        content={"detail": "An unexpected error occurred. Please try again later."},
    )

# Helper Function: Raise HTTP Exception
def raise_http_exception(status_code: int, detail: str):
    logger.error(f"Error {status_code}: {detail}")
    raise HTTPException(status_code=status_code, detail=detail)

class routes:
    # Supplier Endpoints
    @app.get("/suppliers/", tags=["suppliers"])
    async def get_suppliers(db: DatabaseConnection = Depends(get_db), current_user: dict = Depends(get_current_user)):
        try:
            leveranciers = Leveranciers(db)
            result = leveranciers.get_levs()
            if not result:
                raise_http_exception(404, "Suppliers not found")
            return [{"suppliercode": r[0], "suppliername": r[1], "address": r[2], "residence": r[3]} for r in result]
        except Exception as e:
            logger.exception("Failed to retrieve suppliers")
            raise_http_exception(500, "Failed to retrieve suppliers")

    @app.get("/suppliers/{suppliercode}", tags=["suppliers"])
    async def get_leverancier(suppliercode: int, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            leveranciers = Leveranciers(db)
            result = leveranciers.get_lev(suppliercode)
            if not result:
                raise_http_exception(404, "Supplier not found")
            return {
                "supplier_code": result[0][0],
                "supplier_name": result[0][1],
                "address": result[0][2],
                "city": result[0][3]
            }
        except Exception as e:
            logger.exception("Failed to retrieve supplier")
            raise_http_exception(500, "Failed to retrieve supplier")

    @app.post("/suppliers/", tags=["suppliers"])
    async def create_supplier(
        leverancier: LeverancierCreate,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        if current_user["role"] != "admin":
            raise HTTPException(status_code=403, detail="Access forbidden")
        try:
            lev = Leveranciers(db)
            result = lev.add_lev(leverancier.supplier_code, leverancier.supplier_name, leverancier.address, leverancier.city)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return result
        except Exception as e:
            logger.exception("Failed to create supplier")
            raise_http_exception(500, "Failed to create supplier")

    @app.delete("/suppliers/{suppliercode}", tags=["suppliers"])
    async def delete_supplier(
        suppliercode: str,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        if current_user["role"] != "admin":
            raise HTTPException(status_code=403, detail="Access forbidden")
        try:
            lev = Leveranciers(db)
            result = lev.delete_lev(suppliercode)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Supplier deleted"}
        except Exception as e:
            logger.exception("Failed to delete supplier")
            raise_http_exception(500, "Failed to delete supplier")

    @app.get("/orders/", tags=["orders"])
    async def get_bestellingen(db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            bestellingen = Bestellingen(db)
            result = bestellingen.get_all_orders()
            if not result:
                raise_http_exception(404, "Orders not found")
            return [
                {"ordernr": r[0], "suppliercode": r[1], "orderdate": r[2], "deliverydate": r[3], "price": r[4], "status": r[6]}
                for r in result
            ]
        except Exception as e:
            logger.exception("Failed to retrieve orders")
            raise_http_exception(500, "Failed to retrieve orders")

    @app.get("/orders/{suppliercode}", tags=["orders"])
    async def get_bestelling(suppliercode: int, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            bestellingen = Bestellingen(db)
            results = bestellingen.get_order(suppliercode)  # Assuming this returns a list of orders
    
            if not results:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Orders not found")
    
            orders = [
                {
                    "order_number": row[0],
                    "supplier_code": row[1],
                    "order_date": row[2],
                    "delivery_date": row[3],
                    "amount": row[4],
                    "status": row[6]
                }
                for row in results
            ]
    
            return orders
    
        except Exception as e:
            logger.exception("Failed to retrieve orders")
            raise HTTPException(status_code=500, detail="Failed to retrieve orders")

    
    @app.get("/trackorder/{order_number}", tags=["trackorder"])
    async def track_orders(order_number: int, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            bestellingen = Bestellingen(db)
            result = bestellingen.track_order(order_number)
            if not result:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Order not found")
            return {
                "order_number": result[0][0],
                "supplier_code": result[0][1],
                "order_date": result[0][2],
                "delivery_date": result[0][3],
                "amount": result[0][4],
                "status": result[0][6]
            }
        except Exception as e:
            logger.exception("Failed to retrieve order")
            raise_http_exception(500, "Failed to retrieve order")

    @app.post("/orders/", tags=["orders"])
    async def create_bestelling(bestelling: BestellingDetailCreate, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
        # Convert the dates to correct format if they aren't
            try:
                order_date = datetime.strptime(bestelling.order_date, '%Y-%m-%d').strftime('%Y-%m-%d')
                delivery_date = datetime.strptime(bestelling.delivery_date, '%Y-%m-%d').strftime('%Y-%m-%d')
            except ValueError as ve:
                raise HTTPException(status_code=400, detail="Incorrect date format. Use 'YYYY-MM-DD'.")

            best = Bestellingen(db)
            
            # Preparing the data with new attributes
            bestelling_data = {
                "order_number": bestelling.order_number,
                "supplier_code": bestelling.supplier_code,
                "amount": bestelling.amount,
                "order_date": order_date,
                "delivery_date": delivery_date,
                "status": bestelling.status
            }

            # Adding the new order to the database
            result = best.add_neworders(**bestelling_data)

            if "error" in result:
                raise HTTPException(status_code=400, detail=result["error"])
            return {"message": "Order created successfully"}

        except Exception as e:
            logger.exception("Failed to create bestelling")
            raise HTTPException(status_code=500, detail="Failed to create bestelling")

    @app.put("/orders/{ordernr}", tags=["orders"])
    async def update_bestelling(ordernr: str, bestelling: BestellingBase, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            best = Bestellingen(db)
            result = best.update_orders(
                ordernr,
                bestelling.supplier_code,
                bestelling.order_date,
                bestelling.delivery_date,
                bestelling.amount,
                bestelling.status
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return result
        except Exception as e:
            logger.exception("Failed to update bestelling")
            raise_http_exception(500, "Failed to update bestelling")

    @app.delete("/orders/{ordernr}", tags=["orders"])
    async def delete_bestelling(ordernr: str, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            best = Bestellingen(db)
            result = best.delete_orders(ordernr)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Bestelling deleted"}
        except Exception as e:
            logger.exception("Failed to delete bestelling")
            raise_http_exception(500, "Failed to delete bestelling")

    @app.get("/orderdetails/{ordernr}", tags=["order details"])
    async def get_bestellingdetails(ordernr: int, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user), skip: int = 0, limit: int = 100):
        try:
            bestDetails = Bestellingen(db)
            results = bestDetails.get_orderlines(ordernr)
            bestellingdetails = [
                BestellingDetails(
                    supplier_code=result[0],
                    order_number=result[1],
                    article_code=result[2],
                    article_name=result[3],
                    order_price=result[4],
                    order_date=str(result[5]),
                    delivery_date=str(result[6]),
                    status=result[7]
                )
                for result in results
            ]
            if "error" in results:
                raise_http_exception(400, results["error"])
            return bestellingdetails
        except Exception as e:
            logger.exception("Failed to retrieve bestelling details")
            raise_http_exception(500, "Failed to retrieve bestelling details")

    @app.get("/orderdetailsArt/{artcode}", tags=["orderdetails with artcode"])
    async def get_orderdetails_artcode(artcode: int, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            bestDetails = Bestellingen(db)
            results = bestDetails.get_orderlinewithArtcode(artcode)
            bestellingdetails = [
                BestellingDetailsArt(
                    order_number=result[0],
                    article_code=result[1],
                    quantity=result[2],
                    order_price=result[3]
                )
                for result in results
            ]
            if "error" in results:
                raise_http_exception(400, results["error"])
            return bestellingdetails
        except Exception as e:
            logger.exception("Failed to retrieve bestelling details by artcode")
            raise_http_exception(500, "Failed to retrieve bestelling details by artcode")

    @app.post("/orderdetails/", tags=["order details"])
    async def create_bestellingdetails(bestellingdetails: BestellingDetails, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            bestDetails = Bestellingen(db)
            result = bestDetails.add_neworders(
                bestellingdetails.supplier_code,
                bestellingdetails.article_code,
                bestellingdetails.order_number,
                bestellingdetails.order_price,
                bestellingdetails.order_date,
                bestellingdetails.delivery_date,
                bestellingdetails.article_name,
                bestellingdetails.status
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return bestellingdetails
        except Exception as e:
            logger.exception("Failed to create bestelling details")
            raise_http_exception(500, "Failed to create bestelling details")

    @app.put("/orderdetails/{ordernr}", tags=["order details"])
    async def update_bestellingdetails(
        ordernr: int,
        bestellingdetails: BestellingDetails,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        try:
            bestDetails = Bestellingen(db)
            result = bestDetails.update_order_details(
                ordernr,
                bestellingdetails.supplier_code,
                bestellingdetails.order_number,
                bestellingdetails.article_code,
                bestellingdetails.article_name,
                bestellingdetails.order_price,
                bestellingdetails.order_date,
                bestellingdetails.delivery_date,
                bestellingdetails.status
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Order details updated successfully"}
        except Exception as e:
            logger.exception("Failed to update bestelling details")
            raise_http_exception(500, "Failed to update bestelling details")

    @app.delete("/orderdetails/{ordernr}", tags=["order details"])
    async def delete_bestellingdetails(ordernr: int, db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            bestDetails = Bestellingen(db)
            result = bestDetails.delete_orders(ordernr)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Bestelling details deleted"}
        except Exception as e:
            logger.exception("Failed to delete bestelling details")
            raise_http_exception(500, "Failed to delete bestelling details")
    
    # Sports Articles Endpoints
    @app.get("/sports_articles/", tags=["sportarticles"])
    async def get_sports_articles(db: DatabaseConnection = Depends(get_db), current_user: dict = Depends(get_current_user)):
        try:
            sArticles = SportsArticlesService(db)
            result = sArticles.get_all_articles()
            return [
                {
                    "article_code": r[0], "article_name": r[1], "category": r[2], "size": r[3],
                    "color": r[4], "price": r[5], "stock_quantity": r[6], "stock_min": r[7], "vat_type": r[8]
                } for r in result
            ]
        except Exception as e:
            logger.exception("Failed to retrieve sports articles")
            raise HTTPException(status_code=500, detail="Failed to retrieve sports articles")

    @app.get("/sports_articles/{article_code}", tags=["sportarticles"])
    async def get_plant(article_code: int):
        db = DatabaseConnection()
        sArticles = SportsArticlesService(db)
        result = sArticles.get_article(article_code)
        return [{"article_code": r[0], "article_name": r[1], "category": r[2], "size": r[3], "color": r[4], "price": r[5], "stock_quantity": r[6], "stock_min": r[7], "vat_type": r[8]} for r in result]

    @app.post("/sports_articles/", tags=["sportarticles"])
    async def add_sports_article(
        article: SportsArticle,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        if current_user["role"] != "admin":
            raise HTTPException(status_code=403, detail="Access forbidden")
        try:
            add_article_service = SportsArticlesService(db)
            result = add_article_service.add_new_article(
                article_name=article.article_name, category=article.category, size=article.size,
                color=article.color, price=article.price, stock_quantity=article.stock_quantity,
                stock_min=article.stock_min, vat_type=article.vat_type
            )
            if "error" in result:
                raise HTTPException(status_code=400, detail=result["error"])
            return {"message": "Article added successfully", "article": result}
        except Exception as e:
            logger.exception("Failed to create sport article")
            raise HTTPException(status_code=500, detail="Failed to create sport article")

    @app.put("/sports_articles/{article_code}", tags=["sportarticles"])
    async def update_sports_article(
        article_code: int,
        article: SportsArticle,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        if current_user["role"] != "admin":
            raise HTTPException(status_code=403, detail="Access forbidden")
        try:
            sports_article_service = SportsArticlesService(db)
            result = sports_article_service.update_article(
                article_code, article.article_name, article.category, article.size,
                article.color, article.price, article.stock_quantity, article.stock_min, article.vat_type
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Sports article updated successfully"}
        except Exception as e:
            logger.exception("Failed to update sports article")
            raise_http_exception(500, "Failed to update sports article")

    @app.delete("/sports_articles/{article_code}", tags=["sportarticles"])
    async def delete_sports_article(
        article_code: int,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        if current_user["role"] != "admin":
            raise HTTPException(status_code=403, detail="Access forbidden")
        try:
            sports_article_service = SportsArticlesService(db)
            result = sports_article_service.delete_article(article_code)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Sports article deleted successfully"}
        except Exception as e:
            logger.exception("Failed to delete sports article")
            raise_http_exception(500, "Failed to delete sports article")

    @app.get("/goodsReceipts/", tags=["goodreceipts"])
    async def get_goodsReceipts(db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            goodsReceipts = GoodsReceipts(db)
            results = goodsReceipts.get_goodsReceipts()
            if "error" in results:
                raise_http_exception(400, results["error"])
            return [{"receipt_id": r[0], "order_number": r[1], "article_code": r[2], "receipt_date": r[3], "receipt_quantity": r[4], "status": r[5], "booking_number": r[6], "sequence_number": r[7]} for r in results]
        except Exception as e:
            logger.exception("Failed to retrieve good receipts")
            raise_http_exception(500, "Failed to retrieve good receipts")

    @app.get("/inventory/", tags=["inventory"])
    async def get_inventory(db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)):
        try:
            invent = Inventory(db)
            results = invent.get_inventory_from_db()
            if "error" in results:
                raise_http_exception(400, results["error"])
            return [{"article_code": r[0], "article_name":r[1],"category":r[2],"size":r[3],"color":r[4],"price":r[5],"stock_quantity":r[6],"stock_min":r[7],"incoming_stock":r[8],"reserved_stock":r[9],"status":r[10]} for r in results]
        except Exception as e:
            logger.exception("Failed to retrieve inventory")
            raise_http_exception(500, "Failed to retrieve inventory")
    
        # Dependency: Verify Token
    async def verify_token(token: str = Depends(oauth2_scheme)):
        try:
            username = verify_access_token(token)
            return username
        except HTTPException as e:
            logger.warning(f"Unauthorized access attempt: {e.detail}")
            raise

    @app.post("/users/register", tags=["users"])
    def register_user(user: RegisterUser, db: DatabaseConnection = Depends(get_db)):
        cursor = None  # Initialize cursor to avoid UnboundLocalError
        try:
            cursor = db.get_cursor()
            if cursor is None:
                logger.error("Database connection error: cursor is None")
                raise HTTPException(status_code=500, detail="Database connection error")
            
            # Check if username or email already exists
            cursor.execute("SELECT COUNT(*) FROM users WHERE username = %s", (user.username,))
            if cursor.fetchone()[0] > 0:
                logger.warning(f"Registration failed: Username '{user.username}' already exists")
                raise HTTPException(status_code=400, detail="Username already exists")
            
            cursor.execute("SELECT COUNT(*) FROM users WHERE email = %s", (user.email,))
            if cursor.fetchone()[0] > 0:
                logger.warning(f"Registration failed: Email '{user.email}' already exists")
                raise HTTPException(status_code=400, detail="Email already exists")

            # Insert the new user
            hashed_password = pwd_context.hash(user.password)
            
            # **Potential Issue:** If the 'users' table has a 'role' column that is NOT NULL, you need to include it in the INSERT statement.
            cursor.execute(
                "INSERT INTO users (username, email, password_hash, role) VALUES (%s, %s, %s, %s)",
                (user.username, user.email, hashed_password, user.role)
            )
            db.connection.commit()
            logger.info(f"User '{user.username}' registered successfully")
            return {"message": "User registered successfully"}
        except HTTPException as he:
            # Re-raise HTTPExceptions to let FastAPI handle them
            raise he
        except Exception as e:
            logger.exception(f"Failed to register user '{user.username}': {e}")
            raise HTTPException(status_code=500, detail=f"Failed to register user: {e}")
        finally:
            if cursor:
                cursor.close()

    @app.post("/users/login", tags=["users"])
    def login_user(form_data: OAuth2PasswordRequestForm = Depends(), db: DatabaseConnection = Depends(get_db)):
        """
        User login endpoint. Validates user credentials and returns a JWT token.

        Args:
            form_data (OAuth2PasswordRequestForm): The username and password form.
            db (DatabaseConnection): Database connection dependency.

        Returns:
            dict: Access token, token type, and user information.
        """
        cursor = db.get_cursor()
        if cursor is None:
            logger.error("Database connection error")
            raise HTTPException(status_code=500, detail="Database connection error")

        try:
            # Fetch user by username
            logger.debug(f"Fetching user with username: {form_data.username}")
            cursor.execute("SELECT user_id, username, password_hash, role FROM users WHERE username = %s", (form_data.username,))
            user = cursor.fetchone()

            if not user:
                logger.warning(f"Login failed: User '{form_data.username}' not found")
                raise HTTPException(status_code=401, detail="Invalid username or password")

            # Verify password
            try:
                if not pwd_context.verify(form_data.password, user[2]):
                    logger.warning(f"Login failed: Incorrect password for user '{form_data.username}'")
                    raise HTTPException(status_code=401, detail="Invalid username or password")
            except AttributeError as e:
                logger.error(f"Password verification failed due to bcrypt error: {str(e)}")
                raise HTTPException(status_code=500, detail="Password verification error. Please contact support.")

            # Validate role
            valid_roles = {"admin", "customer"}
            if user[3] not in valid_roles:
                logger.warning(f"Invalid role '{user[3]}' for user '{form_data.username}'")
                raise HTTPException(status_code=403, detail="User role is invalid")

            # Generate a JWT token
            logger.debug(f"Generating JWT token for user: {form_data.username}")
            token_data = {"user_id": user[0], "sub": user[1], "role": user[3]}
            token = create_access_token(data=token_data)

            # Successful login log
            logger.info(f"User '{form_data.username}' logged in successfully")

            # Return access token and user information
            return {
                "access_token": token,
                "token_type": "bearer",
                "user": {
                    "user_id": user[0],
                    "username": user[1],
                    "role": user[3]
                }
            }

        except HTTPException as http_exc:
            # Handle HTTP exceptions specifically
            logger.error(f"HTTP exception occurred: {http_exc.detail}")
            raise http_exc

        except Exception as e:
            # Log unexpected errors and raise generic HTTPException
            logger.exception(f"Unexpected error during login: {str(e)}")
            raise HTTPException(status_code=500, detail="Failed to login. Please try again later.")
        
        finally:
            cursor.close()


    @app.get("/users/me", tags=["users"])
    async def read_users_me(current_user: dict = Depends(get_current_user)):
        """
        Fetch the currently authenticated user's details.
        """
        return {
            "user_id": current_user["user_id"],
            "username": current_user["username"],
            "role": current_user["role"],
        }
    
    @router.get("/profile/", tags=["users"])
    async def get_user_profile(current_user: dict = Depends(get_current_user)):
        """
        Example endpoint to demonstrate usage of get_current_user.
        """
        return {
            "message": "User profile fetched successfully",
            "user": current_user
        }

    # async def get_current_user(token: str = Depends(oauth2_scheme)):
    #     username = verify_access_token(token)  # Your token validation logic
    #     return {"username": username}
    
    @app.get("/secure-data/", dependencies=[Depends(get_current_user)], tags=["secure"])
    async def secure_data(current_user: dict = Depends(get_current_user)):
        return {"message": "This is secure data", "username": current_user["username"]}

    @app.get("/docs/", tags=["docs"])
    async def open_docs():
        return {"message": "This endpoint does not require authentication"}
    
    @app.post("/cart/add/", tags=["cart"])
    async def add_to_cart(
        cart_item: CartRequest,  # This is a Pydantic model with article_code, quantity (optional).
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        """
        Adds (or increments) an item in the user's cart table.
        If the item already exists, increment quantity by 1 (or cart_item.quantity if provided).
        """
        try:
            user_id = current_user["user_id"]
            cart_service = Cart(db)
            quantity_to_add = cart_item.quantity if cart_item.quantity else 1
            cart_service.add_to_cart(user_id, cart_item.article_code, quantity_to_add)
            return {"message": "Item added to cart successfully"}
        except Exception as e:
            logger.exception("Failed to add item to cart")
            raise_http_exception(500, f"Failed to add item to cart: {str(e)}")


    @app.get("/cart/", response_model=CartResponse, tags=["cart"])
    async def get_cart_items(
        db: DatabaseConnection = Depends(get_db), 
        current_user: dict = Depends(get_current_user)
    ):
        """
        Returns all cart items for the current user.
        Example 'CartResponse' with items and total_price.
        """
        try:
            user_id = current_user["user_id"]
            cart_service = Cart(db)
            results = cart_service.get_cart_items(user_id)

            if not results:
                return CartResponse(message="Cart is empty", items=[], total_price=0.0)

            total_price = sum(item[4] for item in results)  # assuming item[4] is per-line total
            items = [
                CartItem(
                    article_code=item[0],
                    article_name=item[1],
                    price=item[2],
                    quantity=item[3],
                    total_price=item[4],
                )
                for item in results
            ]
            return CartResponse(
                message="Cart retrieved successfully", 
                items=items, 
                total_price=total_price
            )
        except Exception as e:
            logger.exception("Failed to retrieve cart items")
            raise_http_exception(500, f"Failed to retrieve cart items: {str(e)}")


    @app.put("/cart/update/", tags=["cart"])
    async def update_cart_item(
        cart_item: dict,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        """
        Update the quantity of a specific item in the cart.
        Expects cart_item like: {"article_code": 123, "quantity": 5}
        """
        try:
            user_id = current_user["user_id"]
            article_code = cart_item.get("article_code")
            quantity = cart_item.get("quantity")

            if not article_code or not quantity or quantity <= 0:
                raise_http_exception(400, "Invalid request data")

            cart_service = Cart(db)
            cart_service.update_cart_item(user_id, article_code, quantity)
            return {"message": "Cart item updated successfully"}
        except Exception as e:
            logger.exception("Failed to update cart item")
            raise_http_exception(500, f"Failed to update cart item: {str(e)}")


    @app.delete("/cart/delete/{article_code}", tags=["cart"])
    async def delete_cart_item(
        article_code: int,
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        """
        Deletes a specific item from the cart entirely.
        """
        try:
            user_id = current_user["user_id"]
            cart_service = Cart(db)
            cart_service.delete_cart_item(user_id, article_code)
            return {"message": "Cart item deleted successfully"}
        except Exception as e:
            logger.exception("Failed to delete cart item")
            raise_http_exception(500, f"Failed to delete cart item: {str(e)}")


    @app.get("/cart/debug", tags=["cart"])
    async def debug_cart(current_user: dict = Depends(get_current_user)):
        return {"user": current_user}

    @app.get("/cart/count/", response_model=CartCountResponse, tags=["cart"])
    def get_cart_count(
        db: DatabaseConnection = Depends(get_db),
        current_user: dict = Depends(get_current_user)
    ):
        user_id = current_user["user_id"]
        cart_service = Cart(db)
        total_quantity = cart_service.get_total_cart_quantity(user_id)
        return {"cart_count": total_quantity}

    @app.get("/")
    async def root():
        return {"message": "Welcome to the Quality Accelerators API playground"}
    
uvicorn.run(app, host='0.0.0.0', port=8000, log_level="debug")