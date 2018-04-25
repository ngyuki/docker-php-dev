<?php
namespace App;

$exit = 0;

function check($title, $status)
{
    global $exit;
    if ($status) {
        printf("ok: %s\n", $title);
    } else {
        printf("failed: %s\n", $title);
        $exit = 1;
    }
}

function check_extension_loaded($ext)
{
    check("extension $ext", extension_loaded($ext));
}

function check_executable($filename)
{
    check("$filename", is_executable($filename));
}

check("opcache", !!opcache_get_status());

check_extension_loaded('xdebug');
check_extension_loaded('ast');
check_extension_loaded('apcu');
check_extension_loaded('gd');
check_extension_loaded('pdo_mysql');
check_extension_loaded('pcntl');
check_extension_loaded('zip');

check_executable('/usr/bin/ssh');
check_executable('/usr/bin/rsync');
check_executable('/usr/bin/git');
check_executable('/usr/bin/mysql');

check_executable('/usr/local/bin/phpunit');
check_executable('/usr/local/bin/composer');
check_executable('/usr/local/bin/php-cs-fixer');
check_executable('/usr/local/bin/phan');

exit($exit);
