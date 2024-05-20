# Alpine Linux Docker Baseimage
#   by selidron

# Grab Alpine:Latest
FROM alpine:latest

# Define ARGS
ARG uid=1000 \
    gid=1000 \
    tz="America/New_York" \
    umask=000 \
    clamav=FALSE

# Set Env
ENV uid=1000 \
    gid=1000 \
    tz="America/New_York" \
    umask=000

# Install base packages
RUN apk add --no-cache \
    bash \
    nano \
    shadow \
    font-dejavu \
    python3 \
    py3-pip \
    busybox-binsh \
    libcrypto3

# Install ClamAV
RUN if [[ ${clamav} ]] ; then apk add --no-cache clamav ; fi

# Install VNC packages
# TODO: Implement a VNC service

# Update virus database
RUN chmod 777 /var/lib/clamav && freshclam

# Copy root to system root
COPY root /

# Volumes
RUN mkdir -p /config && chmod 777 /config
VOLUME /config

# Create app user
RUN adduser -HD -h /config -u ${uid} app && chown app:app -R /config

# Set entry point (script to run at container start)
ENTRYPOINT [ "/init" ]