<?php
namespace App\Infrastructure\Services;

class FcmService {
    private string $serviceAccountFile;

    public function __construct(string $serviceAccountFile) {
        $this->serviceAccountFile = $serviceAccountFile;
    }

    private function base64UrlEncode($data) {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private function getAccessToken(): ?string {
        if (!file_exists($this->serviceAccountFile)) {
            error_log("FCM: Service account file not found.");
            return null;
        }

        $json = json_decode(file_get_contents($this->serviceAccountFile), true);
        if (!$json) return null;

        $header = json_encode(['alg' => 'RS256', 'typ' => 'JWT']);
        $now = time();
        $payload = json_encode([
            'iss' => $json['client_email'],
            'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
            'aud' => $json['token_uri'],
            'exp' => $now + 3600,
            'iat' => $now
        ]);

        $base64UrlHeader = $this->base64UrlEncode($header);
        $base64UrlPayload = $this->base64UrlEncode($payload);

        $signature = '';
        openssl_sign(
            $base64UrlHeader . "." . $base64UrlPayload,
            $signature,
            $json['private_key'],
            "sha256WithRSAEncryption"
        );

        $base64UrlSignature = $this->base64UrlEncode($signature);
        $jwt = $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $json['token_uri']);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion' => $jwt
        ]));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $response = curl_exec($ch);
        curl_close($ch);

        $data = json_decode($response, true);
        return $data['access_token'] ?? null;
    }

    public function sendToToken(string $token, string $title, string $body, array $data = []): bool {
        $accessToken = $this->getAccessToken();
        if (!$accessToken) return false;

        $json = json_decode(file_get_contents($this->serviceAccountFile), true);
        $projectId = $json['project_id'];

        $url = "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send";

        $message = [
            'message' => [
                'token' => $token,
                'notification' => [
                    'title' => $title,
                    'body' => $body
                ],
                'data' => $data
            ]
        ];

        return $this->executeCurl($url, $accessToken, $message);
    }

    public function sendToTopic(string $topic, string $title, string $body, array $data = []): bool {
        $accessToken = $this->getAccessToken();
        if (!$accessToken) return false;

        $json = json_decode(file_get_contents($this->serviceAccountFile), true);
        $projectId = $json['project_id'];

        $url = "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send";

        $message = [
            'message' => [
                'topic' => $topic,
                'notification' => [
                    'title' => $title,
                    'body' => $body
                ],
                'data' => $data
            ]
        ];

        return $this->executeCurl($url, $accessToken, $message);
    }

    private function executeCurl(string $url, string $accessToken, array $message): bool {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($message));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        
        $result = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode >= 200 && $httpCode < 300) {
            return true;
        }

        error_log("FCM Send Error ($httpCode): $result");
        return false;
    }
}
