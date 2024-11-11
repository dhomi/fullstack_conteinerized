class Sportartikelen:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_sportartikelen(self):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * from QAsportartikelen.sportartikelen"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result

    def get_sportartikel_details(self, key):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * FROM QAsportartikelen.sportartikelen s"
        if key != 0:
            zoek_string += " where s.artcode = " + str(key)
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result