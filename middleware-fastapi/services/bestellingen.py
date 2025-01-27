class Bestellingen:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_all_orders(self):
        cursor = self.db.get_cursor()
        query = "SELECT * FROM QAsportarticles.orders ORDER BY order_number"
        cursor.execute(query)
        result = cursor.fetchall()
        return result

    def get_order(self, suppliercode: int):
        try:
            cursor = self.db.get_cursor()
            query = """
                SELECT order_number, supplier_code, order_date, delivery_date, amount, status, status_description
                FROM QAsportarticles.orders
                WHERE supplier_code = %s
            """
            # self.db.cursor.execute(query, (suppliercode,))
            # return self.db.cursor.fetchall()  # Fetch all matching rows
            cursor.execute(query, (suppliercode,))
            result = cursor.fetchall()
            return result      
        except Exception as e:
            logger.exception("Error fetching orders for supplier code")
            return []
    
    def track_order(self, key):
        cursor = self.db.get_cursor()
        query = "SELECT * FROM QAsportarticles.orders"
        query += " where order_number = " + str(key) 
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    
    def add_neworders(self, order_number: int, supplier_code: int, order_date: str, delivery_date: str, amount: float, status: str, status_description: str):
        try:
            cursor = self.db.get_cursor()
            query = """
                INSERT INTO QAsportarticles.orders 
                (order_number, supplier_code, order_date, delivery_date, amount, status, status_description) 
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            best_data = (order_number, supplier_code, order_date, delivery_date, amount, status, status_description)
            cursor.execute(query, best_data)
            self.db.connection.commit()
            return {"message": "Order created successfully."}
        except Exception as e:
            print(f"Error adding new order: {e}")
            raise 
    
    def delete_orders(self, best_nr):
        cursor = self.db.get_cursor()
        query = "DELETE FROM QAsportarticles.orders WHERE order_number=%s"
        cursor.execute(query, (best_nr,))
        self.db.connection.commit()
        return {"message": "Order deleted successfully."} 

    def get_orderlines(self, best_nr):
        cursor = self.db.get_cursor()
        query = """
                SELECT 
                    b.supplier_code, 
                    br.order_number, 
                    br.article_code, 
                    p.article_name, 
                    br.order_price, 
                    b.order_date, 
                    b.delivery_date, 
                    b.status
                FROM 
                    QAsportarticles.order_lines br
                JOIN 
                    QAsportarticles.sports_articles p ON p.article_code = br.article_code
                JOIN 
                    QAsportarticles.orders b ON b.order_number = br.order_number
                WHERE 
                    br.order_number = %s
            """
        cursor.execute(query, (best_nr,))
        result = cursor.fetchall()
        return result      

    def get_orderlinewithArtcode(self, artcode):
        cursor = self.db.get_cursor()
        query = "SELECT * from QAsportarticles.order_lines where article_code = '%s'" %(artcode)
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    
    def update_order_details(
        self,
        ordernr: int,
        supplier_code: int,
        order_number: int,
        article_code: int,
        article_name: str,
        order_price: float,
        order_date: str,
        delivery_date: str,
        status: str,
    ):
        cursor = self.db.get_cursor()

        try:
            # Update the orders table
            orders_query = """
                UPDATE QAsportarticles.orders
                SET supplier_code = %s, order_date = %s, delivery_date = %s, status = %s
                WHERE order_number = %s
            """
            orders_data = (supplier_code, order_date, delivery_date, status, ordernr)
            cursor.execute(orders_query, orders_data)

            # Update the order_lines table
            order_lines_query = """
                UPDATE QAsportarticles.order_lines
                SET article_code = %s, order_price = %s
                WHERE order_number = %s AND article_code = %s
            """
            order_lines_data = (article_code, order_price, ordernr, article_code)
            cursor.execute(order_lines_query, order_lines_data)

            # Update the sports_articles table (if needed, for article_name)
            sports_articles_query = """
                UPDATE QAsportarticles.sports_articles
                SET article_name = %s
                WHERE article_code = %s
            """
            sports_articles_data = (article_name, article_code)
            cursor.execute(sports_articles_query, sports_articles_data)

            # Commit changes
            self.db.connection.commit()
            return {"message": "Order details updated successfully."}

        except Exception as e:
            self.db.connection.rollback()  # Rollback in case of error
            raise e

        finally:
            cursor.close()