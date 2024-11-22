class Delivery:
    def __init__(self, database_connection):
        self.db = database_connection
    
    def get_delivery(self):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT ordernr, artcode, delivery_date, amount_received, status, external_invoice_nr, serial_number FROM QAsportartikelen.successful_delivery"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result