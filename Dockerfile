ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG PHPUNIT_PHAR=phpunit.phar

RUN apk add --no-cache --virtual build.deps autoconf gcc g++ make &&\
    pecl install xdebug &&\
    pecl install ast &&\
    pecl install apcu &&\
    rm -fr /tmp/* &&\
    apk del build.deps

RUN apk add --no-cache libpng libzip zlib &&\
    apk add --no-cache --virtual build.deps libpng-dev libzip-dev zlib-dev &&\
    docker-php-ext-install gd pcntl pdo_mysql sockets zip &&\
    apk del build.deps

RUN apk add --no-cache openssh rsync git mysql-client

ADD https://getcomposer.org/composer.phar /usr/local/bin/composer
ADD https://phar.phpunit.de/${PHPUNIT_PHAR} /usr/local/bin/phpunit
ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer
ADD https://github.com/phan/phan/releases/download/1.2.7/phan.phar /usr/local/bin/phan

RUN curl -LSs https://box-project.github.io/box2/installer.php | php &&\
  mv box.phar /usr/local/bin/box &&\
  chmod +x /usr/local/bin/box

RUN chmod +x /usr/local/bin/composer &&\
    chmod +x /usr/local/bin/phpunit &&\
    chmod +x /usr/local/bin/php-cs-fixer &&\
    chmod +x /usr/local/bin/phan

RUN docker-php-ext-enable opcache ast apcu

ENV COMPOSER_ALLOW_SUPERUSER=1
