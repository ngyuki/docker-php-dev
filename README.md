# ngyuki/php-dev

PHP のアプリ開発用の Docker イメージ。

- [ngyuki/php-dev - Docker Hub](https://hub.docker.com/r/ngyuki/php-dev/ "ngyuki/php-dev - Docker Hub")

公式の php:alpine のイメージに次を追加しています。

- PHP Extension
    - opcache
    - xdebug
    - ast
    - apcu
    - gd
    - pcntl
    - pdo_mysql
    - sockets
    - zip
- Command
    - ssh
    - rsync
    - git
    - mysql
    - composer
    - phpunit
    - phan
    - php-cs-fixer

PHP 拡張の xdebug はデフォで無効なので `docker-php-ext-enable xdebug` や `php -d zend_extension=xdebug.so` で有効化する必要があります。
その他の PHP 拡張はすべてデフォで有効です。

## Usage

```sh
docker run --rm ngyuki/php-dev php -v
docker run --rm ngyuki/php-dev phpunit --version
docker run --rm ngyuki/php-dev php -d zend_extension=xdebug.so -d opcache.enable_cli=1 /usr/local/bin/docker-php-check.php
```
