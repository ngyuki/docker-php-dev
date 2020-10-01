FROM php:7.3.23-alpine

RUN apk add --no-cache --virtual .build-deps autoconf gcc g++ make &&\
    pecl install xdebug &&\
    pecl install ast &&\
    pecl install apcu &&\
    apk del .build-deps &&\
    rm -fr /tmp/*

ENV PHPIZE_DEPS $PHPIZE_DEPS libpng-dev libzip-dev zlib-dev
RUN apk add --no-cache libpng libzip zlib &&\
    docker-php-ext-install gd pcntl pdo_mysql sockets zip

RUN apk add --no-cache openssh rsync git mysql-client

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN set -eux ;\
    composer global config repositories.pharhub composer https://packages.pharhub.dev/ ;\
    for x in \
        phpunit      \
        php-cs-fixer \
        phan         \
        box          \
    ; do \
        composer global require pharhub/$x &&\
        cp -aL ~/.composer/vendor/bin/$x.phar /usr/bin/$x &&\
    :; done ;\
    rm -fr ~/.composer

RUN docker-php-ext-enable opcache ast apcu
