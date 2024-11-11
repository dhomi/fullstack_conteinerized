# Use the official Python image
FROM python:3.10

# Set the working directory to /django_app
WORKDIR /django_app

# Install dependencies
# COPY requirements.txt /django_app/
# RUN pip install -r requirements.txt

# Copy the Django project code to /django_app
COPY . /django_app/

# Expose the port Django will run on
EXPOSE 8001

# Optional: you could use the CMD here if not in docker-compose.yml
# CMD ["python", "/django_app/myproject/manage.py", "runserver", "0.0.0.0:8001"]
