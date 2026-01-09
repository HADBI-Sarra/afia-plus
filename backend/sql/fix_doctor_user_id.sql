-- Fix missing user_id in doctors table
-- This updates all existing doctor records to set user_id = doctor_id
-- Required for proper joins between doctors and users tables

update doctors
   set
   user_id = doctor_id
 where user_id is null;

-- Verify the fix
select d.doctor_id,
       d.user_id,
       u.firstname,
       u.lastname,
       u.profile_picture
  from doctors d
  left join users u
on d.user_id = u.user_id
 order by d.doctor_id;