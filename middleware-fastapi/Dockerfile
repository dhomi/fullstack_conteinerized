# Use an official Python runtime as the base image
FROM python:3.10.5

# Set the working directory to /app
WORKDIR /middleware-fastapi

# Copy the current directory contents into the container at /app
COPY . .

# Install the required packages
RUN pip install --no-cache-dir -r /middleware-fastapi/requirements.txt

# Set environment variable
ENV FLASK_APP=fastApi
ENV FLASK_ENV=development

# Expose port 8000 for the Flask app
EXPOSE 8000

# Run the command to start the FastAPI app
# CMD ["python3", "main.py"]
