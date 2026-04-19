-- BigStudy Platform Database Schema
-- Complete database setup for colleges, courses, exams, users, and applications

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255),
  phone VARCHAR(20),
  state VARCHAR(100),
  city VARCHAR(100),
  stream VARCHAR(100),
  target_exam VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE
);

-- 2. Colleges Table (3000+ colleges)
CREATE TABLE IF NOT EXISTS colleges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  abbreviation VARCHAR(50),
  nirf_rank INT,
  nirf_rank_year INT DEFAULT 2025,
  rating DECIMAL(3, 2) DEFAULT 0.0,
  review_count INT DEFAULT 0,
  state VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  affiliation VARCHAR(255),
  founded_year INT,
  is_premier BOOLEAN DEFAULT FALSE,
  website_url VARCHAR(500),
  contact_phone VARCHAR(20),
  contact_email VARCHAR(255),
  admission_process TEXT,
  placement_percentage DECIMAL(5, 2),
  avg_package DECIMAL(8, 2),
  highest_package DECIMAL(8, 2),
  logo_url VARCHAR(500),
  banner_image_url VARCHAR(500),
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_verified BOOLEAN DEFAULT TRUE
);

-- 3. Streams/Specializations for Colleges
CREATE TABLE IF NOT EXISTS college_specializations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  specialization VARCHAR(255) NOT NULL,
  duration_years INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Courses Table
CREATE TABLE IF NOT EXISTS courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50),
  stream VARCHAR(100) NOT NULL,
  duration_months INT,
  qualification_level VARCHAR(100),
  description TEXT,
  career_prospects TEXT,
  avg_fees DECIMAL(8, 2),
  eligibility_criteria TEXT,
  rating DECIMAL(3, 2) DEFAULT 0.0,
  review_count INT DEFAULT 0,
  icon_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. College Courses Mapping
CREATE TABLE IF NOT EXISTS college_courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  fees DECIMAL(8, 2),
  seats INT,
  cutoff_score DECIMAL(5, 2),
  course_duration_months INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(college_id, course_id)
);

-- 6. Entrance Exams Table
CREATE TABLE IF NOT EXISTS entrance_exams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  full_form VARCHAR(255),
  exam_type VARCHAR(100),
  applicable_streams TEXT,
  exam_date DATE,
  application_start_date DATE,
  application_end_date DATE,
  result_date DATE,
  eligibility_criteria TEXT,
  exam_fee DECIMAL(8, 2),
  official_website VARCHAR(500),
  conducting_body VARCHAR(255),
  total_seats INT,
  description TEXT,
  icon_url VARCHAR(500),
  difficulty_level VARCHAR(50),
  duration_minutes INT,
  total_marks INT,
  sections TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Exam Cutoffs for Colleges
CREATE TABLE IF NOT EXISTS exam_cutoffs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  exam_id UUID NOT NULL REFERENCES entrance_exams(id) ON DELETE CASCADE,
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  stream VARCHAR(100),
  general_cutoff DECIMAL(5, 2),
  obc_cutoff DECIMAL(5, 2),
  sc_st_cutoff DECIMAL(5, 2),
  year INT DEFAULT 2024,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(college_id, exam_id, course_id, year)
);

-- 8. User Reviews & Testimonials
CREATE TABLE IF NOT EXISTS college_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  rating INT CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(255),
  comment TEXT,
  pros TEXT,
  cons TEXT,
  verified_student BOOLEAN DEFAULT FALSE,
  helpful_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Testimonials/Success Stories
CREATE TABLE IF NOT EXISTS testimonials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_name VARCHAR(255) NOT NULL,
  user_location VARCHAR(255),
  college_id UUID REFERENCES colleges(id) ON DELETE SET NULL,
  course_id UUID REFERENCES courses(id) ON DELETE SET NULL,
  exam_id UUID REFERENCES entrance_exams(id) ON DELETE SET NULL,
  title VARCHAR(255),
  quote TEXT,
  placement_status VARCHAR(100),
  company_name VARCHAR(255),
  package DECIMAL(8, 2),
  image_url VARCHAR(500),
  rating INT DEFAULT 5,
  featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. User Favorite Colleges
CREATE TABLE IF NOT EXISTS user_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, college_id)
);

-- 11. User Applications
CREATE TABLE IF NOT EXISTS applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  exam_id UUID REFERENCES entrance_exams(id) ON DELETE SET NULL,
  application_status VARCHAR(50) DEFAULT 'pending',
  exam_score DECIMAL(5, 2),
  application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  submission_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. Admissions Timeline
CREATE TABLE IF NOT EXISTS admission_timeline (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  exam_id UUID REFERENCES entrance_exams(id) ON DELETE SET NULL,
  event_name VARCHAR(255) NOT NULL,
  event_date DATE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_colleges_state ON colleges(state);
CREATE INDEX IF NOT EXISTS idx_colleges_nirf_rank ON colleges(nirf_rank);
CREATE INDEX IF NOT EXISTS idx_colleges_is_premier ON colleges(is_premier);
CREATE INDEX IF NOT EXISTS idx_courses_stream ON courses(stream);
CREATE INDEX IF NOT EXISTS idx_college_courses_college_id ON college_courses(college_id);
CREATE INDEX IF NOT EXISTS idx_college_courses_course_id ON college_courses(course_id);
CREATE INDEX IF NOT EXISTS idx_entrance_exams_exam_type ON entrance_exams(exam_type);
CREATE INDEX IF NOT EXISTS idx_reviews_college_id ON college_reviews(college_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON user_favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_applications_user_id ON applications(user_id);
CREATE INDEX IF NOT EXISTS idx_testimonials_featured ON testimonials(featured);

-- Enable RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE college_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users (can view own profile)
CREATE POLICY "Users can view their own profile" ON users
  FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "Users can update their own profile" ON users
  FOR UPDATE USING (auth.uid()::text = id::text);

-- RLS Policies for reviews (anyone can read, authenticated users can write)
CREATE POLICY "Anyone can read reviews" ON college_reviews
  FOR SELECT USING (TRUE);

CREATE POLICY "Authenticated users can create reviews" ON college_reviews
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- RLS Policies for favorites
CREATE POLICY "Users can manage their own favorites" ON user_favorites
  FOR ALL USING (auth.uid()::text = user_id::text);

-- RLS Policies for applications
CREATE POLICY "Users can manage their own applications" ON applications
  FOR ALL USING (auth.uid()::text = user_id::text);
