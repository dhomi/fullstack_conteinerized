class Bestellingen:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_all_orders(self):
        cursor = self.db.get_cursor()
        query = "SELECT * FROM QAsportarticles.orders ORDER BY order_number"
        cursor.execute(query)
        result = cursor.fetchall()
        return result

    def get_order(self, key):
        cursor = self.db.get_cursor()
        query = "SELECT * FROM QAsportarticles.orders"
        query += " where supplier_code = " + str(key) 
        query += " order by order_number"
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    
    def add_neworders(self, levcode: int, besteldat: str, leverdat: str, bedrag: float, status: str):
        cursor = self.db.get_cursor()
        query = "INSERT INTO QAsportarticles.orders (supplier_code, order_date, delivery_date, amount, status) VALUES (%s, %s, %s, %s, %s)"
        best_data = (levcode, besteldat, leverdat, bedrag, status)
        cursor.execute(query, best_data)
        self.db.connection.commit()
        return {"message": "Order created successfully."} 

    def update_orders(self, best_nr: int, levcode: int, besteldat: str, leverdat: str, bedrag: float, status: str):
        cursor = self.db.get_cursor()
        query = "UPDATE QAsportarticles.orders SET supplier_code = %s, order_date = %s, delivery_date = %s, amount = %s, status = %s WHERE order_number=%s"
        best_data = (levcode, besteldat, leverdat, bedrag, status, best_nr)
        cursor.execute(query, best_data)
        self.db.connection.commit()
        return {"message": "Order updated successfully."}
    
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
                    b.amount, 
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