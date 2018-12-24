FROM alpine:3.8
LABEL maintainer="alexandre.degurse@gmail.com"

ARG PROSODY_VERSION=0.10.3

USER root

RUN mkdir -pv /etc/prosody /var/opt/prosody &&\
    adduser -DHs /sbin/nologin prosody &&\
    chown -R prosody:prosody /etc/prosody /var/opt/prosody

# install runtime deps
RUN apk add --update --no-cache make lua5.2 lua5.2-dev lua5.2-socket lua5.2-filesystem lua5.2-sec lua5.2-expat openssl libidn

# download sources
ADD --chown=prosody:prosody\
    https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz\
    /opt/prosody-${PROSODY_VERSION}.tar.gz

# extract sources
RUN apk add tar gzip &&\
    tar -xf /opt/prosody-${PROSODY_VERSION}.tar.gz -C /opt &&\
    rm /opt/prosody-${PROSODY_VERSION}.tar.gz &&\
    mv /opt/prosody-${PROSODY_VERSION} /opt/prosody

# replace musl-dev malloc.h because its missing some declaration
# needed for the build
ADD malloc.h /opt

# install build deps & build & remove build deps
RUN apk add --no-cache build-base linux-headers openssl-dev libidn-dev lua5.2-dev && mv /opt/malloc.h /usr/include &&\
    cd /opt/prosody/ && ./configure && make &&\
    apk del build-base linux-headers openssl-dev libidn-dev lua5.2-dev

RUN touch /var/run/prosody.pid && chown prosody:prosody /var/run/prosody.pid

EXPOSE 5222 5269
CMD ["/opt/prosody/prosodyctl", "start"]
