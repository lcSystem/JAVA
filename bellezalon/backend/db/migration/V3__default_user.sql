-- V3: Default Admin User
INSERT IGNORE INTO
    users (
        username,
        password,
        email,
        role
    )
VALUES (
        'admin',
        '$2y$10$NjwwcAhdOxG5jotBgNGLSeayrNMRzkLaCCHSxJr5dbqof16VGCNNK',
        'admin@salon.pro',
        'ADMIN'
    );