<?php
require_once 'Server.class.php';

header_remove();

/*
if (!isset($_SERVER['HTTPS'])) {
    header('HTTP/1.1 403 Forbidden');
    exit();
}
*/

if (strcmp($_SERVER['REQUEST_METHOD'], 'POST') != 0) {
    header('HTTP/1.1 405 Method Not Allowed');
    exit();
}

$request = file_get_contents('php://input');
if (strlen($request) == 0) {
    header('HTTP/1.1 411 Length Required');
    exit();
}

try {
    $server = new Server($request);
} catch (Exception $e) {
    // var_dump($e);
}