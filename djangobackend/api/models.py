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

class File(models.Model):
    file_name = models.CharField(max_length=100)
    file_url = models.FileField(upload_to="savedFiles/", blank=True)

    def __str__(self):
        return self.file_name
