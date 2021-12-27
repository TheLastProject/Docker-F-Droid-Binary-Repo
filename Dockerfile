FROM debian:latest

EXPOSE 80

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  androguard \
  apksigner \
  fastjar \
  jarwrapper \
  openjdk-11-jdk \
  python3-defusedxml \
  python3-git \
  python3-paramiko \
  python3-pyasn1-modules \
  python3-qrcode \
  python3-requests \
  python3-ruamel.yaml \
  python3-yaml \
  nginx \
  && rm -rf /var/lib/apt/lists/*
RUN rm /etc/nginx/sites-enabled/default

WORKDIR /app
RUN git clone https://gitlab.com/fdroid/fdroidserver.git

COPY . /

CMD ["/entrypoint.sh"]
