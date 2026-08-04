# nota breve 19
from django.db import models


class Disquera(models.Model):
    nombre = models.CharField(max_length=200)
    pais_origen = models.CharField(max_length=100, blank=True, null=True)
    anio_fundacion = models.IntegerField(blank=True, null=True)
    email_contacto = models.EmailField(blank=True, null=True)
    estado = models.BooleanField(default=True)

    def __str__(self):
        return self.nombre
