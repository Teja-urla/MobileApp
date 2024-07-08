from django.db import models

class User(models.Model):
    username = models.CharField(max_length=100)
    password = models.CharField(max_length=100)

    def __str__(self):
        return self.username

class UserProject(models.Model):
    userID = models.ForeignKey(User, on_delete=models.CASCADE)
    project_name = models.CharField(max_length=100)
    project_description = models.TextField()

    def __str__(self):
        return self.project_name

class Images(models.Model):
    image_name = models.CharField(max_length=100)
    image_url = models.ImageField(upload_to="savedImages/", blank=True)

    def __str__(self):
        return self.image_name
