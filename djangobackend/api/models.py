from django.db import models

class User(models.Model):
    username = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=100)

    def __str__(self):
        return self.username

class Images(models.Model):
    image_name = models.CharField(max_length=100)
    image_url = models.ImageField(upload_to="savedImages/", blank=True)

    def __str__(self):
        return self.image_name

# class ImageFolder(models.Model):
#     folder_name = models.CharField(max_length=100)
#     folder_url = models.ImageField(upload_to="savedImages/", blank=True)

#     def __str__(self):
#         return self.folder_name
