#!/usr/bin/env bash

echo "Sleeping for 10s to make sure DB is up and running..."
sleep 10s

echo "Running makemigrations and migrate..."
python3 manage.py makemigrations
python3 manage.py migrate

echo "Collecting static files into STATIC_ROOT..."
python3 manage.py collectstatic --noinput

echo "Running any commands passed to this script from CMD or command..."
exec "$@"
