-- Migration to add geolocation and VPN/Proxy detection fields to user_sessions
ALTER TABLE user_sessions
ADD COLUMN city VARCHAR(255),
ADD COLUMN country VARCHAR(255),
ADD COLUMN latitude DOUBLE,
ADD COLUMN longitude DOUBLE,
ADD COLUMN is_vpn BOOLEAN DEFAULT FALSE,
ADD COLUMN is_proxy BOOLEAN DEFAULT FALSE,
ADD COLUMN isp VARCHAR(255);

-- Index for IP to facilitate geolocation caching
CREATE INDEX idx_sessions_ip ON user_sessions (ip_address);