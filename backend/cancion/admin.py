from django.contrib import admin
from .models import Cancion


@admin.register(Cancion)
class CancionAdmin(admin.ModelAdmin):
    list_display = ('id', 'titulo', 'artista', 'album', 'precio', 'estado')
    search_fields = ('titulo',)
