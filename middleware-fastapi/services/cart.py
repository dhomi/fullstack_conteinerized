# services/cart.py

class Cart:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_cart_items(self, user_id: int):
        cursor = self.db.get_cursor()
        query = """
        SELECT 
            c.article_code,
            sa.article_name,
            sa.price,
            c.quantity,
            (sa.price * c.quantity) AS total_price
        FROM
            cart c
        JOIN
            sports_articles sa ON c.article_code = sa.article_code
        WHERE
            c.user_id = %s
        """
        cursor.execute(query, (user_id,))
        result = cursor.fetchall()
        cursor.close()
        return result

    def update_cart_item(self, user_id: int, article_code: int, quantity: int):
        cursor = self.db.get_cursor()
        query = """
        UPDATE cart
        SET quantity = %s
        WHERE user_id = %s AND article_code = %s
        """
        cursor.execute(query, (quantity, user_id, article_code))
        self.db.connection.commit()
        cursor.close()

    def add_to_cart(self, user_id: int, article_code: int, quantity: int = 1):
        """
        Insert or update the cart record with the given quantity.
        """
        cursor = self.db.get_cursor()
        query = """
        INSERT INTO cart (user_id, article_code, quantity)
        VALUES (%s, %s, %s)
        ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)
        """
        cursor.execute(query, (user_id, article_code, quantity))
        self.db.connection.commit()
        cursor.close()

    def delete_cart_item(self, user_id: int, article_code: int):
        cursor = self.db.get_cursor()
        query = "DELETE FROM cart WHERE user_id = %s AND article_code = %s"
        cursor.execute(query, (user_id, article_code))
        self.db.connection.commit()
        cursor.close()

    def get_total_cart_quantity(self, user_id: int) -> int:
        cursor = self.db.get_cursor()
        query = """
            SELECT IFNULL(SUM(quantity), 0) AS total_quantity
            FROM cart
            WHERE user_id = %s
        """
        cursor.execute(query, (user_id,))
        row = cursor.fetchone()
        cursor.close()
        return row[0] if row else 0