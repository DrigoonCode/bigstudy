-- ============================================================
-- BigStudy - Applications & Users RLS Fix
-- Run this in: https://supabase.com/dashboard/project/tidxcichacbuyweegywz/sql/new
-- ============================================================

-- 1. Ensure users table has a row for the current auth user (trigger)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name'
  )
  ON CONFLICT (id) DO UPDATE
    SET email = EXCLUDED.email,
        full_name = COALESCE(EXCLUDED.full_name, public.users.full_name);
  RETURN NEW;
END;
$$;

-- Drop if already exists to avoid duplicate trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ============================================================
-- 2. Enable RLS on core tables
-- ============================================================
ALTER TABLE users        ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 3. users table policies
-- ============================================================
DROP POLICY IF EXISTS "Users can read own profile"  ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;

CREATE POLICY "Users can read own profile"
  ON users FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON users FOR INSERT WITH CHECK (auth.uid() = id);

-- ============================================================
-- 4. applications table policies
-- ============================================================
DROP POLICY IF EXISTS "Users can read own applications"   ON applications;
DROP POLICY IF EXISTS "Users can create own applications" ON applications;

CREATE POLICY "Users can read own applications"
  ON applications FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own applications"
  ON applications FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- 5. user_favorites policies
-- ============================================================
DROP POLICY IF EXISTS "Users can manage own favorites" ON user_favorites;

CREATE POLICY "Users can manage own favorites"
  ON user_favorites FOR ALL USING (auth.uid() = user_id);

-- ============================================================
-- 6. Public read access for colleges, courses, exams
-- ============================================================
ALTER TABLE colleges        ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses         ENABLE ROW LEVEL SECURITY;
ALTER TABLE entrance_exams  ENABLE ROW LEVEL SECURITY;
ALTER TABLE college_courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE college_reviews ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read colleges"        ON colleges;
DROP POLICY IF EXISTS "Anyone can read courses"         ON courses;
DROP POLICY IF EXISTS "Anyone can read exams"           ON entrance_exams;
DROP POLICY IF EXISTS "Anyone can read college_courses" ON college_courses;
DROP POLICY IF EXISTS "Anyone can read reviews"         ON college_reviews;

CREATE POLICY "Anyone can read colleges"        ON colleges        FOR SELECT USING (true);
CREATE POLICY "Anyone can read courses"         ON courses         FOR SELECT USING (true);
CREATE POLICY "Anyone can read exams"           ON entrance_exams  FOR SELECT USING (true);
CREATE POLICY "Anyone can read college_courses" ON college_courses FOR SELECT USING (true);
CREATE POLICY "Anyone can read reviews"         ON college_reviews FOR SELECT USING (true);

-- ============================================================
-- Done! All RLS policies are now set.
-- ============================================================

-- ============================================================
-- 7. Add avatar_url to users table (if not already present)
-- ============================================================
ALTER TABLE users ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS date_of_birth DATE;

-- ============================================================
-- 8. Storage Buckets
-- ============================================================

-- Public bucket: profile avatars
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,
  2097152,   -- 2 MB limit
  ARRAY['image/jpeg','image/png','image/webp','image/gif']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 2097152;

-- Private bucket: application documents (marksheets, certificates)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'documents',
  'documents',
  false,
  10485760,  -- 10 MB limit
  ARRAY['application/pdf','image/jpeg','image/png']
)
ON CONFLICT (id) DO UPDATE SET
  public = false,
  file_size_limit = 10485760;

-- ============================================================
-- 9. Storage Policies — Avatars (public read, user write)
-- ============================================================
DROP POLICY IF EXISTS "Public avatar read"        ON storage.objects;
DROP POLICY IF EXISTS "User can upload avatar"    ON storage.objects;
DROP POLICY IF EXISTS "User can update avatar"    ON storage.objects;
DROP POLICY IF EXISTS "User can delete avatar"    ON storage.objects;

CREATE POLICY "Public avatar read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "User can upload avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "User can update avatar"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "User can delete avatar"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================================
-- 10. Storage Policies — Documents (private, per-user)
-- ============================================================
DROP POLICY IF EXISTS "User manages own documents" ON storage.objects;

CREATE POLICY "User manages own documents"
  ON storage.objects FOR ALL
  USING (
    bucket_id = 'documents'
    AND auth.uid()::text = (storage.foldername(name))[1]
  )
  WITH CHECK (
    bucket_id = 'documents'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================================
-- All done! Buckets: 'avatars' (public) + 'documents' (private)
-- ============================================================
