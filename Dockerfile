FROM        alpine:3.18.2

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-baseimage-alpine"

LABEL       maintainer="ksurl"

ENV         TZ="UTC"

RUN         echo "**** install build packages ****" && \
            apk add --no-cache --virtual=build-dependencies \
                curl \
                tar && \
            echo "**** install packages ****" && \
            apk add --no-cache \
                bash \
                s6-overlay \
                shadow \
                tzdata && \
            echo "**** create user ****" && \
            groupmod -g 1000 users && \
            useradd -u 911 -U -d /config -s /bin/false abc && \
            usermod -G users abc && \
            mkdir -p /config && \
            echo "**** disable root login ****" && \
            sed -i -e 's/^root::/root:!:/' /etc/shadow && \
            echo "**** cleanup ****" && \
            apk del --purge build-dependencies && \
            rm -rf /tmp/* /var/cache/apk/*

COPY        root/ /

ENTRYPOINT  [ "/init" ]
