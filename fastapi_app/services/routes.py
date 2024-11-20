from fastapi import FastAPI, HTTPException, Request, Depends
from fastapi.security import OAuth2PasswordBearer
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import JSONResponse
from models.supplierdetails import LeverancierBase, LeverancierDetail, LeverancierCreate
from models.orderdetails import BestellingBase, BestellingDetail, BestellingDetailBase, BestellingDetailCreate, BestellingDetailUpdate, BestellingDetails, BestellingDetailsArt
from models.deliverydetails import SuccessfulDelivery, SuccessfulDeliveryBase
# from models.sportarticlesDetails import SportsArticle
from utils.db import DatabaseConnection
from services.leveranciers import Leveranciers
from services.bestellingen import Bestellingen
# from services.sportArtikelen import SportsArticlesService
from services.delivery import Delivery
from pydantic import BaseModel
import uvicorn
from loguru import logger

class ErrorResponse(BaseModel):
    detail: str

## in de toekomst kunnen we meer scenarios toevoegen.
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


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

## Todo token logica toevoegen dit is een dummy
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Mock function voor token
def verify_token(token: str = Depends(oauth2_scheme)):
    if token != "expected_token":
        logger.warning("Unauthorized access attempt")
        raise HTTPException(status_code=401, detail="Invalid or expired token")

# Generieke exception 
def raise_http_exception(status_code: int, detail: str):
    logger.error(f"Error {status_code}: {detail}")
    raise HTTPException(status_code=status_code, detail=detail)

# Custom error handling
@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    logger.exception("Unexpected error")
    return JSONResponse(
        status_code=500,
        content={"detail": "An unexpected error occurred. Please try again later."},
    )

async def get_db():
    db = DatabaseConnection()
    try:
        yield db
    finally:
        db.close()


# Example Dependency for Authorization
async def get_current_user(token: str):
    if not token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Unauthorized access")
    return token

