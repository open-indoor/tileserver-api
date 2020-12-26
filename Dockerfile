FROM node:10-buster-slim

ENV NODE_ENV="production"
ENV CHOKIDAR_USEPOLLING=1
ENV CHOKIDAR_INTERVAL=500

RUN apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get -y install --no-install-recommends \
    apt-transport-https \
    bash \
    build-essential \
    ca-certificates \
    cron \
    curl \
    fcgiwrap \
    file \
    gettext \
    grep \
    jq \
    libcairo2-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    libllvm6.0 \
    libprotobuf-dev \
    libxxf86vm-dev \
    net-tools \
    procps \
    python \
    unzip \
    util-linux \
    uuid-runtime \
    vim \
    wget \
    xvfb \
    x11-utils \
  && apt-get clean

# Caddyserver install
RUN echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | tee -a /etc/apt/sources.list.d/caddy-fury.list
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y update \
    && apt-get -y install \
      --no-install-recommends \
      caddy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/

ARG tileserverTag=3.0.0
RUN mkdir -p /usr/src/
# ADD https://github.com/maptiler/tileserver-gl/archive/v${tileserverTag}.tar.gz /usr/src/tileserver-gl-v${tileserverTag}.tar.gz
COPY ./tileserver-gl-v${tileserverTag}.tar.gz /usr/src/
RUN cd /usr/src && tar xvfz tileserver-gl-v${tileserverTag}.tar.gz
RUN mv /usr/src/tileserver-gl-${tileserverTag} /usr/src/app

RUN cd /usr/src/app && npm install --production

RUN mkdir -p /data

# VOLUME /data
# WORKDIR /data

# setup
COPY ./Caddyfile /tmp/Caddyfile

RUN mkdir -p /tileserver
COPY ./tileserver.sh /tileserver/tileserver

COPY ./tileserver-api.sh /tileserver/tileserver-api.sh
RUN chmod +x /tileserver/tileserver-api.sh

COPY ./config.json /tileserver/config.json
COPY ./actions.sh /usr/bin/actions.sh
COPY ./tic.sh /usr/bin/tic

WORKDIR /tileserver

ENV API_DOMAIN_NAME api.openindoor.io

RUN sed -i "s/-p 80/-p 8080/g" /usr/src/app/run.sh

CMD ["/tileserver/tileserver-api.sh"]
