<?php
namespace Test;

use PHPUnit\Framework\TestCase;
use App\DbManager;

class SampleTest extends TestCase
{
    function test()
    {
        $pdo = (new DbManager())->getConnection();

        $stmt = $pdo->prepare("SELECT * FROM test");
        $stmt->execute();
        $rows = $stmt->fetchAll();

        $this->assertNotEmpty($rows);
    }
}
