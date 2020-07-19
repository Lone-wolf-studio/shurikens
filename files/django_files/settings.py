import os

engine = 'django.db.backends.%s' % (os.environ['database'])
database_name = os.environ['project_name']
database_user = os.environ['mysql_user']
database_password = os.environ['mysql_password']

DATABASES = {
    'default': {
        'ENGINE': engine,
        'NAME': database_name,
        'USER': database_user,
        'PASSWORD': database_password,
    }
}