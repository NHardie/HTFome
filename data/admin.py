from django.contrib import admin

# Register your models here.
# Add models, aka databases, can now add things via the /admin page

from .models import Htf, Drug

admin.site.register(Htf)
admin.site.register(Drug)