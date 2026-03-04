package com.notifications.domain.repository;

import com.notifications.domain.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
        List<Notification> findByUserIdOrUserIdOrderByTimestampDesc(String userId, String systemId);

        List<Notification> findByUserIdAndReadStatusOrUserIdAndReadStatusOrderByTimestampDesc(String userId,
                        boolean readStatus, String systemId, boolean systemReadStatus);

        List<Notification> findAllByOrderByTimestampDesc();

        long countByUserIdAndReadStatusOrUserIdAndReadStatus(String userId, boolean readStatus, String systemId,
                        boolean systemReadStatus);
}
