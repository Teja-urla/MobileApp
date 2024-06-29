from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.urlpatterns import format_suffix_patterns
from api.views import ImagesList, LoginView, UserView

urlpatterns = [
    path('admin/', admin.site.urls),
    # path('users/register/', RegisterView.as_view(), name='user-register'),
    # path('users/register/', RegisterView.as_view({'post': 'register'}), name='user-register'),

    # path('users/login/', LoginView.as_view(), name='user-login'),
    path('users/login/', LoginView.as_view({'post': 'login'}), name='user-login'),

    # path('users/', UserView.as_view(), name='user-list'),
    path('users/', UserView.as_view({'get': 'list'}), name='user-list'),
    # path('users/logout/', Logout.as_view(), name='user-logout'),

    path('images/', ImagesList.as_view({'post': 'uploadImage'}), name='image-list'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
