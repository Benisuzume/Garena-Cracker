<?php
class Database {
    // مشخصات بانک اطلاعاتی
    private $username = 'faridagh_n3Sdfg4';
    private $password = 'wD7Z)s2{8%b6s?)faA';
    private $database = 'faridagh_j56SbgAwet57';

    private $mysqli = null;

    function __construct() {
        $this->mysqli = new mysqli(null, $this->username, $this->password, $this->database);

        if ($this->mysqli->connect_errno) {
            throw new Exception($this->mysqli->connect_error, $this->mysqli->connect_errno);
        }
    }

    function __destruct() {
        $this->mysqli->close();
    }

    function getAccount($username, $password) {
        $query = "SELECT expiry_date, max_users "
               . "FROM garenacracker_accounts "
               . "WHERE username='{$username}' AND password='{$password}'";

        $result = $this->query($query);
        if ($result->num_rows != 1)
            return null;

        $account = $result->fetch_assoc();
        $result->free();

        $account['max_users'] = intval($account['max_users'], 10);
        return $account;
    }

    function getOnlines($username) {
        $query = "SELECT id, machine_id, last_seen "
               . "FROM garenacracker_onlines "
               . "WHERE username='{$username}'";

        $result = $this->query($query);
        if ($result->num_rows == 0)
            return null;

        $onlines = array();
        while ($online = $result->fetch_assoc()) {
            $online['id'] = intval($online['id'], 10);
            array_push($onlines, $online);
        }

        $result->free();

        if (count($onlines) == 0)
            return null;

        return $onlines;
    }

    function setOffline($id) {
        $query = "DELETE FROM garenacracker_onlines "
               . "WHERE id={$id}";
        $this->query($query);
    }

    function setOnline($username, $machineId) {
        $query = "INSERT INTO garenacracker_onlines ("
               . "username, machine_id, last_seen"
               . ") VALUES ("
               . "'{$username}', '{$machineId}', CURRENT_TIMESTAMP() "
               . ")";
        $this->query($query);
    }

    function updateOnline($id) {
        $query = "UPDATE garenacracker_onlines "
               . "SET last_seen=CURRENT_TIMESTAMP() "
               . "WHERE id={$id}";
        $this->query($query);
    }

    function logout($username, $machineId) {
        $query = "DELETE FROM garenacracker_onlines "
               . "WHERE username='{$username}' AND machine_id='{$machineId}'";
        $this->query($query);
    }

    function getLatestVersion() {
        $query = "SELECT version "
               . "FROM garenacracker_program "
               . "WHERE id=1";

        $result = $this->query($query);
        if ($result->num_rows == 0)
            return null;

        $version = $result->fetch_assoc();
		$version = $version['version'];
        $result->free();

        return floatval($version);
    }

    private function query($query) {
        return $this->mysqli->query($query);
    }
}