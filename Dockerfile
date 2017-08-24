ARG BASE=php:alpine
FROM ${BASE}

RUN apk --no-cache add autoconf gcc g++ make &&\
    pecl install xdebug &&\
    docker-php-ext-enable xdebug

RUN docker-php-ext-install pdo_mysql

ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

RUN chmod +x /usr/local/bin/phpunit && phpunit --version &&\
    chmod +x /usr/local/bin/composer && composer --version
