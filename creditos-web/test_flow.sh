#!/bin/bash

# Configuration
AUTH_URL="http://localhost:8081/api/auth"
CREDIT_URL="http://localhost:8082/api"
USER="lcardenas"
PASS="admin"

echo "2. LISTING CREDIT TYPES..."
curl -s -X GET "$CREDIT_URL/credit-types" | jq '.'

echo "3. SUBMITTING CREDIT REQUEST..."
# Assuming userId=2 (lcardenas).
REQUEST_PAYLOAD='{
  "applicantUserId": 2, 
  "creditTypeId": 1,
  "amount": 5000,
  "termMonths": 12,
  "purpose": "Test Credit Request via Script (Bypassed)"
}'

RESPONSE=$(curl -s -X POST "$CREDIT_URL/credit-requests/submit" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_PAYLOAD")

echo "Submit Response: $RESPONSE"
ID=$(echo $RESPONSE | jq -r '.id')

if [ "$ID" == "null" ] || [ -z "$ID" ]; then
    echo "Failed to submit request."
    exit 1
fi

echo "Request Created with ID: $ID"

echo "4. EVALUATING REQUEST..."
curl -s -X POST "$CREDIT_URL/credit-requests/$ID/evaluate" | jq '.'

echo "5. APPROVING REQUEST..."
curl -s -X POST "$CREDIT_URL/credit-requests/$ID/approve?comments=AutoApproved" | jq '.'

echo "6. DISBURSING REQUEST..."
curl -s -X POST "$CREDIT_URL/credit-requests/$ID/disburse" | jq '.'

echo "7. VERIFYING MY REQUESTS..."
curl -s -X GET "$CREDIT_URL/credit-requests/user/2" | jq '.'
