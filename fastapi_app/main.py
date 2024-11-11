from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from services.routes import routes

if __name__ == '__main__':
    routes()
    