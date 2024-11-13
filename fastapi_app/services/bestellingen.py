class Bestellingen:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_all_bests(self):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * from QAsportartikelen.bestellingen order by bestelnr"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result

    def get_bests(self, key):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * from QAsportartikelen.bestellingen"
        zoek_string += " where levcode = " + str(key) 
        zoek_string += " order by bestelnr"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result
    
    def create_best(self, levcode: int, besteldat: str, leverdat: str, bedrag: float, status: str):
        cursor = self.db.get_cursor()
        add_best = "INSERT INTO QAsportartikelen.bestellingen (levcode, besteldat, leverdat, bedrag, status) VALUES (%s, %s, %s, %s, %s)"
        best_data = (levcode, besteldat, leverdat, bedrag, status)
        cursor.execute(add_best, best_data)
        self.db.connection.commit()
        return {"message": "Order created successfully."} 

    def update_best(self, best_nr: int, levcode: int, besteldat: str, leverdat: str, bedrag: float, status: str):
        cursor = self.db.get_cursor()
        update_best = "UPDATE QAsportartikelen.bestellingen SET levcode=%s, besteldat=%s, leverdat=%s, bedrag=%s, status=%s WHERE bestelnr=%s"
        best_data = (levcode, besteldat, leverdat, bedrag, status, best_nr)
        cursor.execute(update_best, best_data)
        self.db.connection.commit()
        return {"message": "Order updated successfully."}
    
    def delete_best(self, best_nr):
        cursor = self.db.get_cursor()
        delete_best = "DELETE FROM QAsportartikelen.bestellingen WHERE bestelnr=%s"
        cursor.execute(delete_best, (best_nr,))
        self.db.connection.commit()
        return {"message": "Order deleted successfully."} 

    def get_bestregs(self, best_nr):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT b.levcode, br.bestelnr, br.artcode, p.artikelnaam, br.bestelprijs, b.besteldat, b.leverdat, b.bedrag, b.status"
        zoek_string += " from QAsportartikelen.bestelregels br, QAsportartikelen.sportartikelen p, QAsportartikelen.bestellingen b"
        zoek_string += " where br.bestelnr = " + str(best_nr)
        zoek_string += " and p.artcode = br.artcode"
        zoek_string += " and b.bestelnr = br.bestelnr"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result      

    def get_bestregsWithArtcode(self, artcode):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * from QAsportartikelen.bestelregels where artcode = '%s'" %(artcode)
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result      