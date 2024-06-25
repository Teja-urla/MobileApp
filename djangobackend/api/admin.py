from django.contrib import admin
from .models import User, Images, File

# Register your models here.

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['id', 'username', 'password']

@admin.register(Images)
class ImagesAdmin(admin.ModelAdmin):
    list_display = ['id', 'image_name', 'image_url']

@admin.register(File)
class FileAdmin(admin.ModelAdmin):
    list_display = ['id', 'file_name', 'file_url']
