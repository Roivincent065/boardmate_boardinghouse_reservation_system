-- Supabase RLS policies for Boardmate
-- Run these in Supabase SQL editor (Database → New Query)

-- Enable Row Level Security on tables (if not already enabled)
ALTER TABLE IF EXISTS profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS messages ENABLE ROW LEVEL SECURITY;

-- PROFILES
-- Allow authenticated users to insert their own profile
CREATE POLICY IF NOT EXISTS "Allow insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Allow users to select their own profile
CREATE POLICY IF NOT EXISTS "Allow select own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY IF NOT EXISTS "Allow update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Optionally allow authenticated users to list profiles (remove if sensitive)
CREATE POLICY IF NOT EXISTS "Allow select for authenticated"
  ON profiles FOR SELECT
  USING (auth.role() = 'authenticated');


-- ROOMS
-- Allow anyone (authenticated) to read room listings
CREATE POLICY IF NOT EXISTS "Allow select rooms for authenticated"
  ON rooms FOR SELECT
  USING (auth.role() = 'authenticated');

-- Allow a landlord to insert a room where landlord_id matches their uid
CREATE POLICY IF NOT EXISTS "Allow insert room by landlord"
  ON rooms FOR INSERT
  WITH CHECK (auth.uid() = landlord_id);

-- Allow landlord to update/delete their own room
CREATE POLICY IF NOT EXISTS "Allow modify own room"
  ON rooms FOR UPDATE, DELETE
  USING (auth.uid() = landlord_id)
  WITH CHECK (auth.uid() = landlord_id);


-- MESSAGES
-- Allow sender to insert messages where sender_id is their uid
CREATE POLICY IF NOT EXISTS "Allow insert message by sender"
  ON messages FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

-- Allow participants (sender or receiver) to read messages
CREATE POLICY IF NOT EXISTS "Allow select messages for participants"
  ON messages FOR SELECT
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Allow sender to delete their own messages (optional)
CREATE POLICY IF NOT EXISTS "Allow delete own message"
  ON messages FOR DELETE
  USING (auth.uid() = sender_id);

-- Notes:
-- - Avoid using the service_role key in client apps. Use it only for trusted server-side operations.
-- - After running these, test authenticated requests from the client. If you need broader access for testing,
--   you can temporarily set permissive policies but lock them down before production.
