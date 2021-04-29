# ngyuki/php-dev

PHP のアプリ開発用の Docker イメージ。

- [ngyuki/php-dev - Docker Hub](https://hub.docker.com/r/ngyuki/php-dev/ "ngyuki/php-dev - Docker Hub")

公式の php:alpine のイメージに次を追加しています。

- PHP Extension
    - apcu
    - ast
    - gd
    - opcache
    - pcntl
    - pdo_mysql
    - sockets
    - xdebug
    - zip
- Command
    - bash
    - git
    - jq
    - mysql
    - rsync
    - ssh
    - unzip
- Command(phar)
    - composer
    - phan
    - php-cs-fixer
    - phpunit

PHP 拡張の xdebug はデフォで無効なので `docker-php-ext-enable xdebug` や `php -d zend_extension=xdebug.so` で有効化する必要があります。
その他の PHP 拡張はすべてデフォで有効です。

## Usage

```sh
docker run --rm ngyuki/php-dev php -v
docker run --rm ngyuki/php-dev phpunit --version
docker run --rm -i ngyuki/php-dev php -d zend_extension=xdebug.so < check.php
```
