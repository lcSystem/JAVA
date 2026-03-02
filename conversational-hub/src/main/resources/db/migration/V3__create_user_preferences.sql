CREATE TABLE user_preferences (
    user_id VARCHAR(255) PRIMARY KEY,
    chat_color VARCHAR(50),
    is_floating_bubble BOOLEAN DEFAULT FALSE,
    theme_mode VARCHAR(20)
);