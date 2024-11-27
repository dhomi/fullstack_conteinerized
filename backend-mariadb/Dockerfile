# Use the official MariaDB image as the base
FROM mariadb:latest

# Set environment variables
ENV MYSQL_USER=QAuser \
    MYSQL_PASSWORD=QApassword \
    MYSQL_ROOT_PASSWORD=password \
    MYSQL_DATABASE=QAsportarticles

# Copy the init.sql script to the MariaDB initialization directory
COPY ./init.sql /docker-entrypoint-initdb.d/

# Expose the default MariaDB port
EXPOSE 3306
