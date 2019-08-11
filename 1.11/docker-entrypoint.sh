#!/usr/bin/env bash

# This script will wait for the http/tcp connect to the HOST:PORT for 60s. Once
# the connection is good, the script will exit and allow this script to continue.
# If the 60s runs out before the connection then it will fail with exit 1.
if [ "${MYSQL_HOST}" != "" ] && [ "${MYSQL_PORT}" != "" ]; then
	wait-for-it.sh ${MYSQL_HOST}:${MYSQL_PORT} \
		--timeout=60
fi

# Check to make sure the DB was actually connected because the following commands depend on it.
if [ "$?" == "0" ]; then
	# Make migrations and migrate with the connected DB.
	python manage.py makemigrations
	python manage.py migrate
fi

# echo "Collecting static files into STATIC_ROOT..."
# python3 manage.py collectstatic --noinput

exec "$@"
