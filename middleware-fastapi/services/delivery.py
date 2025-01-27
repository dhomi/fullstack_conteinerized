class Delivery:
    def __init__(self, database_connection):
        self.db = database_connection
    
    def get_delivery(self):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT receipt_id, ordernr, artcode, receipt_date, receipt_quantity, status, booking_number, sequence_number FROM QAsportartikelen.goods_receipt"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result