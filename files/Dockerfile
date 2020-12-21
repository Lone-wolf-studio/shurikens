FROM python:3.7-slim-buster

WORKDIR /app

# environment variables for output and avoiding .pyc files
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements.txt /requirements.txt

# Installing python dependencies
RUN pip3 install -r /requirements.txt

COPY . /app

EXPOSE 5000

ENTRYPOINT python api.py --host=0.0.0.0