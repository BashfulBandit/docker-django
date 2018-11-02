# docker-django

Docker image for a Django website using Gunicorn.

# What is Django?

Django is a high-level Python Web framework that encourages rapid development and clean,
pragmatic design. Built by experienced developers, it takes care of much of the hassle of
Web development, so you can focus on writing your app without needing to reinvent the wheel.
It’s free and open source.

> <a href="https://en.wikipedia.org/wiki/Django_(web_framework)">Django Wikipedia</a>

# How to use this image

## Hosting the default Django project

```console
$ docker run --name some-django -d dtempleton/django
```

## Exposing external port

```console
$ docker run --name some-django -d -p 8080:8000 dtempleton/django
```

Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your browser.

## Building a Django website

This image has the base Django project created by running
```console
django-admin startproject \
	--template https://github.com/BashfulBandit/django-project-template/archive/master.zip \
	website
```
with a few added configuration in the settings.py based on some environment variables.
See the list of Environment Variables below. Since it has a specific settings.py
file, it is recommended to use `docker cp some-django:/website .` to retrieve
the Django files from the image to develop with by mounting a host directory
to your Docker container.

Once you have a copy of the Docker container /website directory on your host, you
can begin using the image with more complex configuration, but the basic would:

```console
$ docker run --name some-django -v /path/to/host/website:/home/django/website -p 8080:8000 dtempleton/django
```

## Configuring Gunicorn

The default Docker image starts using the command `gunicorn --config config.py website.wsgi:application`.
This means if you mount your own config.py file at `/home/django/website/config.py` you can
apply your own gunicorn configuration.

# Environment Variables

When you start the dtempleton/django image, you can adjust the configuration
of Django by passing one or more environment variable to `docker run`

## `DEBUG`

This environment variable is used to set the Django DEBUG variable. It has a
default value of `True`.

https://docs.djangoproject.com/en/2.1/ref/settings/#std:setting-DEBUG

## `HOST`

This environment variable is used to set the Django ALLOWED_HOSTS array. It has
a default value of `*`.

https://docs.djangoproject.com/en/2.1/ref/settings/#allowed-hosts

## `SECRET_KEY`

This environment variable is used to set the Django SECRET_KEY variable. It has a
default value, but it shouldn't be used in a production environment. See below for
more information.

https://docs.djangoproject.com/en/2.1/ref/settings/#std:setting-SECRET_KEY

NOTE: It is not recommended to leave the Django SECRET_KEY variable to the one included
in the Docker image. Specially in a production environment. I use [django-secret-key](https://github.com/ariestiyansyah/django-secret-key) to
generate a new SECRET_KEY.

## `SQL_ENGINE`

This environment variable is used to set the Django ENGINE variable for the default
Database in the DATABASES array. It has a default value of `django.db.backends.sqlite3`.

https://docs.djangoproject.com/en/2.1/ref/settings/#databases

## `MYSQL_DATABASE`

This environment variable is used to set the Django NAME variable for the default
Database in the DATABASES array. It has a default value of `db.sqlite3`.

https://docs.djangoproject.com/en/2.1/ref/settings/#databases

## `MYSQL_USER`

This environment variable is used to set the Django USER variable for the default
Database in the DATABASES array. It has a default value of `django`.

https://docs.djangoproject.com/en/2.1/ref/settings/#databases

## `MYSQL_PASSWORD`

This environment variable is used to set the Django PASSWORD variable for the
default Database in the DATABASES array. It has a default value of `password`,
but it shouldn't be used in a production environment.

https://docs.djangoproject.com/en/2.1/ref/settings/#databases

## `MYSQL_HOST`

This environment variable is used to set the Django HOST variable for the default
Database in the DATABASES array. It has a default value of `localhost`.

https://docs.djangoproject.com/en/2.1/ref/settings/#databases

## `MYSQL_PORT`
This environment variable is used to set the Django PORT variable for the default
Database in the DATABASES array. It has a default value of `3306`.

https://docs.djangoproject.com/en/2.1/ref/settings/#databases
