FROM python:3.11.4-slim-bullseye

ENV PYTHONUNBUFFERED=1

# install system dependencies
RUN apt update \
  && apt install -y gettext wget curl \
  # cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV APPDIR='/srv'
ENV DJANGODIR='/srv/www'

WORKDIR $APPDIR

# install cloud-sql-proxy
# RUN curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.9.0/cloud-sql-proxy.linux.amd64
# RUN chmod +x cloud-sql-proxy

# install app dependencies
RUN pip3 install --upgrade pip
COPY src/requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

# setup server daemon
WORKDIR $DJANGODIR

EXPOSE 8000
CMD ["python", "manage.py", "runserver"]
