FROM debian:latest

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.authors="Tobias Hargesheimer <docker@ison.ws>" \
    org.opencontainers.image.title="MPD" \
    org.opencontainers.image.description="MPD - Music Player Daemon" \
    org.opencontainers.image.licenses="GPL-2.0" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.url="https://hub.docker.com/r/tobi312/rpi-mpd" \
    org.opencontainers.image.source="https://github.com/Tob1as/docker-mpd"

COPY mpd.conf /etc/mpd.conf.new

RUN set -eux ; \
    apt-get update ; \
    apt-get install -y --no-install-recommends \
        mpd \
        mpc \
    ; \
    rm -rf /var/lib/apt/lists/* ; \
    mkdir /var/lib/mpd/data ; \
    touch /var/lib/mpd/data/database \
        /var/lib/mpd/data/state \
        /var/lib/mpd/data/sticker.sql \
    ; \
    chown -R mpd:audio /var/lib/mpd ; \
    cp /etc/mpd.conf /etc/mpd.conf.backup ; \
    mv /etc/mpd.conf.new /etc/mpd.conf ; \
    chown -R mpd:audio /etc/mpd.con* ; \
    mkdir -p /run/mpd/ ; \
    chown -R mpd:audio /run/mpd/

COPY mpd.conf /etc/mpd.conf

VOLUME /var/lib/mpd
WORKDIR /var/lib/mpd
EXPOSE 6600 8000

CMD ["/usr/bin/mpd", "--no-daemon", "--stdout", "/etc/mpd.conf"]