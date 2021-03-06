# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: python3
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        python:3.8-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN         mkdir -p /usr/share/man/man1 \
            && apt update \
            && apt -y install git ca-certificates dnsutils iproute2 wget curl xz-utils git openjdk-11-jre \
            zlib1g-dev libffi-dev git libmagickwand-dev unzip libaa1-dev build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev ffmpeg imagemagick ffmpeg  \
            libncurses5-dev libbz2-dev libpng-dev libffi-dev libssl-dev liblzma-dev tk-dev libfreetype6-dev libdb5.3-dev libsqlite3-dev libncursesw5-dev libmagickwand-dev git libgdbm-dev imagemagick zlib1g-dev build-essential unzip libexpat1-dev libjpeg-dev ffmpeg libreadline6-dev webp libaa1-dev \
            && pip install --upgrade pip \
            && pip install python-forecastio tweepy unidecode discord-text-sanitizer mcstatus bs4 sqlalchemy geocoder valve python-valve py-cpuinfo psutil \
            && useradd -m -d /home/container container \
            && mkdir -p /home/container/.config/Red-DiscordBot/ \
            && ln -s /home/container/.config/Red-DiscordBot/ /usr/local/share/Red-DiscordBot

RUN set -eux; \
# Install popular cog dependencies
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # NotSoBot
        libmagickwand-dev \
        libaa1-dev \
        # CrabRave
        ffmpeg \
        imagemagick \
        # RSS (SciPy has no wheels for armv7)
        $([ "$(uname --machine)" = "armv7l" ] && echo "gfortran libopenblas-dev liblapack-dev") \
        # ReTrigger
        tesseract-ocr \
    ; \
    # CrabRave needs this policy removed
    sed -i '/@\*/d' /etc/ImageMagick-6/policy.xml; 

USER        container
ENV         USER=container HOME=/home/container 
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
