class GoodsReceipts:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_goodsReceipts(self):
        cursor = self.db.get_cursor()
        query = "SELECT * from QAsportarticles.goods_receipt"
        cursor.execute(query)
        result = cursor.fetchall()
        return result   