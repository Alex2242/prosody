# Simple docker container for prosody

This docker container is built over alpine and uses the
[official](https://prosody.im) prosody binaries.

## Usage

The simplest way to run the container is:

```bash
$ docker run -d  alex2242/prosody:latest
```

### Docker compose

Using docker-compose is recommended, here is a sample configuration:

```yaml
version: '3.6'

services:
  prosody:
    image: alex2242/prosody:latest
    container_name: prosody
    volumes:
      - /local/path/data:/var/lib/prosody
      - /local/path/prosody.cfg.lua:/etc/prosody/prosody.cfg.lua:ro
      # define certs location, in the container, in prosody.cfg.lua
      - /local/path/fullchain.pem:/container/path/fullchain.pem:ro
      - /local/path/privkey.pem:/container/path/privkey.pem:ro
    ports:
      - "5222:5222"
      - "5269:5269"
      - "6667:6667"
      - "6697:6697"
```

## Mainline image

This image uses Debian buster as base, prosody is install with apt.
It is the default image for prosody, it is tagged `latest`.

## Alpine image

This image uses alpine as base, prosody is built from the
[official](https://prosody.im) sources and tagged `alpine`.
