ARG BASE
FROM ${BASE}

ARG PHPUNIT

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

ADD https://getcomposer.org/composer.phar /usr/local/bin/composer
ADD https://phar.phpunit.de/${PHPUNIT} /usr/local/bin/phpunit
ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer
ADD https://github.com/phan/phan/releases/download/0.12.15/phan.phar /usr/local/bin/phan

RUN curl -LSs https://box-project.github.io/box2/installer.php | php &&\
  mv box.phar /usr/local/bin/box &&\
  chmod +x /usr/local/bin/box

RUN chmod +x /usr/local/bin/composer &&\
    chmod +x /usr/local/bin/phpunit &&\
    chmod +x /usr/local/bin/php-cs-fixer &&\
    chmod +x /usr/local/bin/phan

RUN docker-php-ext-enable opcache ast apcu

ENV COMPOSER_ALLOW_SUPERUSER=1
