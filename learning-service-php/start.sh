#!/bin/bash

# Configuration
PORT=8080
HOST="localhost"
PUBLIC_DIR="public"

echo "🚀 Starting Learning Platform Backend (PHP)..."
echo "📍 API will be available at: http://$HOST:$PORT"

# Check if PHP is installed
if ! command -v php &> /dev/null
then
    echo "❌ Error: PHP is not installed or not in PATH."
    exit 1
fi

# Run the built-in PHP server
php -S $HOST:$PORT -t $PUBLIC_DIR
