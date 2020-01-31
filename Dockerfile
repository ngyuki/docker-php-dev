ARG BASE_IMAGE
FROM ${BASE_IMAGE}

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

ARG PHPUNIT_PHAR=phpunit.phar
ADD https://phar.phpunit.de/${PHPUNIT_PHAR} /usr/local/bin/phpunit

ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer

ARG PHAN_VERSION
ADD https://github.com/phan/phan/releases/download/${PHAN_VERSION}/phan.phar /usr/local/bin/phan

RUN curl -fsSL "https://box-project.github.io/box2/installer.php" | php &&\
  mv box.phar /usr/local/bin/box &&\
  chmod +x /usr/local/bin/box

RUN chmod +x \
      /usr/local/bin/phpunit \
      /usr/local/bin/php-cs-fixer \
      /usr/local/bin/phan

RUN docker-php-ext-enable opcache ast apcu

ENV COMPOSER_ALLOW_SUPERUSER=1

ADD check.php /usr/local/bin/docker-php-check.php
