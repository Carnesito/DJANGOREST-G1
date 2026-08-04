# nota breve 15
from django.db import models
from album.models import Album
from artista.models import Artista


class Cancion(models.Model):
    titulo = models.CharField(max_length=200)
    duracion_segundos = models.IntegerField(blank=True, null=True)
    precio = models.DecimalField(max_digits=8, decimal_places=2, default=0.0)
    album = models.ForeignKey(Album, on_delete=models.CASCADE, related_name='canciones', null=True, blank=True)
    artista = models.ForeignKey(Artista, on_delete=models.CASCADE, related_name='canciones', null=True, blank=True)
    estado = models.BooleanField(default=True)

    def __str__(self):
        return self.titulo
