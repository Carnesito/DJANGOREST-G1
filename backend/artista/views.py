# nota breve 12
from rest_framework import viewsets
from .models import Artista
from .serializers import ArtistaSerializer


class ArtistaViewSet(viewsets.ModelViewSet):
    queryset = Artista.objects.all()
    serializer_class = ArtistaSerializer
