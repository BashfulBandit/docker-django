#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM python:3.7.4-buster

LABEL maintainer "Davis Templeton <davistempleton3@gmail.com>"

COPY requirements.txt /

RUN pip install \
		--requirement requirements.txt \
		--upgrade; \
	cd /var/local/ && \
	django-admin startproject \
		--template https://github.com/BashfulBandit/django-project-template/archive/v2.2.zip \
		website;

WORKDIR /var/local/website/

EXPOSE 8000

COPY docker-entrypoint.sh wait-for-it.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "gunicorn", "--config", "config.py", "website.wsgi:application" ]
