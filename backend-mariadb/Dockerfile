# Use the official MariaDB image as a base
FROM mariadb:latest

# Set environment variables for MariaDB
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=QAsportartikelen
ENV MYSQL_USER=user
ENV MYSQL_PASSWORD=userpassword

# Copy the SQL file to the directory where MariaDB will auto-import it on startup
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the default MariaDB port
EXPOSE 3306
