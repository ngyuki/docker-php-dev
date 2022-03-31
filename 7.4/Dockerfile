FROM php:7.4.28-alpine

RUN apk add --no-cache --virtual .build-deps autoconf gcc g++ make &&\
    pecl install xdebug &&\
    pecl install ast &&\
    pecl install apcu &&\
    apk del .build-deps &&\
    rm -fr /tmp/*

ENV PHPIZE_DEPS $PHPIZE_DEPS libpng-dev libzip-dev zlib-dev
RUN apk add --no-cache libpng libzip zlib &&\
    docker-php-ext-install gd pcntl pdo_mysql sockets zip

RUN apk add --no-cache bash openssh rsync git mysql-client unzip jq

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN set -eux ;\
    for x in \
        "phpunit/phpunit           https://phar.phpunit.de/phpunit-%s.phar" \
        "phan/phan                 https://github.com/phan/phan/releases/download/%s/phan.phar" \
        "friendsofphp/php-cs-fixer https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/%s/php-cs-fixer.phar" \
    ; do \
        cd /tmp &&\
        set -- $x &&\
        composer require --no-install "$1" &&\
        version=$(jq '.packages[] | select(.name == $name) | .version' -r --arg name "$1" < composer.lock) &&\
        url=$(printf "$2" "$version") &&\
        file=${1#*/} &&\
        curl -fsSL "$url" > "/usr/bin/$file" &&\
        chmod +x "/usr/bin/$file" &&\
        rm -fr ~/.composer &&\
        rm -f composer.* &&\
    :; done

RUN docker-php-ext-enable opcache ast apcu

COPY files/ /
