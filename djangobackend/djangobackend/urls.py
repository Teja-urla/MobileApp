
from django.contrib import admin
from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from api.views import StudentViewSet

urlpatterns = [
    path('admin/', admin.site.urls),
    path('students/', StudentViewSet.as_view({'get': 'list', 'post': 'create'}), name='student-list-create'),
    path('students/validate/', StudentViewSet.as_view({'post': 'validate'}), name='student-validate'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
