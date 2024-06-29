from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.viewsets import ViewSet
from rest_framework.decorators import action
from .models import User, Images
from .serializers import LoginSerializer, ImageSerializer
from rest_framework.generics import ListAPIView
import jwt, datetime
from django.contrib.auth import authenticate
from django.conf import settings
from rest_framework.permissions import AllowAny
from rest_framework.authentication import TokenAuthentication


# class UserViewSet(ViewSet):
#     @action(detail=False, methods=['post'])
#     def authenticate(self, request):
#         serializer = LoginSerializer(data=request.data)
#         if serializer.is_valid():
#             username = serializer.validated_data['username']
#             password = serializer.validated_data['password']
#             try:
#                 user = User.objects.get(username=username, password=password)
#                 return Response({"message": "Login successful"}, status=status.HTTP_200_OK)
#             except User.DoesNotExist:
#                 return Response({"message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class RegisterView(ViewSet):
#     @action(detail=False, methods=['post'])
#     def register(self, request):
#         serializer = LoginSerializer(data=request.data)
#         if serializer.is_valid():
#             new_user = serializer.save()
#             if new_user:
#                 payload = {
#                     'id': new_user.id,
#                     'exp': datetime.datetime.utcnow() + datetime.timedelta(days=1),
#                     'iat': datetime.datetime.utcnow()
#                 }
#                 token = jwt.encode(payload, 'SECRET', algorithm='HS256')

#                 data = { "access_token": token }
#                 response = Response({"message": "User registered successfully", "data": data}, status=status.HTTP_201_CREATED)
#                 response.set_cookie(key='access_token_jwt', value=token, httponly=True)
#                 return response
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginView(ViewSet):
    @action(detail=False, methods=['post'])
    def login(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            try:
                user = User.objects.get(username=username, password=password)
                payload = {
                    'id': user.id,
                    'exp': datetime.datetime.utcnow() + datetime.timedelta(days=1),
                    'iat': datetime.datetime.utcnow()
                }
                token = jwt.encode(payload, 'SECRET', algorithm='HS256')
                response = Response({"message": "Login successful", "access_token": token}, status=status.HTTP_200_OK)
                # response.set_cookie(key='access_token_jwt', value=token, httponly=True)
                return response
            except User.DoesNotExist:
                return Response({"message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

class UserView(ViewSet): # access the details of user after login
    @action(detail=False, methods=['get'])
    def list(self, request): 
        # token = request.COOKIES.get('access_token_jwt')
        token = request.headers.get('Authorization')
        print('token python: ', token)
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id']) # only sending id and username
            return Response({"id": user.id, "username": user.username}, status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
        except jwt.InvalidTokenError:
            return Response({"message": "Invalid token"}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)


'''
::: Image Upload :::
'''

class ImagesList(ViewSet):
    @action(detail=False, methods=['post'])
    def uploadImage(self, request):
        serializer = ImageSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
       