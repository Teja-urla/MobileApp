from rest_framework import serializers
from .models import Images, User, UserProject
import hashlib

class LoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class UserProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProject
        fields = '__all__'

class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Images
        fields = '__all__'
