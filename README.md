# ngyuki/php-dev

PHP のアプリ開発用の Docker イメージ。

## Example

```sh
# Run script
docker run --rm -v "$PWD":/app ngyuki/php-dev php /app/script.php

# Run built-in web server
docker run --rm -v "$PWD":/app -p 9876:9876 ngyuki/php-dev php -S 0.0.0.0:9876 -t /app/public/
```

## Build and Push

```sh
docker build . --build-arg BASE=php:7.1-alpine --tag ngyuki/php-dev:7.1-alpine
docker push ngyuki/php-dev:7.1-alpine

docker build . --build-arg BASE=php:7.0-alpine --tag ngyuki/php-dev:7.0-alpine
docker push ngyuki/php-dev:7.0-alpine
```
