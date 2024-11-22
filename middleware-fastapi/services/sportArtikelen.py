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