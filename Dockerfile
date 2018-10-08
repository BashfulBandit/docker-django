FROM python:3.7.0

# Not required, but nice to tell people who you are. ;)
LABEL maintainer "Davis Templeton <davistempleton3.com>"

# Set Python output to stdout instead of stderr(I think?)
ENV PYTHONBUFFERED 1
ENV DJANGO_PROJECT website

# Add requirements.txt and docker-entrypoint.sh to /(root).
ADD requirements.txt docker-entrypoint.sh /

# Update apt-get packages, install some packages, and setup some configurations.
RUN apt-get update && \
    apt-get upgrade -y; \
    pip install -r requirements.txt; \
    rm -rf /var/lib/apt/lists/*; \
    ln -s -f /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata; \
    useradd --home-dir /home/django \
    	--shell /bin/bash \
    	--create-home \
    	django

# Tell Docker to use django as the user for everything else.
USER django

# Create the Django Project using my Django Project template.
# https://github.com/BashfulBandit/django-project-template
RUN cd /home/django && \
	django-admin startproject \
		--template https://github.com/BashfulBandit/django-project-template/archive/master.zip \
		$DJANGO_PROJECT

# Set the working directory.
WORKDIR /home/django/$DJANGO_PROJECT

# Export port 8000 since that is the one gunicorn will use.
EXPOSE 8000

# Run docker-entrypoint.sh script.
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD gunicorn -b 0.0.0.0:8000 --access-logfile - --log-level debug --reload $DJANGO_PROJECT.wsgi:application
