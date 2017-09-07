ARG BASE=php:alpine
FROM ${BASE}

RUN apk --no-cache add autoconf gcc g++ make &&\
    pecl install xdebug &&\
    rm -fr /tmp/pear

RUN docker-php-source extract &&\
    mkdir -p /usr/src/php/ext/ast &&\
    curl -fsSL https://github.com/nikic/php-ast/archive/v0.1.5.tar.gz |\
      tar xzf - --strip-components=1 -C /usr/src/php/ext/ast &&\
    docker-php-ext-install ast &&\
    docker-php-source delete

RUN docker-php-ext-install pdo_mysql pcntl

RUN apk --no-cache add zlib-dev &&\
    docker-php-ext-install zip

RUN apk --no-cache add git mysql-client

RUN docker-php-ext-enable opcache

ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

RUN chmod +x /usr/local/bin/phpunit && phpunit --version &&\
    chmod +x /usr/local/bin/composer && composer --version

RUN composer create-project etsy/phan /tmp/phan --prefer-dist --no-dev &&\
    cd /tmp/phan &&\
    mkdir -p build &&\
    php -d phar.readonly=0 package.php &&\
    install -m755 build/phan.phar /usr/local/bin/phan &&\
    rm -fr /tmp/phan
