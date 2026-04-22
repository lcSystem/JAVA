#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

cleanup() {
    echo -e "\n${YELLOW}Deteniendo servidores...${NC}"
    if [ -n "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    exit
}

trap cleanup SIGINT SIGTERM

echo -e "${GREEN}🚀 Iniciando Backend (PHP) en http://localhost:8080...${NC}"
cd backend
# Usamos src/index.php como router para manejar rutas de Slim en el sv de desarrollo de PHP
php -S 0.0.0.0:8080 -t src src/index.php > backend_server.log 2>&1 &
BACKEND_PID=$!
cd ..

echo -e "${GREEN}📱 Iniciando Frontend (Flutter)...${NC}"
cd frontend
/home/lsyst/Descargas/flutter/bin/flutter run

# Cuando el frontend de detenga, se detendrá el backend
cleanup
