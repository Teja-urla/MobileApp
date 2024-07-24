from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ViewSet
from rest_framework.decorators import action
from .models import Images, UserProject, ProjectImages
from .serializers import ImageSerializer, UserProjectSerializer, ProjectImageSerializer
import jwt, datetime
from rest_framework.authentication import TokenAuthentication
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from urllib.parse import quote

'''
::: User Authentication :::
'''

class LoginView(ViewSet):
    @action(detail=False, methods=['post'])
    def login(self, request):
        username = request.data['username']
        password = request.data['password']
        '''
           OWASP Top 10 - 2017 Output Encoding
        '''
        # perform output encoding
        username = quote(username)
        password = quote(password)
        # print(username, password)
        user = authenticate(username=username, password=password) # authenticate the user of the given username and password in the table of users in the database
        if user is not None:
            payload = {
                'id': user.id,
                'exp': datetime.datetime.utcnow() + datetime.timedelta(days=1)
            }
            token = jwt.encode(payload, 'SECRET', algorithm='HS256')
            print(token)
            return Response({"access_token": token}, status=status.HTTP_200_OK)
        return Response({"message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

# access the details of user after login
class UserView(ViewSet):
    @action(detail=False, methods=['get'])
    def userDetails(self, request):
        token = request.headers.get('Token')
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id'])
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
            # get all the projects where user_id = user.id
            projects = UserProject.objects.filter(user_id=user.id) # get all the projects where user_id = user.id
            serializer = UserProjectSerializer(projects, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
    
    @action(detail=False, methods=['post'])
    def addProject(self, request):
        token = request.headers.get('Token')
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id'])
            request.data['user_id'] = user.id # set the user_id of the project to the id of the user who created the project using the token

            '''
                OWASP Top 10 - 2017 Output Encoding
            '''
            # perform output encoding on x
            request.data['project_name'] = quote(request.data['project_name']) # quote function is used to perform output encoding
            request.data['project_description'] = quote(request.data['project_description'])

            serializer = UserProjectSerializer(data=request.data)

            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
    
    @action(detail=False, methods=['delete'])
    def deleteProject(self, request):
        token = request.headers.get('Token')
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id']) # get the user by id of the user

            project = UserProject.objects.get(id=request.data['id']) # get the project by id of the project
            '''
                ** IMPORTANT **
            '''
            if project.user_id.id == user.id: # project.user_id.id is the id of the user who created the project, which is foreign key    
                project.delete()
                return Response({"message": "Project deleted"}, status=status.HTTP_200_OK)
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
        except UserProject.DoesNotExist:
            return Response({"message": "Project not found"}, status=status.HTTP_404_NOT_FOUND)
        except jwt.InvalidTokenError:
            return Response({"message": "Invalid token"}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)
    
    @action(detail=False, methods=['put'])
    def editProject(self, request):
        token = request.headers.get('Token')
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id']) # get the user by id of the user
            # print(user.id, "user id")
            project = UserProject.objects.get(id=request.data['id']) # get the project by id of the project
            request.data['user_id'] = user.id
            '''
                OWASP Top 10 - 2017 Output Encoding
            '''
            # perform output encoding on request.data
            request.data['project_name'] = quote(request.data['project_name'])
            request.data['project_description'] = quote(request.data['project_description'])
            
            '''
                ** IMPORTANT **
            '''
            if project.user_id.id == user.id: # project.user_id.id is the id of the user who created the project, which is foreign key    
                project.project_name = request.data['project_name']
                project.project_description = request.data['project_description']
                project.save()
                return Response({"message": "Project updated"}, status=status.HTTP_200_OK)
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
        except UserProject.DoesNotExist:
            return Response({"message": "Project not found"}, status=status.HTTP_404_NOT_FOUND)
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


'''
::: Project Images :::
'''

class ProjectImageList(ViewSet):
    @action(detail=False, methods=['post'])
    def projectImagesList(self, request):
        token = request.headers.get('Token')
        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            projectID = request.data['project_id']
            # print(projectID, "project id")
            project_images = ProjectImages.objects.filter(project_id=projectID)

            # project_images = ProjectImages.objects.filter(project_id=14)


            serializer = ProjectImageSerializer(project_images, many=True)
            # print(serializer.data)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
        except jwt.InvalidTokenError:
            return Response({"message": "Invalid token"}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)
        except ProjectImages.DoesNotExist:
            return Response({"message": "Project not found"}, status=status.HTTP_404_NOT_FOUND)

class ProjectImageUpload(ViewSet):
    @action(detail=False, methods=['post'])
    def projectImageUpload(self, request):

        token = request.headers.get('Token')
        print(token)
        # token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZXhwIjoxNzIxODk5ODcyfQ.FiJAFwxE8yJT0jpCkQ6l9_m_KZS8Pl0w7SKe5-LEHXQ'

        if not token:
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            payload = jwt.decode(token, 'SECRET', algorithms=['HS256'])
            user = User.objects.get(id=payload['id'])
            request.data['user_id'] = user.id
            project_id = request.data['project_id']
            # convert project_id to integer
            project_id = int(project_id)
            request.data['project_id'] = project_id
            print('*******')
            print(request.data)
            print('*******')
            serializer = ProjectImageSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except jwt.ExpiredSignatureError:
            return Response({"message": "Token expired"}, status=status.HTTP_401_UNAUTHORIZED)
        except jwt.InvalidTokenError:
            return Response({"message": "Invalid token"}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)
        except ProjectImages.DoesNotExist:
            return Response({"message": "Project not found"}, status=status.HTTP_404_NOT_FOUND)
