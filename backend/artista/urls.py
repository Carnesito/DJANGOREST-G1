# nota breve 14
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ArtistaViewSet

router = DefaultRouter()
router.register(r'', ArtistaViewSet, basename='artista')

urlpatterns = [
    path('', include(router.urls)),
]
