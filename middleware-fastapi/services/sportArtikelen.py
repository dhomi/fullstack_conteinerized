# class SportsArticlesService:
#     def __init__(self, database_connection):
#         self.db = database_connection

#     def get_all_articles(self) -> List[SportsArticle]:
#         cursor = self.db.get_cursor()
#         if cursor is None:
#             raise Exception("Failed to get database cursor.")
#         try:
#             query = "SELECT * FROM QAsportarticles.sports_articles ORDER BY article_code"
#             cursor.execute(query)
#             result = cursor.fetchall()
#             return [SportsArticle(**row) for row in result]
#         except Exception as e:
#             print(f"Error fetching sports articles: {e}")
#             raise
#         finally:
#             cursor.close()

#     def get_article(self, article_code: int) -> SportsArticle:
#         cursor = self.db.get_cursor()
#         if cursor is None:
#             raise Exception("Failed to get database cursor.")
#         try:
#             query = "SELECT * FROM QAsportarticles.sports_articles WHERE article_code = %s"
#             cursor.execute(query, (article_code,))
#             row = cursor.fetchone()
#             if row:
#                 return SportsArticle(**row)
#             else:
#                 raise HTTPException(status_code=404, detail="Sports article not found.")
#         except Exception as e:
#             print(f"Error fetching sports article {article_code}: {e}")
#             raise
#         finally:
#             cursor.close()

#     def create_article(self, article: SportsArticle) -> SportsArticle:
#         cursor = self.db.get_cursor()
#         if cursor is None:
#             raise Exception("Failed to get database cursor.")
#         try:
#             insert_query = """
#                 INSERT INTO QAsportarticles.sports_articles 
#                 (article_name, category, size, color, price, stock_quantity, stock_min, vat_type) 
#                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
#             """
#             cursor.execute(insert_query, (
#                 article.article_name,
#                 article.category,
#                 article.size,
#                 article.color,
#                 article.price,
#                 article.stock_quantity,
#                 article.stock_min,
#                 article.vat_type
#             ))
#             self.db.connection.commit()
#             article_code = cursor.lastrowid  # Verondersteld dat article_code AUTO_INCREMENT is
#             return SportsArticle(
#                 article_code=article_code,
#                 article_name=article.article_name,
#                 category=article.category,
#                 size=article.size,
#                 color=article.color,
#                 price=article.price,
#                 stock_quantity=article.stock_quantity,
#                 stock_min=article.stock_min,
#                 vat_type=article.vat_type
#             )
#         except Exception as e:
#             print(f"Error creating sports article: {e}")
#             self.db.connection.rollback()
#             raise
#         finally:
#             cursor.close()

#     def update_article(self, article_code: int, article: SportsArticle) -> SportsArticle:
#         cursor = self.db.get_cursor()
#         if cursor is None:
#             raise Exception("Failed to get database cursor.")
#         try:
#             update_query = """
#                 UPDATE QAsportarticles.sports_articles
#                 SET article_name = %s, category = %s, size = %s, color = %s, 
#                     price = %s, stock_quantity = %s, stock_min = %s, vat_type = %s
#                 WHERE article_code = %s
#             """
#             cursor.execute(update_query, (
#                 article.article_name,
#                 article.category,
#                 article.size,
#                 article.color,
#                 article.price,
#                 article.stock_quantity,
#                 article.stock_min,
#                 article.vat_type,
#                 article_code
#             ))
#             self.db.connection.commit()
#             return SportsArticle(
#                 article_code=article_code,
#                 article_name=article.article_name,
#                 category=article.category,
#                 size=article.size,
#                 color=article.color,
#                 price=article.price,
#                 stock_quantity=article.stock_quantity,
#                 stock_min=article.stock_min,
#                 vat_type=article.vat_type
#             )
#         except Exception as e:
#             print(f"Error updating sports article {article_code}: {e}")
#             self.db.connection.rollback()
#             raise
#         finally:
#             cursor.close()

