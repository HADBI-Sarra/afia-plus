# Row Level Security (RLS) Setup for Supabase

This directory contains SQL scripts to enable and manage Row Level Security (RLS) policies for the `users`, `patients`, and `doctors` tables in your Supabase database.

## Files

- **`enable_rls_policies.sql`** - Enables RLS and creates security policies
- **`disable_rls_policies.sql`** - Disables RLS and removes all policies (rollback script)

## How to Use

### Step 1: Enable RLS Policies

1. Open your Supabase Dashboard
2. Go to **SQL Editor**
3. Copy and paste the contents of `enable_rls_policies.sql`
4. Click **Run** to execute the script

Alternatively, you can run it via the Supabase CLI:
```bash
supabase db execute -f backend/sql/enable_rls_policies.sql
```

### Step 2: Verify Everything Works

After enabling RLS, test your application to ensure:
- ✅ User signup still works
- ✅ User login still works
- ✅ Users can view their own profile
- ✅ Users can update their own profile
- ✅ Patients can browse doctor profiles
- ✅ Doctors can view patient information (if needed)

**Note:** Since your backend uses the service role key (`SUPABASE_SERVICE_ROLE_KEY`), it bypasses RLS completely. Your existing backend code will continue to work without any changes.

### Step 3: Rollback (if needed)

If you encounter any issues and need to disable RLS:

1. Open your Supabase Dashboard
2. Go to **SQL Editor**
3. Copy and paste the contents of `disable_rls_policies.sql`
4. Click **Run** to execute the script

## What These Policies Do

### Users Table
- ✅ Users can read and update their own profile
- ✅ Authenticated users can read public information of other users (for doctor/patient lookups)
- ✅ Users can insert their own profile during signup

### Patients Table
- ✅ Patients can read and update their own patient record
- ✅ Patients can insert their own record during signup
- ✅ Doctors can read patient records (for consultations)

### Doctors Table
- ✅ Doctors can read and update their own doctor record
- ✅ Doctors can insert their own record during signup
- ✅ Authenticated users can read doctor profiles (for browsing and booking)

## Important Notes

1. **Service Role Bypasses RLS**: Your backend uses `supabaseAdmin` which uses the service role key. This bypasses RLS completely, so your existing code will work without changes.

2. **RLS Protects Direct Access**: RLS policies protect against:
   - Direct database access from unauthorized users
   - Future client-side queries using the anon key
   - SQL injection attempts

3. **Testing RLS**: To test if RLS is working, you can temporarily use the anon key in your backend instead of the service role key. This will enforce RLS policies.

4. **Modifying Policies**: If you need to adjust policies:
   ```sql
   -- Drop a policy
   DROP POLICY "policy_name" ON table_name;
   
   -- Then recreate it with your changes
   CREATE POLICY "policy_name" ON table_name ...
   ```

## Troubleshooting

### Issue: Signup fails after enabling RLS
**Solution**: Make sure the INSERT policies are in place. The signup process should work because your backend uses the service role, but if you're testing with the anon key, ensure the INSERT policies allow users to create their own records.

### Issue: Users can't see doctor profiles
**Solution**: Check that the "Authenticated users can read doctor profiles" policy exists and is correctly configured.

### Issue: Backend queries fail
**Solution**: This shouldn't happen since the service role bypasses RLS. If it does, check your Supabase configuration and ensure you're using the service role key, not the anon key.

## Security Best Practices

1. **Never expose the service role key** in client-side code
2. **Use the anon key** for client-side queries (which will be protected by RLS)
3. **Use the service role key** only in your backend server
4. **Regularly review** your RLS policies to ensure they match your security requirements

## Need Help?

If you encounter any issues:
1. Check the Supabase logs in your dashboard
2. Verify your policies are correctly created (check the **Authentication > Policies** section)
3. Test with the rollback script if needed
4. Review the policy conditions to ensure they match your use case

