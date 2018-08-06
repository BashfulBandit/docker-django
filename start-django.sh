#!/bin/bash

echo "Sleeping for 10s to make sure DB is up and running..."
sleep 10s

echo "Running makemigrations and migrate..."
python3 manage.py makemigrations
python3 manage.py migrate

echo "Collecting static files into STATIC_ROOT..."
python3 manage.py collectstatic --noinput

echo "Starting DJANGO..."
gunicorn \
  -b 0.0.0.0:8000 \
  --access-logfile - \
  --log-level debug \
  website.wsgi:application
