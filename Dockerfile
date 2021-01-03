FROM        alpine:3.12

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-baseimage-alpine"

LABEL       maintainer="ksurl"

ENV         TZ="UTC"

RUN         echo "**** install build packages ****" && \
            apk add --no-cache --virtual=build-dependencies \
                curl \
                tar && \
            echo "**** install s6-overlay" && \
                curl -o /tmp/s6-overlay.tar.gz -fsSL https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz && \
                tar xzf /tmp/s6-overlay.tar.gz -C / && \
            echo "**** install packages ****" && \
            apk add --no-cache \
                bash \
                shadow \
                tzdata && \
            echo "**** create user ****" && \
            groupmod -g 1000 users && \
            useradd -u 911 -U -d /config -s /bin/false abc && \
            usermod -G users abc && \
            mkdir -p /config && \
            echo "**** cleanup ****" && \
            apk del --purge build-dependencies && \
            rm -rf /tmp/* /var/cache/apk/*

COPY        root/ /

ENTRYPOINT  [ "/init" ]
