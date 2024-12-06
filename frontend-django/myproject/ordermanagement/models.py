# ordermanagement/models.py
from django.db import models

class Order(models.Model):
    order_number = models.AutoField(primary_key=True)
    supplier_code = models.IntegerField()
    order_date = models.DateField(null=True, blank=True)
    delivery_date = models.DateField(null=True, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    status = models.CharField(max_length=1, null=True, blank=True)  # 'P', 'C', etc.
    status_description = models.CharField(max_length=20, null=True, blank=True)  # 'Pending', 'Cancelled', etc.

    def __str__(self):
        return f"Order {self.order_number} - Status: {self.status_description}"
