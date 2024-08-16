from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.urlpatterns import format_suffix_patterns
from api.views import ImagesList, LoginView, UserView, UserProjectList, ProjectImageList, ProjectImageUpload, test_cors

urlpatterns = [
    path('admin/', admin.site.urls),

    path('test-cors/', test_cors, name='test_cors'), # for testing CORS

    path('users/login/', LoginView.as_view({'post': 'login'}), name='user-login'),

    path('users/', UserView.as_view({'get': 'userDetails'}), name='user-details'),

    path('projects/', UserProjectList.as_view({'get': 'projectList', 'post' : 'addProject', 'put' : 'editProject', 'delete' : 'deleteProject' }), name='project-list'),

    # path('images/', ImagesList.as_view({'post': 'uploadImage'}), name='image-list'),

    # path('project-images/', ProjectImageList.as_view({'post': 'projectImagesList', 'delete' : 'deleteImage' }), name='project-image-list'),

    # path('project-images/upload/', ProjectImageUpload.as_view({'post': 'projectImageUpload'}), name='project-image-upload'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
