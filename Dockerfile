FROM python:3.7.0

ENV PYTHONUNBUFFERED 1

ADD requirements.txt start-django.sh /

RUN apt-get update && \
    apt-get upgrade -y; \
    pip install -r requirements.txt; \
    rm -rf /var/lib/apt/lists/*;

WORKDIR /project/

COPY ./project/ /project/

EXPOSE 8000

CMD ["/start-django.sh"]
