from django.shortcuts import render
from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authtoken.models import Token



# Create your views here.


# views.py

class LoginView(APIView):
    def post(self, request, format=None):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(username=username, password=password)
        if user is not None:
            token, _ = Token.objects.get_or_create(user=user)
            print(token.key, user.username)
            return Response({
                'token': token.key,
                'username': user.username
                })
        return Response({'error': 'Invalid Credentials'}, status=400)
