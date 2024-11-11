import mysql.connector
from mysql.connector import Error

class DatabaseConnection:
    def __init__(self):
        self.connection = None
        self.connect()

    def connect(self):
        """Establish a new connection to the database."""
        try:
            # Todo variable in .ini file verplaatsen
            self.connection = mysql.connector.connect(
                host="db",
                port=3306,
                user="root",
                password="password",
                database="QAsportartikelen"
            )
            if self.connection.is_connected():
                print("Connected to the database!")
        except Error as e:
            print("Error while connecting to MySQL:", e)
            self.connection = None

    def close(self):
        """Close the database connection."""
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("Database connection closed.")

    def get_cursor(self):
        """Get a cursor, reconnecting if necessary."""
        if not self.connection or not self.connection.is_connected():
            print("Reconnecting to the database...")
            self.connect()

        if self.connection and self.connection.is_connected():
            return self.connection.cursor()
        else:
            print("Failed to connect to the database.")
            return None
