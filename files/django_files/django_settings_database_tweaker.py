#!/usr/bin/python
import os
from .settings import DATABASES

settings_file_path = os.environ['project_settings_path'] + '/' + 'settings.py'
database = os.environ['database']
mysql_user = os.environ['mysql_user']
mysql_password = os.environ['mysql_password']

database_text = '''
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
'''

database_text_to_replace = 'DATABASES = %s' % str(DATABASES)

file_opener = open(settings_file_path).read()
file_replace = file_opener.replace(database_text, database_text_to_replace)
file_writer = open(settings_file_path, 'w')
file_writer.write(file_replace)
file_writer.close()
