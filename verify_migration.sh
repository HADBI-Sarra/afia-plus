#!/bin/bash
# Supabase Migration - Verification Script
# Run this to verify all components are properly implemented

echo "======================================"
echo "AFIA+ Supabase Migration Verification"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Checking Backend Files...${NC}"
echo ""

# Check backend services
if [ -f "backend/services/doctor_availability.service.js" ]; then
    echo -e "${GREEN}✅${NC} doctor_availability.service.js"
else
    echo -e "${RED}❌${NC} doctor_availability.service.js"
fi

if [ -f "backend/services/consultations.service.js" ]; then
    echo -e "${GREEN}✅${NC} consultations.service.js"
else
    echo -e "${RED}❌${NC} consultations.service.js"
fi

# Check backend controllers
if [ -f "backend/controllers/doctor_availability.controller.js" ]; then
    echo -e "${GREEN}✅${NC} doctor_availability.controller.js"
else
    echo -e "${RED}❌${NC} doctor_availability.controller.js"
fi

if [ -f "backend/controllers/consultations.controller.js" ]; then
    echo -e "${GREEN}✅${NC} consultations.controller.js"
else
    echo -e "${RED}❌${NC} consultations.controller.js"
fi

# Check backend routes
if [ -f "backend/routes/doctor_availability.routes.js" ]; then
    echo -e "${GREEN}✅${NC} doctor_availability.routes.js"
else
    echo -e "${RED}❌${NC} doctor_availability.routes.js"
fi

if [ -f "backend/routes/consultations.routes.js" ]; then
    echo -e "${GREEN}✅${NC} consultations.routes.js"
else
    echo -e "${RED}❌${NC} consultations.routes.js"
fi

echo ""
echo -e "${YELLOW}Checking Frontend Files...${NC}"
echo ""

# Check frontend models
if [ -f "frontend/lib/models/doctor_availability.dart" ]; then
    echo -e "${GREEN}✅${NC} doctor_availability.dart (model)"
else
    echo -e "${RED}❌${NC} doctor_availability.dart (model)"
fi

# Check frontend repos
if [ -f "frontend/lib/data/repo/doctor_availability/doctor_availability_impl.dart" ]; then
    echo -e "${GREEN}✅${NC} doctor_availability_impl.dart"
else
    echo -e "${RED}❌${NC} doctor_availability_impl.dart"
fi

if [ -f "frontend/lib/data/repo/consultations/consultations_impl.dart" ]; then
    echo -e "${GREEN}✅${NC} consultations_impl.dart (refactored)"
else
    echo -e "${RED}❌${NC} consultations_impl.dart (refactored)"
fi

# Check frontend cubits
if [ -f "frontend/lib/cubits/doctor_availability_cubit.dart" ]; then
    echo -e "${GREEN}✅${NC} doctor_availability_cubit.dart"
else
    echo -e "${RED}❌${NC} doctor_availability_cubit.dart"
fi

echo ""
echo -e "${YELLOW}Checking Documentation...${NC}"
echo ""

if [ -f "SUPABASE_MIGRATION_GUIDE.md" ]; then
    echo -e "${GREEN}✅${NC} SUPABASE_MIGRATION_GUIDE.md"
else
    echo -e "${RED}❌${NC} SUPABASE_MIGRATION_GUIDE.md"
fi

if [ -f "ARCHITECTURE_REFERENCE.md" ]; then
    echo -e "${GREEN}✅${NC} ARCHITECTURE_REFERENCE.md"
else
    echo -e "${RED}❌${NC} ARCHITECTURE_REFERENCE.md"
fi

if [ -f "IMPLEMENTATION_CHECKLIST.md" ]; then
    echo -e "${GREEN}✅${NC} IMPLEMENTATION_CHECKLIST.md"
else
    echo -e "${RED}❌${NC} IMPLEMENTATION_CHECKLIST.md"
fi

if [ -f "EXECUTIVE_SUMMARY.md" ]; then
    echo -e "${GREEN}✅${NC} EXECUTIVE_SUMMARY.md"
else
    echo -e "${RED}❌${NC} EXECUTIVE_SUMMARY.md"
fi

echo ""
echo "======================================"
echo "Verification Complete!"
echo "======================================"
echo ""
echo "Next Steps:"
echo "1. Verify Supabase credentials in .env"
echo "2. Start backend: cd backend && npm start"
echo "3. Test endpoints with cURL"
echo "4. Update Flutter screens"
echo "5. Run Flutter tests"
echo ""
