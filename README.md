# ngyuki/php-dev

PHP のアプリ開発用の Docker イメージ。

- [ngyuki/php-dev - Docker Hub](https://hub.docker.com/r/ngyuki/php-dev/ "ngyuki/php-dev - Docker Hub")

公式の php:alpine のイメージに次を追加しています。

- PHP Extension
    - xdebug
        - デフォで無効なので `docker-php-ext-enable xdebug` で有効化
    - pdo_mysql
        - デフォで有効
    - opcache
        - デフォで有効
- Command
    - git
    - mysql
    - phpunit
    - composer

## Build and Push

```sh
docker build . --build-arg BASE=php:7.1-alpine -t ngyuki/php-dev:7.1-alpine -t ngyuki/php-dev:latest
docker push ngyuki/php-dev:7.1-alpine
docker push ngyuki/php-dev:latest

docker build . --build-arg BASE=php:7.0-alpine -t ngyuki/php-dev:7.0-alpine
docker push ngyuki/php-dev:7.0-alpine
```

## Example

```sh
# Run script
docker run --rm -v "$PWD":/app ngyuki/php-dev php /app/src/script.php

# Run built-in web server
docker run --rm -v "$PWD":/app -p 9876:9876 ngyuki/php-dev php -S 0.0.0.0:9876 -t /app/public/
```
