from django.contrib import admin
from .models import Images, UserProject

@admin.register(UserProject)
class UserProjectAdmin(admin.ModelAdmin):
    list_display = ['id', 'user_id', 'project_name', 'project_description']

@admin.register(Images)
class ImagesAdmin(admin.ModelAdmin):
    list_display = ['id', 'image_name', 'image_url']
