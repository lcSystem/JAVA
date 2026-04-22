#!/bin/bash
echo "1. Obtener Token deiam-core-p"
HTTP_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin", "password":"password"}')

BODY=$(echo "$HTTP_RESPONSE" | sed -e '$d')
STATUS=$(echo "$HTTP_RESPONSE" | tail -n1 | grep -o "[0-9]*")

echo "Login status: $STATUS"
TOKEN=$(echo "$BODY" | grep -o '"jwt":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  # Maybe token is called something else
  echo "No jwt found, falling back to full body:"
  echo "$BODY"
  exit 1
fi
echo "Token obtenido correctamente."

echo "2. Probando /api/v1/dynamic-reports/data-sources"
curl -s -v http://localhost:8085/api/v1/dynamic-reports/data-sources \
  -H "Authorization: Bearer $TOKEN"
