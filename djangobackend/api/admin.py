from django.contrib import admin
from .models import User, Images, UserProject

# Register your models here.

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['id', 'username', 'password']

@admin.register(UserProject)
class UserProjectAdmin(admin.ModelAdmin):
    list_display = ['id', 'userID', 'project_name', 'project_description']

@admin.register(Images)
class ImagesAdmin(admin.ModelAdmin):
    list_display = ['id', 'image_name', 'image_url']