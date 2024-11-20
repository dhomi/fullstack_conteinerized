class Leveranciers:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_levs(self):
        cursor = self.db.get_cursor()
        if cursor is None:
            raise Exception("Failed to get database cursor.")
        query = "SELECT * FROM QAsportarticles.suppliers ORDER BY supplier_code"
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        return result

    def get_lev(self, key):
        cursor = self.db.get_cursor()
        query = "SELECT * FROM QAsportarticles.suppliers"
        if key == '0':
            query += " LIMIT 1"
            query.execute(query)
        else:
            query += " WHERE supplier_code = %s"
            cursor.execute(query, (key,))
        result = cursor.fetchall()
        cursor.close()
        return result
    
    def add_lev(self, supplier_name: str, address: str, city: str):
        cursor = self.db.get_cursor()
        try:
            add_lev = "INSERT INTO QAsportarticles.suppliers (supplier_name, address, city) VALUES (%s, %s, %s)"
            cursor.execute(add_lev, (supplier_name, address, city))
            self.db.connection.commit()
        except Exception as e:
            print(f"Error adding supplier: {e}")
            self.db.connection.rollback()
            raise
        finally:
            cursor.close()
        return {"suppliername": supplier_name, "address": address, "residence": city}

    def update_lev(self, supplier_code: int, supplier_name: str, address: str, city: str):
        cursor = self.db.get_cursor()
        try:
            update_lev = "UPDATE QAsportarticles.suppliers SET supplier_name = %s, address = %s, city = %s WHERE supplier_code = %s"
            cursor.execute(update_lev, (supplier_name, address, city, supplier_code))
            self.db.connection.commit()
        except Exception as e:
            print(f"Error updating supplier: {e}")
            self.db.connection.rollback()
            raise
        finally:
            cursor.close()
        return {"suppliercode": supplier_code, "suppliername": supplier_name, "address": address, "residence": city}

    def delete_lev(self, supplier_code: int):
        cursor = self.db.get_cursor()
        try:
            delete_lev = "DELETE FROM QAsportarticles.suppliers WHERE supplier_code = %s"
            cursor.execute(delete_lev, (supplier_code,))
            self.db.connection.commit()
        except Exception as e:
            print(f"Error deleting supplier: {e}")
            self.db.connection.rollback()
            raise
        finally:
            cursor.close()
        return {"suppliercode": supplier_code}
