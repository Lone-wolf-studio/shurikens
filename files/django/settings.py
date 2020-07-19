import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.environ['project_name'],
        'USER': 'root',
        'PASSWORD': 'root',
    }
}