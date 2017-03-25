<?php
namespace App;

require __DIR__ . '/../vendor/autoload.php';

var_dump(['pid' => posix_getpid()]);
var_dump(['cwd' => getcwd()]);

$pdo = (new DbManager())->getConnection();

$stmt = $pdo->prepare("SELECT now(), user(), T.* FROM test T");
$stmt->execute();

var_dump(['rows' => $stmt->fetchAll()]);
