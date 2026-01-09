# Supabase Storage Setup for Prescription PDFs

## 🎯 Overview
This guide helps you set up Supabase Storage bucket to enable cloud-based prescription PDF sharing between doctors and patients.

---

## 📋 Step-by-Step Setup

### 1. **Login to Supabase Dashboard**
- Go to: https://supabase.com/dashboard
- Login to your account
- Select your project: `usyjkxfolmfyzrtxvivl`

### 2. **Create Storage Bucket**

**Navigation:**
1. Click **Storage** in the left sidebar
2. Click **New Bucket** button

**Bucket Configuration:**
```
Bucket Name: prescriptions
Public bucket: ✅ YES (Enable public access)
File size limit: 50 MB (recommended)
Allowed MIME types: application/pdf
```

**CRITICAL: Disable RLS (Row Level Security)**
After creating the bucket:
1. Click on the `prescriptions` bucket
2. Go to **Policies** tab
3. Click **"Disable RLS"** or ensure "Enable RLS" is OFF
4. ✅ This allows anonymous uploads (since we're using anon key)

**Why public?** Patients need to download prescription PDFs directly from URLs without authentication.

### 3. **IMPORTANT: Disable RLS (Row Level Security)**

**For now, DISABLE RLS completely:**
1. Go to **Storage** → **prescriptions** bucket
2. Click **Policies** tab
3. Ensure **"Enable RLS"** toggle is OFF
4. ✅ Done

**Why?** Your app uses the `anon` key, and RLS blocks anonymous uploads by default.

---

### 4. **Set Bucket Policies (Optional - Future Enhancement)**

If you later want to add authentication and restrict uploads to only doctors:

```sql
-- First, ENABLE RLS on the bucket
-- Then add these policies:

-- Allow anyone to read (download) prescriptions
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
TO public
USIN5 (bucket_id = 'prescriptions');

-- Only authenticated users can upload (doctors)
CREATE POLICY "Authenticated upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'prescriptions');
```

**But for MVP: Just disable RLS completely** ✅

### 4. **Verify Bucket Creation**

Test upload using Supabase Dashboard:
1. Go to **Storage** → **prescriptions** bucket
2. Click **Upload file**
3. Upload any test PDF
4. Click on the uploaded file
5. Copy the **Public URL** (should look like):
   ```
   https://usyjkxfolmfyzrtxvivl.supabase.co/storage/v1/object/public/prescriptions/test.pdf
   ```
6. Open URL in browser - PDF should open ✅

---

## 🔄 How It Works Now

### **Before (Local Storage - NOT WORKING)**
```
Doctor Device → PDF saved locally → Path stored in DB → Patient Device ❌ (file doesn't exist)
```

### **After (Cloud Storage - WORKING)** ✅
```
Doctor Device → Upload to Supabase Storage → URL stored in DB → Patient downloads from URL ✅
```

---

## 💻 Code Changes Made

### 1. **Frontend (Flutter)**

**Files Modified:**
- `pubspec.yaml` - Added `supabase_flutter: ^2.8.0`
- `lib/config/supabase_config.dart` - NEW: Supabase configuration
- `lib/main.dart` - Initialize Supabase on app startup
- `lib/utils/pdf_service.dart` - Added cloud upload/download methods
- `lib/cubits/doctor_appointments_cubit.dart` - Upload to cloud instead of local
- `lib/views/screens/userPages/prescription.dart` - Download from cloud
- `lib/l10n/app_*.arb` - Added "downloadingPdf" translations

**New Methods:**
```dart
// Upload PDF to cloud (doctor)
PDFService.uploadToSupabase(pdfFile, consultationId)
  → Returns: "https://.../prescriptions/prescription_15.pdf"

// Download PDF from cloud (patient)
PDFService.downloadFromSupabase(publicUrl, consultationId)
  → Returns: Local cached file

// Check if already cached
PDFService.getCachedPDF(consultationId)
  → Returns: File or null
```

### 2. **Backend (No Changes Needed)**
The backend already stores the prescription field as text - it now stores URLs instead of local paths.

---

## 🧪 Testing the Feature

### **Test as Doctor:**
1. Run the Flutter app as a doctor
2. Go to **Manage Appointments** → Past appointments
3. Click **Upload PDF** on a completed consultation
4. Select a PDF file
5. ✅ Should upload to Supabase and show success message

### **Verify in Supabase:**
1. Go to Supabase Dashboard → **Storage** → **prescriptions**
2. ✅ Should see `prescription_15.pdf` (or similar)
3. Click on it and verify the Public URL works

### **Test as Patient:**
1. Run the Flutter app as a patient
2. Go to **My Prescriptions**
3. Click **View Prescription** on a consultation with uploaded PDF
4. ✅ Should download from cloud and open PDF

---

## 🔐 Security Considerations

**Current Setup (Recommended for MVP):**
- ✅ Bucket is public (anyone with URL can view)
- ✅ Simple and fast
- ⚠️ URLs are guessable if someone knows consultation ID

**Enhanced Security (Future):**
- Use signed URLs with expiration
- Add RLS policies to check user permissions
- Encrypt sensitive prescription data

---

## 📊 Storage Limits

**Supabase Free Tier:**
- Storage: 1 GB
- Bandwidth: 2 GB/month
- If average PDF = 200 KB:
  - Can store ~5,000 prescriptions
  - Can serve ~10,000 downloads/month

**Upgrade if needed:**
- Pro plan: $25/month (100 GB storage, 200 GB bandwidth)

---

## 🐛 Troubleshooting

### Issue: "Failed to upload PDF to cloud" / "403 Unauthorized" / "signature verification failed"
**Solution:**
- ✅ **Most common cause:** RLS is enabled on the bucket
  - Go to Storage → prescriptions → Policies tab
  - **DISABLE RLS** (turn off "Enable RLS" toggle)
- Verify bucket name is exactly `prescriptions`
- Check Supabase credentials in `supabase_config.dart`
- Ensure bucket is set to **Public**
- Check internet connection

### Issue: "Failed to download PDF"
**Solution:**
- Verify URL is correct in database
- Check if file exists in Supabase Storage
- Check internet connection

### Issue: "Bucket not found"
**Solution:**
- Create the `prescriptions` bucket in Supabase Dashboard
- Ensure bucket is set to public

---

## ✅ Checklist
**DISABLED RLS** on the bucket (Policies tab → disable RLS)
- [ ] 
Before testing:
- [ ] Created `prescriptions` bucket in Supabase Dashboard
- [ ] Set bucket to **public**
- [ ] Ran `flutter pub get` to install supabase_flutter
- [ ] Restarted the Flutter app
- [ ] Tested doctor upload flow
- [ ] Tested patient download flow

---

## 🎉 Success Criteria

When working correctly:
1. ✅ Doctor uploads PDF → Shows success message
2. ✅ File appears in Supabase Storage Dashboard
3. ✅ Database stores URL like: `https://.../prescriptions/prescription_X.pdf`
4. ✅ Patient clicks "View Prescription" → Downloads and opens PDF
5. ✅ Second click uses cached version (faster, no download)

---

**Next Step:** Follow Step 2 above to create the `prescriptions` bucket in Supabase Dashboard, then test the flow!
