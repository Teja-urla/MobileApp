from rest_framework import serializers
from .models import Images, UserProject, ProjectImages, YOLOModel
from django.contrib.auth.models import User

class UserProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProject
        fields = '__all__'

class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Images
        fields = '__all__'

class ProjectImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProjectImages
        fields = '__all__'

class YOLOModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = YOLOModel
        fields = '__all__'