from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ViewSet
from rest_framework.decorators import action
from .models import User, Images, UserProject
from .serializers import LoginSerializer, ImageSerializer, UserProjectSerializer
import jwt, datetime
from rest_framework.authentication import TokenAuthentication
'''
::: User Authentication :::
'''
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
                return response
            except User.DoesNotExist:
                return Response({"message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

class UserView(ViewSet): # access the details of user after login
    @action(detail=False, methods=['get'])
    def list(self, request): 
        token = request.headers.get('Token')
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
::: User Projects :::
'''

class UserProjectList(ViewSet):
    @action(detail=False, methods=['get'])
    def projectList(self, request):
        token = request.headers.get('Token')
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id'])
            print(user.id)
            # get all the projects where userID = user.id
            projects = UserProject.objects.filter(userID=user.id) # get all the projects where userID = user.id
            serializer = UserProjectSerializer(projects, many=True)
            print(projects)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)

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
       