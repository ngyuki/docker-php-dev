<?php
namespace App;

use PDO;

class DbManager
{
    public function getConnection()
    {
        static $pdo;

        if (isset($pdo) === false) {
            $host = getenv('MYSQL_HOST');
            $dbname = getenv('MYSQL_DATABASE');
            $username = getenv('MYSQL_USER');
            $password = getenv('MYSQL_PASSWORD');

            $pdo = new PDO(
                "mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password, [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]
            );
        }

        return $pdo;
    }
}
