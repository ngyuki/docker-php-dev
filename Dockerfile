ARG BASE=php:7.0.10-alpine
FROM ${BASE}

RUN apk add --no-cache --virtual build.deps autoconf gcc g++ make &&\
    cd /tmp && pecl download xdebug &&\
      tar xzf xdebug-*.tgz && cd xdebug-* && phpize && ./configure && make install &&\
    cd /tmp && curl -fsSL https://github.com/nikic/php-ast/archive/v0.1.6.tar.gz -o php-ast-0.1.6.tgz &&\
      tar xzf php-ast-*.tgz && cd php-ast-* && phpize && ./configure && make install &&\
    cd /tmp && pecl download apcu &&\
      tar xzf apcu-*.tgz && cd apcu-* && phpize && ./configure && make install &&\
    cd /tmp && rm -fr /tmp/* &&\
    apk del build.deps

RUN apk add --no-cache libpng zlib &&\
    apk add --no-cache --virtual build.deps libpng-dev zlib-dev &&\
    docker-php-ext-install gd pdo_mysql pcntl zip &&\
    apk del build.deps

RUN apk add --no-cache openssh rsync git mysql-client

ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer
ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer

RUN chmod +x /usr/local/bin/phpunit &&\
    chmod +x /usr/local/bin/composer &&\
    chmod +x /usr/local/bin/php-cs-fixer

RUN docker-php-ext-enable opcache

RUN php -d extension=ast.so /usr/local/bin/composer create-project etsy/phan /tmp/phan --prefer-dist --no-dev &&\
    cd /tmp/phan &&\
    mkdir -p build &&\
    php -d phar.readonly=0 package.php &&\
    install -m755 build/phan.phar /usr/local/bin/phan &&\
    rm -fr /tmp/phan
