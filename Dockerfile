FROM alpine:3.8
LABEL maintainer="alexandre.degurse@gmail.com"

ARG PROSODY_VERSION=0.10.3

RUN mkdir -pv /etc/prosody /var/opt/prosody /opt/prosody &&\
    adduser -DHs /sbin/nologin prosody &&\
    touch /var/run/prosody.pid

# download & extract sources
RUN apk add --no-cache tar gzip curl &&\
    curl -L https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz |\
      gzip -d - | tar --strip-components=1 -x -C /opt/prosody &&\
    apk del tar gzip curl &&\
    chown -R prosody:prosody /opt/prosody /etc/prosody /var/run/prosody.pid

# install runtime deps
RUN apk add --update --no-cache lua5.2 lua5.2-dev lua5.2-socket lua5.2-filesystem lua5.2-sec lua5.2-expat openssl libidn

# replace musl-dev malloc.h because its missing some declaration (mallinfo) needed for the build
COPY malloc.h /opt

# install deps & build & remove build deps
RUN apk add --no-cache build-base linux-headers openssl-dev libidn-dev lua5.2-dev &&\
    mv /opt/malloc.h /usr/include &&\
    cd /opt/prosody/ && su -s /bin/sh prosody -c './configure && make && make clean' &&\
    apk del build-base linux-headers openssl-dev libidn-dev lua5.2-dev

USER prosody

EXPOSE 5222 5269
CMD ["/opt/prosody/prosodyctl", "start"]
