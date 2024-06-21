
# from django.contrib import admin
# from django.urls import path
# from rest_framework.urlpatterns import format_suffix_patterns
# from api.views import UserViewSet, ImageViewSet

# from django.conf import settings
# from django.conf.urls.static import static

# urlpatterns = [
#     path('admin/', admin.site.urls),
#     path('users/authenticate/', UserViewSet.as_view({'post': 'authenticate'}), name='user-authenticate'),

#     # image upload write post
#     path('image_upload/', ImageViewSet.as_view({'post': 'upload_image'}), name='image-upload'),

#     path('images/', ImageViewSet.as_view({'get': 'getImage'}), name='image-get'),

# ]+static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# # urlpatterns = format_suffix_patterns(urlpatterns)


from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.urlpatterns import format_suffix_patterns
from api.views import UserViewSet, ImagesList

urlpatterns = [
    path('admin/', admin.site.urls),
    path('users/authenticate/', UserViewSet.as_view({'post': 'authenticate'}), name='user-authenticate'),
    # path('images/', ImagesList.as_view(), name='image-list'),
    path('images/', ImagesList.as_view({'get': 'getImages', 'post': 'uploadImage'}), name='image-list'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
