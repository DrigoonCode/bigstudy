-- ============================================================
-- DB Update: Allow general applications & profile documents
-- Run this in Supabase SQL Editor
-- ============================================================

-- 1. Make course_id nullable in applications table
ALTER TABLE applications ALTER COLUMN course_id DROP NOT NULL;

-- 2. Add marks and document URLs to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS tenth_marks DECIMAL(5, 2);
ALTER TABLE users ADD COLUMN IF NOT EXISTS twelfth_marks DECIMAL(5, 2);
ALTER TABLE users ADD COLUMN IF NOT EXISTS tenth_marksheet_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS twelfth_marksheet_url VARCHAR(500);
