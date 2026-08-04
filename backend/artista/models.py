# nota breve 11
from django.db import models


class Artista(models.Model):
    nombre_artistico = models.CharField(max_length=150)
    genero_principal = models.CharField(max_length=100)
    biografia = models.TextField(blank=True, null=True)
    anio_inicio = models.IntegerField(blank=True, null=True)
    hobbies = models.CharField(max_length=250, blank=True, null=True)
    estado = models.BooleanField(default=True)

    def __str__(self):
        return self.nombre_artistico
