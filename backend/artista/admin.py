# Registro del modelo Artista en el panel de administración
from django.contrib import admin
from .models import Artista


@admin.register(Artista)
class ArtistaAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre_artistico', 'genero_principal', 'anio_inicio', 'estado')
    search_fields = ('nombre_artistico', 'genero_principal')
