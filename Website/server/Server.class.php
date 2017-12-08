<?php
require_once 'Database.class.php';

abstract class Request {
    const login   = 1;
    const logout  = 2;
}

abstract class Account {
    const valid   = 1;
    const invalid = 2;
    const expired = 3;
    const locked  = 4;
    const limit   = 5;
}

class Server {
    private $request  = null;
    private $database = null;

    private $thirtyMinutes = 1800;
    private $oneDay        = 86400;

    function __construct($request) {
        $this->request = json_decode($request);
        if ($this->request == null)
            throw new Exception('Invalid json.');

        if (!$this->isValidRequest())
            throw new Exception('Invalid request');

        try {
            // ارتباط با بانک اطلاعاتی
            $this->database = new Database();
        } catch (Exception $e) {
            throw $e;
        }

        // ارسال پاسخ مناسب
        echo $this->response();
    }

    private function response() {
        switch ($this->request->request)
        {
            case Request::login:
                return $this->login();

            case Request::logout:
                return $this->logout();
        }
    }

    private function login() {
        $account = $this->database->getAccount($this->request->username, $this->request->password);
        if (is_null($account))
            return $this->invalid();

        $currentTime = time();

        if ($currentTime >= strtotime($account['expiry_date']))
            return $this->expired();

        if ($account['max_users'] <= 0)
            return $this->locked();

        $onlines = $this->database->getOnlines($this->request->username);

        $id = 0;

        if (!is_null($onlines)) {
            $onlineCount = 0;

            foreach ($onlines as $online) {
                if (strcmp($this->request->machineId, $online['machine_id']) == 0) {
                    $id = $online['id'];
                } else {
                    if ($currentTime - strtotime($online['last_seen']) < $this->thirtyMinutes)
                        $onlineCount++;
                    else
                        $this->database->setOffline($online['id']);
                }
            }

            if ($onlineCount >= $account['max_users'])
                return $this->limit();
        }

        if ($id)
            $this->database->updateOnline($id);
        else
            $this->database->setOnline($this->request->username, $this->request->machineId);

        return $this->valid($account['expiry_date']);
    }

    private function logout() {
        $this->database->logout($this->request->username, $this->request->machineId);
    }

    private function valid($expiryDate) {
        $remainingDays = floor((strtotime($expiryDate) - time()) / $this->oneDay);

        $response = array(
            'Result'        => Account::valid,
            'Version'       => $this->database->getLatestVersion(),
            'RemainingDays' => $remainingDays
            );
        return json_encode($response);
    }

    private function invalid() {
        $response = array(
            'Result' => Account::invalid
            );
        return json_encode($response);
    }

    private function expired() {
        $response = array(
            'Result' => Account::expired
            );
        return json_encode($response);
    }

    private function locked() {
        $response = array(
            'Result' => Account::locked
            );
        return json_encode($response);
    }

    private function limit() {
        $response = array(
            'Result' => Account::limit
            );
        return json_encode($response);
    }

    private function isValidRequest() {
        // اگر کد درخواست، نام کاربری یا شناسه کامپیوتر وجود نداشت
        if (!isset($this->request->request, $this->request->username, $this->request->machineId))
            return false;

        // اگر کد درخواست عدد صحیح نبود و یا در بازه ورود تا خروج قرار نداشت
        if (!is_int($this->request->request) || $this->request->request < Request::login || $this->request->request > Request::logout)
            return false;

        // اگر کد درخواست برابر با ورود بود
        if ($this->request->request == Request::login) {
            // اگر گذرواژه وجود نداشت
            if (isset($this->request->password)) {
                // حذف کردن تمامی فاصله ها از گذرواژه
                $this->request->password = preg_replace('/\s+/', '', $this->request->password);

                // اگر طول گذرواژه برابر با 32 کاراکتر نبود
                if (strlen($this->request->password) != 32)
                    return false;
            } else {
                return false;
            }
        }

        // حذف کردن تمامی فاصله ها از نام کاربری
        $this->request->username = preg_replace('/\s+/', '', $this->request->username);

        // اگر طول نام کاربری کمتر از 1 یا بیشتر از 16 کاراکتر بود
        $len = strlen($this->request->username);
        if ($len < 1 || $len > 16)
            return false;

        // حذف کردن تمامی فاصله ها از شناسه کامپیوتر
        $this->request->machineId = preg_replace('/\s+/', '', $this->request->machineId);

        // اگر طول شناسه کامپیوتر برابر با 32 کاراکتر نبود
        if (strlen($this->request->machineId) != 32)
            return false;

        // تبریک می گم، شما قبول شدید
        return true;
    }
}