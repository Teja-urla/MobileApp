from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.urlpatterns import format_suffix_patterns
from api.views import ImagesList, LoginView, UserView, UserProjectList

urlpatterns = [
    path('admin/', admin.site.urls),
    path('users/login/', LoginView.as_view({'post': 'login'}), name='user-login'),

    path('users/', UserView.as_view({'get': 'list'}), name='user-list'),

    path('projects/', UserProjectList.as_view({'get': 'projectList', 'post' : 'addProject', 'put' : 'editProject', 'delete' : 'deleteProject' }), name='project-list'),

    path('images/', ImagesList.as_view({'post': 'uploadImage'}), name='image-list'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
