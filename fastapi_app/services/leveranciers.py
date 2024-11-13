class Leveranciers:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_levs(self):
        cursor = self.db.get_cursor()
        if cursor is None:
            raise Exception("Failed to get database cursor.")
        zoek_string = "SELECT * from QAsportartikelen.leveranciers order by levcode"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        cursor.close()
        return result

    def get_lev(self, key):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * from QAsportartikelen.leveranciers"
        if key == '0':
            zoek_string += " limit 1"
        else:
            zoek_string += " where levcode = " + str(key)
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result
    
    def add_lev(self, levnaam: str, adres: str, woonplaats: str):
        cursor = self.db.get_cursor() 
        try:
            # Corrected the column names in the INSERT statement
            add_lev = "INSERT INTO QAsportartikelen.leveranciers (levnaam, adres, woonplaats) VALUES (%s, %s, %s)" %(levnaam, adres, woonplaats)
            cursor.execute(add_lev)
            self.db.connection.commit()
        except Exception as e:
            print(f"Error adding supplier: {e}")  # You can replace this with actual logging if needed
            self.db.connection.rollback()
            raise
        return {"suppliername": levnaam, "address": adres, "residence": woonplaats}

    def update_lev(self, levcode: int, levnaam: str, adres: str, woonplaats: str):
        cursor = self.db.get_cursor()
        try:
            # SQL syntax for UPDATE query is correct here
            update_lev = "UPDATE QAsportartikelen.leveranciers SET levnaam=%s, adres=%s, woonplaats=%s WHERE levcode=%s" %(levnaam, adres, woonplaats, levcode)
            
            cursor.execute(update_lev)
            self.db.connection.commit()
        except Exception as e:
            print(f"Error updating supplier: {e}")
            self.db.connection.rollback()
            raise
        return {"suppliercode": levcode, "suppliername": levnaam, "address": adres, "residence": woonplaats}

    def delete_lev(self, levcode: int):
        cursor = self.db.get_cursor()
        try:
            delete_lev = "DELETE FROM QAsportartikelen.leveranciers WHERE levcode=%s"
            lev_data = (levcode,)
            cursor.execute(delete_lev, lev_data)
            self.db.connection.commit()
        except Exception as e:
            print(f"Error deleting supplier: {e}")
            self.db.connection.rollback()
            raise
        return {"suppliercode": levcode}
