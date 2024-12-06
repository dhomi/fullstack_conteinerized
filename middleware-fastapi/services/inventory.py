class Inventory:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_inventory_from_db(self):
        cursor = self.db.get_cursor()
        query = """
        SELECT 
            sa.article_code,
            sa.article_name,
            sa.category,
            sa.size,
            sa.color,
            sa.price,
            sa.stock_quantity,
            sa.stock_min,
            IFNULL(SUM(gr.receipt_quantity), 0) AS incoming_stock,
            IFNULL(SUM(ol.quantity), 0) AS reserved_stock,
            CASE
                WHEN sa.stock_quantity = 0 THEN 'Out of Stock'
                WHEN sa.stock_quantity < sa.stock_min THEN 'Low Stock'
                ELSE 'OK'
            END AS status
        FROM
            sports_articles sa
        LEFT JOIN
            goods_receipt gr ON sa.article_code = gr.article_code
        LEFT JOIN
            order_lines ol ON sa.article_code = ol.article_code
        GROUP BY
            sa.article_code,
            sa.article_name,
            sa.category,
            sa.size,
            sa.color,
            sa.price,
            sa.stock_quantity,
            sa.stock_min
        """
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()  # It is a good practice to close the cursor after usage
        return result
