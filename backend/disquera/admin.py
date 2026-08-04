# Registro del modelo Disquera en el panel de administración
from django.contrib import admin
from .models import Disquera


@admin.register(Disquera)
class DisqueraAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre', 'pais_origen', 'anio_fundacion', 'estado')
    search_fields = ('nombre',)
