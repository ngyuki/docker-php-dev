<?php
namespace App;

$success = 0;
$failed = 0;

function check($title, $status, $message = null)
{
    global $success, $failed;
    if ($status) {
        $success++;
        if ($message === null) {
            $message = "ok";
        }
    } else {
        $failed++;
        if ($message === null) {
            $message = "failed";
        }
    }
    printf("%-16s%s\n", $title, $message);
}

function check_command($command)
{
    global $success, $failed;
    ob_start();
    try {
        system("$command 2>&1", $rc);
    } finally {
        $output = ob_get_clean();
    }
    $status = $rc === 0;
    $title = strtok($command, " ");
    $message = strtok($output, "\n");
    check($title, $status, $message);
}

function check_extension($ext)
{
    check("$ext", extension_loaded($ext));
}

echo "=== Check executable\n";
check_command('php --version');
check_command('ssh -V');
check_command('rsync --version');
check_command('git --version');
check_command('mysql --version');
check_command('composer --version');
check_command('phpunit --version');
check_command('php-cs-fixer --version');
check_command('phan --version');
check_command('box --no-ansi --version');

echo "\n=== Check php extension\n";
check("opcache", !!opcache_get_status());
check_extension('xdebug');
check_extension('ast');
check_extension('apcu');
check_extension('gd');
check_extension('pcntl');
check_extension('pdo_mysql');
check_extension('sockets');
check_extension('zip');

echo "\n=== Result\n";
printf("total %d / success %d / failed %d\n", $success + $failed, $success, $failed);

exit((int)($failed > 0));
