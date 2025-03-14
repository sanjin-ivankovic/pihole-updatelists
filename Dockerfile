FROM pihole/pihole:2025.03.0

LABEL maintainer="Sanjin Ivankovic"
LABEL description="Pi-hole image combined with pihole-updatelists script"

WORKDIR /tmp/pihole-updatelists

COPY install.sh docker.sh pihole-updatelists.* ./

RUN apk add --no-cache \
        php \
        php-pdo_sqlite \
        php-curl \
        php-openssl \
        php-intl \
        php-pcntl \
        php-posix \
    && bash ./install.sh docker \
    && rm -rf /tmp/pihole-updatelists \
    && rm -rf /var/cache/apk/*
