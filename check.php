<?php
namespace App;

$success = 0;
$failed = 0;
$skipped = 0;

function check($title, $status, $message = null)
{
    global $success, $failed, $skipped;
    if ($status === null) {
        $skipped++;
        if ($message === null) {
            $message = '... SKIP ...';
        }
    } elseif ($status) {
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

function check_command($command, $when = true)
{
    $title = strtok($command, ' ');
    if (!$when) {
        $status = null;
        $message = null;
    } else {
        ob_start();
        try {
            system("$command 2>&1", $rc);
        } finally {
            $output = ob_get_clean();
        }
        $status = $rc === 0;
        $message = strtok($output, "\n");
    }
    check($title, $status, $message);
}

function check_extension($ext, $alias = null)
{
    $alias = $alias !== null ? $alias : $ext;
    check("$alias", extension_loaded($ext), phpversion($ext));
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
check_command('box --no-ansi --version', version_compare(PHP_VERSION, '7.1.0', '>='));

echo "\n=== Check php extension\n";
check_extension('zend opcache', 'opcache');
check_extension('xdebug');
check_extension('ast');
check_extension('apcu');
check_extension('gd');
check_extension('pcntl');
check_extension('pdo_mysql');
check_extension('sockets');
check_extension('zip');

echo "\n=== Result\n";
printf("total %d / success %d / failed %d / skipped %d\n", $success + $failed + $skipped, $success, $failed, $skipped);

exit((int)($failed > 0));
