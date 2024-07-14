# models.py

from django.db import models
from django.contrib.auth.models import User

class UserProject(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)  # using `user` instead of `userID`
    project_name = models.CharField(max_length=100)
    project_description = models.TextField()

    def __str__(self):
        return self.project_name

class Images(models.Model):
    image_name = models.CharField(max_length=100)
    image_url = models.ImageField(upload_to="savedImages/", blank=True)

    def __str__(self):
        return self.image_name
