# nota breve 20
from rest_framework import viewsets
from .models import Disquera
from .serializers import DisqueraSerializer


class DisqueraViewSet(viewsets.ModelViewSet):
    queryset = Disquera.objects.all()
    serializer_class = DisqueraSerializer
