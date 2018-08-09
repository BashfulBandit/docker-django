FROM python:3.7.0

ENV PYTHONUNBUFFERED 1

ADD requirements.txt start-django.sh /

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

USER webdev

WORKDIR /website/

COPY --chown=webdev:webster ./website/ /website/

EXPOSE 8000

CMD ["/start-django.sh"]