#     def delete_article(self, article_code: int) -> dict:
#         cursor = self.db.get_cursor()
#         if cursor is None:
#             raise Exception("Failed to get database cursor.")
#         try:
#             delete_query = "DELETE FROM QAsportarticles.sports_articles WHERE article_code = %s"
#             cursor.execute(delete_query, (article_code,))
#             self.db.connection.commit()
#             return {"article_code": article_code, "message": "Sports article deleted successfully."}
#         except Exception as e:
#             print(f"Error deleting sports article {article_code}: {e}")
#             self.db.connection.rollback()
#             raise
#         finally:
#             cursor.close()

class SportsArticlesService:
    def __init__(self, database_connection):
        self.db = database_connection

    def get_all_articles(self):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * from QAsportarticles.sports_articles"
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result

    def get_article(self, key):
        cursor = self.db.get_cursor()
        zoek_string = "SELECT * FROM QAsportarticles.sports_articles p"
        if key != 0:
            zoek_string += " where p.article_code = " + str(key)
        cursor.execute(zoek_string)
        result = cursor.fetchall()
        return result

    def add_new_article(
        self, article_name: str, category: str, size: str, 
        color: str, price: float, stock_quantity: int, stock_min: int, vat_type: str
    ):
        allowed_vat_types = {"H", "L"}
        if vat_type not in allowed_vat_types:
            raise ValueError("VAT type must be 'H' or 'L'")
        cursor = self.db.get_cursor()
        try:
            query = """
                INSERT INTO sports_articles (
                    article_name, category, size, color, price, 
                    stock_quantity, stock_min, vat_type
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (article_name, category, size, color, price, stock_quantity, stock_min, vat_type))
            self.db.connection.commit()
            return {
                "article_name": article_name,
                "category": category,
                "size": size,
                "color": color,
                "price": price,
                "stock_quantity": stock_quantity,
                "stock_min": stock_min,
                "vat_type": vat_type,
            }
        except Exception as e:
            print(f"Error adding article: {e}")
            self.db.connection.rollback()
            raise
        finally:
            cursor.close()

    def update_article(
        self,
        article_code: int,
        article_name: str,
        category: str,
        size: str,
        color: str,
        price: float,
        stock_quantity: int,
        stock_min: int,
        vat_type: str
    ):
        cursor = self.db.get_cursor()
        try:
            # Check if the article exists
            cursor.execute("SELECT * FROM sports_articles WHERE article_code = %s", (article_code,))
            existing_article = cursor.fetchone()
            if not existing_article:
                return {"error": f"Article with code {article_code} not found"}

            # Update the article
            update_query = """
                UPDATE sports_articles
                SET article_name = %s,
                    category = %s,
                    size = %s,
                    color = %s,
                    price = %s,
                    stock_quantity = %s,
                    stock_min = %s,
                    vat_type = %s
                WHERE article_code = %s
            """
            cursor.execute(
                update_query,
                (
                    article_name,
                    category,
                    size,
                    color,
                    price,
                    stock_quantity,
                    stock_min,
                    vat_type,
                    article_code
                )
            )
            self.db.connection.commit()
        except Exception as e:
            self.db.connection.rollback()
            print(f"Error updating article: {e}")
            return {"error": "Failed to update sports article"}
        finally:
            cursor.close()

        return {"message": "Article updated successfully"}
    
    def delete_article(self, article_code: int):
        cursor = self.db.get_cursor()
        try:
            # Check if the article exists
            cursor.execute("SELECT * FROM sports_articles WHERE article_code = %s", (article_code,))
            article = cursor.fetchone()
            if not article:
                return {"error": f"Article with code {article_code} not found"}

            # Delete the article
            cursor.execute("DELETE FROM sports_articles WHERE article_code = %s", (article_code,))
            self.db.connection.commit()
        except Exception as e:
            self.db.connection.rollback()
            print(f"Error deleting article: {e}")
            return {"error": "Failed to delete sports article"}
        finally:
            cursor.close()

        return {"message": "Article deleted successfully"}