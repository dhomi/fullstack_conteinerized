# Use the official Python image
FROM python:3.10

# Set the working directory to /django_app
WORKDIR /django_app

# Copy the Django project code to /django_app
COPY . .

# Install dependencies
# COPY requirements.txt /django_app/
RUN pip install --no-cache-dir -r /django_app/requirements.txt


# Expose the port Django will run on
EXPOSE 8001

# Optional: you could use the CMD here if not in docker-compose.yml
# CMD ["python", "/django_app/myproject/manage.py", "runserver", "0.0.0.0:8001"]