class routes:
    @app.get("/suppliers", description="Get all suppliers", tags=["suppliers"])
    async def get_leveranciers(db: DatabaseConnection = Depends(get_db)):
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
    async def get_leverancier(suppliercode: int, db: DatabaseConnection = Depends(get_db)):
        try:
            leveranciers = Leveranciers(db)
            result = leveranciers.get_lev(suppliercode)
            if not result:
                raise_http_exception(404, "Supplier not found")
            return {
                "suppliercode": result[0][0],
                "suppliername": result[0][1],
                "address": result[0][2],
                "residence": result[0][3]
            }
        except Exception as e:
            logger.exception("Failed to retrieve supplier")
            raise_http_exception(500, "Failed to retrieve supplier")

    @app.post("/suppliers/", tags=["suppliers"])
    async def create_leverancier(leverancier: LeverancierCreate):
        try:
            db = DatabaseConnection()
            lev = Leveranciers(db)
            # Pass individual attributes from the LeverancierCreate model to add_lev
            result = lev.add_lev(leverancier.levnaam, leverancier.adres, leverancier.woonplaats)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return result
        except Exception as e:
            logger.exception("Failed to create supplier")
            raise_http_exception(500, "Failed to create supplier")


    @app.put("/suppliers/{suppliercode}", tags=["suppliers"])
    async def update_leverancier(suppliercode: str, leverancier: LeverancierBase, db: DatabaseConnection = Depends(get_db)):
        try:
            lev = Leveranciers(db)
            # Pass individual attributes
            result = lev.update_lev(
                suppliercode, 
                leverancier.levnaam, 
                leverancier.adres, 
                leverancier.woonplaats
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return result
        except Exception as e:
            logger.exception("Failed to update supplier")
            raise_http_exception(500, "Failed to update supplier")

    @app.delete("/suppliers/{suppliercode}", tags=["suppliers"])
    async def delete_leverancier(suppliercode: str, db: DatabaseConnection = Depends(get_db)):
        try:
            lev = Leveranciers(db)
            result = lev.delete_lev(suppliercode)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Supplier deleted"}
        except Exception as e:
            logger.exception("Failed to delete supplier")
            raise_http_exception(500, "Failed to delete supplier")

    @app.get("/orders", tags=["orders"])
    async def get_bestellingen(db: DatabaseConnection = Depends(get_db)):
        try:
            bestellingen = Bestellingen(db)
            result = bestellingen.get_all_orders()
            if not result:
                raise_http_exception(404, "Orders not found")
            return [
                {"ordernr": r[0], "suppliercode": r[1], "orderdate": r[2], "deliverydate": r[3], "price": r[4], "status": r[5]}
                for r in result
            ]
        except Exception as e:
            logger.exception("Failed to retrieve orders")
            raise_http_exception(500, "Failed to retrieve orders")

    @app.get("/orders/{suppliercode}", tags=["orders"])
    async def get_bestelling(suppliercode: int, db: DatabaseConnection = Depends(get_db)):
        try:
            bestellingen = Bestellingen(db)
            result = bestellingen.get_order(suppliercode)
            if not result:
                raise_http_exception(404, "Order not found")
            return {
                "ordernr": result[0][0],
                "suppliercode": result[0][1],
                "orderdate": result[0][2],
                "deliverydate": result[0][3],
                "amount": result[0][4],
                "status": result[0][5]
            }
        except Exception as e:
            logger.exception("Failed to retrieve order")
            raise_http_exception(500, "Failed to retrieve order")

    @app.post("/orders/", tags=["orders"])
    async def create_bestelling(bestelling: BestellingDetailCreate, db: DatabaseConnection = Depends(get_db)):
        try:
            best = Bestellingen(db)
            result = best.add_neworders(
                bestelling.suppliercode, bestelling.artcode, bestelling.amount,
                bestelling.orderprice, bestelling.orderdate, bestelling.deliverydate, bestelling.price, bestelling.status
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return result
        except Exception as e:
            logger.exception("Failed to create bestelling")
            raise_http_exception(500, "Failed to create bestelling")

    @app.put("/orders/{ordernr}", tags=["orders"])
    async def update_bestelling(ordernr: str, bestelling: BestellingBase, db: DatabaseConnection = Depends(get_db)):
        try:
            best = Bestellingen(db)
            result = best.update_orders(
                ordernr,
                bestelling.suppliercode,
                bestelling.orderdate,
                bestelling.deliverydate,
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
    async def delete_bestelling(ordernr: str, db: DatabaseConnection = Depends(get_db)):
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
    async def get_bestellingdetails(ordernr: int, db: DatabaseConnection = Depends(get_db), skip: int = 0, limit: int = 100):
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
    async def get_orderdetails_artcode(artcode: int, db: DatabaseConnection = Depends(get_db)):
        try:
            bestDetails = Bestellingen(db)
            results = bestDetails.get_orderlinewithArtcode(artcode)
            bestellingdetails = [
                BestellingDetailsArt(
                    ordernr=result[0],
                    artcode=result[1],
                    amount=result[2],
                    orderprice=result[3]
                )
                for result in results
            ]
            if "error" in results:
                raise_http_exception(400, results["error"])
            return bestellingdetails
        except Exception as e:
            logger.exception("Failed to retrieve bestelling details by artcode")
            raise_http_exception(500, "Failed to retrieve bestelling details by artcode")

    @app.post("/orderdetails", tags=["order details"])
    async def create_bestellingdetails(bestellingdetails: BestellingDetails, db: DatabaseConnection = Depends(get_db)):
        try:
            bestDetails = Bestellingen(db)
            result = bestDetails.add_neworders(
                bestellingdetails.suppliercode,
                bestellingdetails.artcode,
                bestellingdetails.amount,
                bestellingdetails.orderprice,
                bestellingdetails.orderdate,
                bestellingdetails.deliverydate,
                bestellingdetails.price,
                bestellingdetails.status
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return bestellingdetails
        except Exception as e:
            logger.exception("Failed to create bestelling details")
            raise_http_exception(500, "Failed to create bestelling details")

    @app.put("/orderdetails/{ordernr}", tags=["order details"])
    async def update_bestellingdetails(ordernr: int, bestellingdetails: BestellingDetails, db: DatabaseConnection = Depends(get_db)):
        try:
            bestDetails = Bestellingen(db)
            result = bestDetails.update_orders(
                ordernr,
                bestellingdetails.suppliercode,
                bestellingdetails.artcode,
                bestellingdetails.artikelnaam,
                bestellingdetails.amount,
                bestellingdetails.orderprice,
                bestellingdetails.orderdate,
                bestellingdetails.deliverydate,
                bestellingdetails.status,
                bestellingdetails.price
            )
            if "error" in result:
                raise_http_exception(400, result["error"])
            return bestellingdetails
        except Exception as e:
            logger.exception("Failed to update bestelling details")
            raise_http_exception(500, "Failed to update bestelling details")

    @app.delete("/orderdetails/{ordernr}", tags=["order details"])
    async def delete_bestellingdetails(ordernr: int, db: DatabaseConnection = Depends(get_db)):
        try:
            bestDetails = Bestellingen(db)
            result = bestDetails.delete_orders(ordernr)
            if "error" in result:
                raise_http_exception(400, result["error"])
            return {"message": "Bestelling details deleted"}
        except Exception as e:
            logger.exception("Failed to delete bestelling details")
            raise_http_exception(500, "Failed to delete bestelling details")
    
    # @app.get("/sports_articles", response_model=List[SportsArticle])
    # def read_sports_articles():
    #     return SportsArticlesService.get_all_articles()

    # @app.get("/sports_articles/{article_code}", response_model=SportsArticle)
    # def read_sports_article(article_code: int):
    #     return SportsArticlesService.get_article(article_code)

    # @app.post("/sports_articles", response_model=SportsArticle)
    # def create_sports_article(article: SportsArticle):
    #     return SportsArticlesService.create_article(article)

    # @app.put("/sports_articles/{article_code}", response_model=SportsArticle)
    # def update_sports_article(article_code: int, article: SportsArticle):
    #     return SportsArticlesService.update_article(article_code, article)

    # @app.delete("/sports_articles/{article_code}", response_model=dict)
    # def delete_sports_article(article_code: int):
    #     return SportsArticlesService.delete_article(article_code)
    
    @app.get("/successful_deliveries", description="Get all successful deliveries", tags=["deliveries"])
    async def get_successful_deliveries():
        db = DatabaseConnection()
        successful_deliveries = Delivery(db)
        result = successful_deliveries.get_delivery()
        if not result:
            raise HTTPException(status_code=400, detail="successful deliveries not found")
        return [{"ordernr": r[0], "artcode": r[1], "delivery_date": r[2], "amount_received": r[3], "status": r[4], "external_invoice_nr": r[5], "serial_number": r[6]} for r in result]

    @app.get("/")
    async def root():
        return {"message": "Welcome to the Quality Accelerators API playground"}
    
    uvicorn.run(app, host='0.0.0.0', port=8000, log_level="debug")