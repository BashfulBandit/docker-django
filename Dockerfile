FROM python:3.7.0

# Not required, but nice to tell people who you are. ;)
LABEL maintainer "Davis Templeton <davistempleton3.com>"

# Set Python output to stdout instead of stderr(I think?)
ENV PYTHONBUFFERED 1

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

# Make django user own the directory.
COPY --chown=django:django ./website/ /website/

# Tell Docker to use django as the user for everything else.
USER django

# Set working directory to /website.
WORKDIR /website/

# Export port 8000 since that is the one gunicorn will use.
EXPOSE 8000

# Run docker-entrypoint.sh script.
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Probably need to define a command, but for now, it will be in the ENTRYPOINT.
CMD [ "gunicorn", "-b", "0.0.0.0:8000", "--access-logfile", "-", "--log-level", "debug", "--reload", "website.wsgi:application" ]
