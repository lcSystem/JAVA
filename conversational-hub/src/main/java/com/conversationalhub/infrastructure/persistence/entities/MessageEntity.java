package com.conversationalhub.infrastructure.persistence.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

import java.time.LocalDateTime;

@Entity
@Table(name = "messages")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@SQLDelete(sql = "UPDATE messages SET deleted_at = NOW() WHERE id = ?")
@Where(clause = "deleted_at IS NULL")
public class MessageEntity {
    @Id
    private String id;
    private String channelId;
    private String senderId;
    private String recipientId;
    private String content;
    private String type;
    private String metadata; // Store as JSON string
    private LocalDateTime timestamp;
    private LocalDateTime deletedAt;
}
