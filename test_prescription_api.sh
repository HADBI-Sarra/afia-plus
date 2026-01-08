#!/bin/bash
# Prescription Testing Script
# This script helps test the prescription upload and retrieval API endpoints

BASE_URL="http://localhost:3000"

echo "🧪 Prescription API Testing Script"
echo "=================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Upload Prescription
echo -e "${YELLOW}Test 1: Upload Prescription${NC}"
echo "POST /consultations/1/prescription"
echo ""

curl -X POST "${BASE_URL}/consultations/1/prescription" \
  -H "Content-Type: application/json" \
  -d '{
    "prescription": "prescriptions/prescription_1.pdf"
  }' \
  -w "\n\nStatus: %{http_code}\n" \
  -s

echo ""
echo "---"
echo ""

# Test 2: Get Patient Prescriptions
echo -e "${YELLOW}Test 2: Get Patient Prescriptions${NC}"
echo "GET /consultations/patient/1/prescriptions"
echo ""

curl -X GET "${BASE_URL}/consultations/patient/1/prescriptions" \
  -H "Content-Type: application/json" \
  -w "\n\nStatus: %{http_code}\n" \
  -s

echo ""
echo "---"
echo ""

# Test 3: Get Doctor Past Consultations
echo -e "${YELLOW}Test 3: Get Doctor Past Consultations${NC}"
echo "GET /consultations/doctor/1/past"
echo ""

curl -X GET "${BASE_URL}/consultations/doctor/1/past" \
  -H "Content-Type: application/json" \
  -w "\n\nStatus: %{http_code}\n" \
  -s

echo ""
echo "---"
echo ""

echo -e "${GREEN}✅ Testing Complete!${NC}"
echo ""
echo "Next Steps:"
echo "1. Check if the prescription was added to the database"
echo "2. Test in the mobile app (doctor upload & patient view)"
echo "3. Verify PDF file storage in device"
