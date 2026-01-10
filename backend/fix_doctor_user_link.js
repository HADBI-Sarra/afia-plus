import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const envPath = path.resolve(__dirname, '.env');

dotenv.config({ path: envPath });

// Create Supabase client directly
const supabaseAdmin = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    {
        auth: {
            autoRefreshToken: false,
            persistSession: false
        }
    }
);

console.log('✅ Loaded environment from:', envPath);
console.log('✅ Supabase URL:', process.env.SUPABASE_URL);

/**
 * Fix doctors with NULL user_id
 * This script finds doctors where user_id is NULL and links them to their user account
 */

async function fixDoctorUserLinks() {
    console.log('🔧 Checking for doctors with NULL user_id...');

    // Get all doctors
    const { data: doctors, error: doctorError } = await supabaseAdmin
        .from('doctors')
        .select('doctor_id, user_id');

    if (doctorError) {
        console.error('❌ Error fetching doctors:', doctorError);
        return;
    }

    console.log(`📋 Found ${doctors.length} total doctors`);

    // Find doctors with NULL user_id
    const doctorsWithoutUser = doctors.filter(d => d.user_id === null);

    if (doctorsWithoutUser.length === 0) {
        console.log('✅ All doctors have valid user_id links!');
        return;
    }

    console.log(`⚠️  Found ${doctorsWithoutUser.length} doctors with NULL user_id:`);
    doctorsWithoutUser.forEach(d => {
        console.log(`   - Doctor ID: ${d.doctor_id}`);
    });

    // For each doctor without user_id, find matching user by doctor_id
    for (const doctor of doctorsWithoutUser) {
        console.log(`\n🔍 Fixing doctor_id: ${doctor.doctor_id}`);

        // In the database, doctor_id in doctors table should match user_id in users table
        // where role = 'doctor'
        const { data: users, error: userError } = await supabaseAdmin
            .from('users')
            .select('user_id, firstname, lastname, email, role')
            .eq('role', 'doctor');

        if (userError) {
            console.error('   ❌ Error fetching users:', userError);
            continue;
        }

        // The doctor_id is the PRIMARY KEY which should match a user_id
        const matchingUser = users.find(u => u.user_id === doctor.doctor_id);

        if (matchingUser) {
            console.log(`   ✅ Found matching user: ${matchingUser.firstname} ${matchingUser.lastname} (ID: ${matchingUser.user_id})`);

            // Update the doctor's user_id
            const { error: updateError } = await supabaseAdmin
                .from('doctors')
                .update({ user_id: matchingUser.user_id })
                .eq('doctor_id', doctor.doctor_id);

            if (updateError) {
                console.error(`   ❌ Error updating doctor: ${updateError.message}`);
            } else {
                console.log(`   ✅ Updated doctor_id ${doctor.doctor_id} with user_id ${matchingUser.user_id}`);
            }
        } else {
            console.log(`   ⚠️  No matching user found for doctor_id ${doctor.doctor_id}`);
        }
    }

    console.log('\n🎉 Fix completed!');
}

// Run the fix
fixDoctorUserLinks().then(() => {
    console.log('Done!');
    process.exit(0);
}).catch(err => {
    console.error('Fatal error:', err);
    process.exit(1);
});
