FROM debian:buster-slim
LABEL maintainer="alexandre.degurse@gmail.com"

USER root

RUN apt update && apt upgrade -y &&\
    apt install -y prosody ca-certificates lua-dbi-sqlite3 lua-zlib &&\
    apt-get clean && rm -Rf /var/lib/{dpkg,apt}

EXPOSE 5222 5269

RUN touch /var/run/prosody.pid && chown prosody:prosody /var/run/prosody.pid

CMD ["/usr/bin/prosodyctl", "start"]
