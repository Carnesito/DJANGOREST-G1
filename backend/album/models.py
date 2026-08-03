from django.db import models
from disquera.models import Disquera

class Album(models.Model):
    titulo = models.CharField(max_length=150)
    fecha_lanzamiento = models.DateField()
    portada_url = models.URLField(max_length=500, blank=True, null=True)
    disquera = models.ForeignKey(Disquera, on_delete=models.CASCADE, related_name='albumes')
    estado = models.BooleanField(default=True)

    def __str__(self):
        return self.titulo
