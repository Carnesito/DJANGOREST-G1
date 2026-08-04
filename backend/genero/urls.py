# nota breve 26
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import GeneroViewSet

router = DefaultRouter()
router.register(r'', GeneroViewSet, basename='genero')

urlpatterns = [
    path('', include(router.urls)),
]
