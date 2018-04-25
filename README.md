# ngyuki/php-dev

PHP のアプリ開発用の Docker イメージ。

- [ngyuki/php-dev - Docker Hub](https://hub.docker.com/r/ngyuki/php-dev/ "ngyuki/php-dev - Docker Hub")

公式の php:alpine のイメージに次を追加しています。

- PHP Extension
    - xdebug
    - pdo_mysql
    - gd
    - zip
    - opcache
- Command
    - ssh
    - rsync
    - git
    - mysql
    - composer
    - phpunit
    - phan

PHP 拡張の xdebug はデフォで無効なので `docker-php-ext-enable xdebug` で有効化する必要があります。
その他の PHP 拡張はすべてデフォで有効です。

## Build and Push

```sh
docker build . --build-arg BASE=php:7.1-alpine -t ngyuki/php-dev:7.1-alpine -t ngyuki/php-dev:latest
docker build . --build-arg BASE=php:7.0-alpine -t ngyuki/php-dev:7.0-alpine

docker push ngyuki/php-dev:latest
docker push ngyuki/php-dev:7.1-alpine
docker push ngyuki/php-dev:7.0-alpine
```

## Example

```sh
docker run --rm ngyuki/php-dev:7.0-alpine php -v
docker run --rm -v "$PWD":/app ngyuki/php-dev:7.0-alpine php -d zend_extension=xdebug.so /app/check.php

# Run built-in web server
docker run --rm -v "$PWD":/app -p 9876:9876 ngyuki/php-dev php -S 0.0.0.0:9876 -t /app/public/
```



