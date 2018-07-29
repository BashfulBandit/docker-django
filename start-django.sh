#!/bin/bash

echo "Sleeping for 10s to make sure DB is up and running..."
sleep 10s

echo "Running makemigrations and migrate..."
python3 manage.py makemigrations
python3 manage.py migrate

echo "Starting DJANGO..."
python3 manage.py runserver 0.0.0.0:80
