# Prescription API Testing (PowerShell)
# Run this in PowerShell to test prescription endpoints

$BASE_URL = "http://localhost:3000"

Write-Host "`n🧪 Prescription API Testing Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Upload Prescription
Write-Host "Test 1: Upload Prescription" -ForegroundColor Yellow
Write-Host "POST /consultations/1/prescription`n"

$body = @{
    prescription = "prescriptions/prescription_1.pdf"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/consultations/1/prescription" `
        -Method Post `
        -Body $body `
        -ContentType "application/json"
    
    Write-Host "✅ Success!" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Write-Host "`n---`n"

# Test 2: Get Patient Prescriptions
Write-Host "Test 2: Get Patient Prescriptions" -ForegroundColor Yellow
Write-Host "GET /consultations/patient/1/prescriptions`n"

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/consultations/patient/1/prescriptions" `
        -Method Get `
        -ContentType "application/json"
    
    Write-Host "✅ Success!" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Write-Host "`n---`n"

# Test 3: Get Doctor Past Consultations
Write-Host "Test 3: Get Doctor Past Consultations" -ForegroundColor Yellow
Write-Host "GET /consultations/doctor/1/past`n"

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/consultations/doctor/1/past" `
        -Method Get `
        -ContentType "application/json"
    
    Write-Host "✅ Success!" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Write-Host "`n---`n"

Write-Host "✅ Testing Complete!`n" -ForegroundColor Green
Write-Host "Next Steps:"
Write-Host "1. Check if the prescription was added to the database"
Write-Host "2. Test in the mobile app (doctor upload & patient view)"
Write-Host "3. Verify PDF file storage in device"
