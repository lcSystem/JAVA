<?php
namespace App\Infrastructure\Services;

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use App\Domain\Repositories\SettingsRepositoryInterface;

class EmailService {
    private SettingsRepositoryInterface $settingsRepository;

    public function __construct(SettingsRepositoryInterface $settingsRepository) {
        $this->settingsRepository = $settingsRepository;
    }

    public function sendEmail(string $to, string $subject, string $body, bool $isHtml = true): bool {
        $settings = $this->getSmtpSettings();
        
        if (($settings['enable_email_notifications'] ?? '0') !== '1') {
            return false;
        }

        $mail = new PHPMailer(true);

        try {
            // Server settings
            $mail->isSMTP();
            $mail->Host       = $settings['smtp_host'] ?? '';
            $mail->SMTPAuth   = true;
            $mail->Username   = $settings['smtp_user'] ?? '';
            $mail->Password   = $settings['smtp_pass'] ?? '';
            $mail->SMTPSecure = $settings['smtp_encryption'] ?? PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port       = (int)($settings['smtp_port'] ?? 587);
            $mail->CharSet    = 'UTF-8';

            // Recipients
            $mail->setFrom($settings['mail_from_address'] ?? $settings['smtp_user'], $settings['mail_from_name'] ?? 'Salón Belleza Pro');
            $mail->addAddress($to);

            // Content
            $mail->isHTML($isHtml);
            $mail->Subject = $subject;
            $mail->Body    = $body;

            $mail->send();
            return true;
        } catch (Exception $e) {
            error_log("Email Error: " . $mail->ErrorInfo);
            return false;
        }
    }

    private function getSmtpSettings(): array {
        $all = $this->settingsRepository->getAll();
        $settings = [];
        foreach ($all as $s) {
            $settings[$s->getKeyName()] = $s->getValue();
        }
        return $settings;
    }

    public function sendInvoiceEmail(string $to, array $saleData): bool {
        $subject = "Factura de Venta - " . ($saleData['invoice_number'] ?? $saleData['id']);
        
        $body = "<h2>Gracias por tu compra en Salón Belleza Pro</h2>";
        $body .= "<p>Detalles de tu venta:</p>";
        $body .= "<ul>";
        $body .= "<li><strong>Fecha:</strong> " . date('Y-m-d H:i') . "</li>";
        $body .= "<li><strong>Total:</strong> $" . number_format($saleData['total'], 2) . "</li>";
        $body .= "</ul>";
        $body .= "<p>Adjunto encontrarás el detalle de los servicios/productos adquiridos.</p>";
        
        return $this->sendEmail($to, $subject, $body);
    }
}
