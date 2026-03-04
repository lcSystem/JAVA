package com.notifications.domain.service;

import com.notifications.domain.model.Notification;
import com.notifications.domain.model.NotificationLevel;
import com.notifications.domain.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
// import org.springframework.mail.SimpleMailMessage;
// import org.springframework.mail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final SimpMessagingTemplate messagingTemplate;
    // private final JavaMailSender mailSender;

    public Notification getNotificationById(Long id) {
        return notificationRepository.findById(id).orElse(null);
    }

    @Transactional
    public Notification createNotification(Notification notification) {
        log.info("Creating notification for user: {}", notification.getUserId());
        Notification saved = notificationRepository.save(notification);

        // Notify via WebSocket
        try {
            messagingTemplate.convertAndSendToUser(
                    notification.getUserId(),
                    "/queue/notifications",
                    saved);
        } catch (Exception e) {
            log.warn("Failed to send WebSocket notification, but record was saved to DB: {}", e.getMessage());
        }

        return saved;
    }

    public List<Notification> getNotificationsForUser(String userId) {
        return notificationRepository.findByUserIdOrUserIdOrderByTimestampDesc(userId, "SYSTEM");
    }

    public List<Notification> getAllNotifications() {
        return notificationRepository.findAllByOrderByTimestampDesc();
    }

    public List<Notification> getUnreadNotificationsForUser(String userId) {
        return notificationRepository.findByUserIdAndReadStatusOrUserIdAndReadStatusOrderByTimestampDesc(userId, false,
                "SYSTEM", false);
    }

    @Transactional
    public void markAsRead(Long notificationId) {
        notificationRepository.findById(notificationId).ifPresent(n -> {
            n.setReadStatus(true);
            notificationRepository.save(n);
        });
    }

    public long countUnread(String userId) {
        return notificationRepository.countByUserIdAndReadStatusOrUserIdAndReadStatus(userId, false, "SYSTEM", false);
    }

    public void sendEmailNotification(Notification notification) {
        log.info("Email notification triggered for: {}. (Logic temporarily disabled for compilation fixing)",
                notification.getId());
        /*
         * try {
         * log.info("Sending email for error notification: {}", notification.getId());
         * SimpleMailMessage message = new SimpleMailMessage();
         * message.setTo("admin@example.com");
         * message.setSubject("SYSTEM ERROR: " + notification.getType());
         * message.setText(notification.getMessage());
         * mailSender.send(message);
         * } catch (Exception e) {
         * log.error("Failed to send email notification", e);
         * }
         */
    }
}
