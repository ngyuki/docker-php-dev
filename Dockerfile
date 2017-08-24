ARG BASE=php:alpine
FROM ${BASE}

RUN apk --no-cache add autoconf gcc g++ make &&\
    pecl install xdebug

RUN docker-php-ext-install pdo_mysql

RUN apk --no-cache add git mysql-client

RUN docker-php-ext-enable opcache
#RUN docker-php-ext-enable xdebug

ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

RUN chmod +x /usr/local/bin/phpunit && phpunit --version &&\
    chmod +x /usr/local/bin/composer && composer --version
