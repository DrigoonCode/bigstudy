-- ============================================================
-- BigStudy Platform - FIXED Setup Script for Supabase
-- Run this ENTIRE script in the Supabase SQL Editor
-- Go to: https://supabase.com/dashboard/project/tidxcichacbuyweegywz/sql/new
-- ============================================================

-- Drop existing tables if they exist (clean slate)
DROP TABLE IF EXISTS exam_cutoffs CASCADE;
DROP TABLE IF EXISTS admission_timeline CASCADE;
DROP TABLE IF EXISTS applications CASCADE;
DROP TABLE IF EXISTS user_favorites CASCADE;
DROP TABLE IF EXISTS college_reviews CASCADE;
DROP TABLE IF EXISTS testimonials CASCADE;
DROP TABLE IF EXISTS college_courses CASCADE;
DROP TABLE IF EXISTS college_specializations CASCADE;
DROP TABLE IF EXISTS entrance_exams CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS colleges CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================================
-- 1. Users Table (compatible with Supabase Auth)
--    Note: NO password_hash - Supabase Auth handles password internally
-- ============================================================
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) UNIQUE NOT NULL,
  full_name VARCHAR(255),
  phone VARCHAR(20),
  state VARCHAR(100),
  city VARCHAR(100),
  stream VARCHAR(100),
  target_exam VARCHAR(100),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- 2. Colleges Table
-- ============================================================
CREATE TABLE colleges (
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
  avg_package DECIMAL(12, 2),
  highest_package DECIMAL(12, 2),
  logo_url VARCHAR(500),
  banner_image_url VARCHAR(500),
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_verified BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- 3. Courses Table
-- ============================================================
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50),
  stream VARCHAR(100) NOT NULL,
  duration_months INT,
  qualification_level VARCHAR(100),
  description TEXT,
  career_prospects TEXT,
  avg_fees DECIMAL(12, 2),
  eligibility_criteria TEXT,
  rating DECIMAL(3, 2) DEFAULT 0.0,
  review_count INT DEFAULT 0,
  icon_url VARCHAR(500),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- 4. College Specializations
-- ============================================================
CREATE TABLE college_specializations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  specialization VARCHAR(255) NOT NULL,
  duration_years INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- 5. College Courses Mapping
-- ============================================================
CREATE TABLE college_courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  fees DECIMAL(12, 2),
  seats INT,
  cutoff_score DECIMAL(5, 2),
  course_duration_months INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(college_id, course_id)
);

-- ============================================================
-- 6. Entrance Exams Table
-- ============================================================
CREATE TABLE entrance_exams (
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
  exam_fee DECIMAL(12, 2),
  official_website VARCHAR(500),
  conducting_body VARCHAR(255),
  total_seats INT,
  description TEXT,
  icon_url VARCHAR(500),
  difficulty_level VARCHAR(50),
  duration_minutes INT,
  total_marks INT,
  sections TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- 7. Exam Cutoffs
-- ============================================================
CREATE TABLE exam_cutoffs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  exam_id UUID NOT NULL REFERENCES entrance_exams(id) ON DELETE CASCADE,
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  stream VARCHAR(100),
  general_cutoff DECIMAL(5, 2),
  obc_cutoff DECIMAL(5, 2),
  sc_st_cutoff DECIMAL(5, 2),
  year INT DEFAULT 2024,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(college_id, exam_id, course_id, year)
);

-- ============================================================
-- 8. College Reviews
-- ============================================================
CREATE TABLE college_reviews (
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
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- 9. Testimonials
-- ============================================================
CREATE TABLE testimonials (
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
  package DECIMAL(12, 2),
  image_url VARCHAR(500),
  rating INT DEFAULT 5,
  featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- 10. User Favorites
-- ============================================================
CREATE TABLE user_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, college_id)
);

-- ============================================================
-- 11. Applications
-- ============================================================
CREATE TABLE applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  exam_id UUID REFERENCES entrance_exams(id) ON DELETE SET NULL,
  application_status VARCHAR(50) DEFAULT 'pending',
  exam_score DECIMAL(5, 2),
  application_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  submission_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- 12. Admission Timeline
-- ============================================================
CREATE TABLE admission_timeline (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  exam_id UUID REFERENCES entrance_exams(id) ON DELETE SET NULL,
  event_name VARCHAR(255) NOT NULL,
  event_date DATE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================
-- Indexes
-- ============================================================
CREATE INDEX idx_colleges_state ON colleges(state);
CREATE INDEX idx_colleges_nirf_rank ON colleges(nirf_rank);
CREATE INDEX idx_colleges_is_premier ON colleges(is_premier);
CREATE INDEX idx_courses_stream ON courses(stream);
CREATE INDEX idx_college_courses_college_id ON college_courses(college_id);
CREATE INDEX idx_college_courses_course_id ON college_courses(course_id);
CREATE INDEX idx_entrance_exams_exam_type ON entrance_exams(exam_type);
CREATE INDEX idx_reviews_college_id ON college_reviews(college_id);
CREATE INDEX idx_user_favorites_user_id ON user_favorites(user_id);
CREATE INDEX idx_applications_user_id ON applications(user_id);
CREATE INDEX idx_testimonials_featured ON testimonials(featured);

-- ============================================================
-- Row Level Security
-- ============================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE college_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE colleges ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE entrance_exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE college_specializations ENABLE ROW LEVEL SECURITY;
ALTER TABLE college_courses ENABLE ROW LEVEL SECURITY;

-- Public read access (anyone can browse colleges, courses, exams)
CREATE POLICY "Public can read colleges" ON colleges FOR SELECT USING (TRUE);
CREATE POLICY "Public can read courses" ON courses FOR SELECT USING (TRUE);
CREATE POLICY "Public can read exams" ON entrance_exams FOR SELECT USING (TRUE);
CREATE POLICY "Public can read testimonials" ON testimonials FOR SELECT USING (TRUE);
CREATE POLICY "Public can read college_specializations" ON college_specializations FOR SELECT USING (TRUE);
CREATE POLICY "Public can read college_courses" ON college_courses FOR SELECT USING (TRUE);

-- Users table: users can see/edit their own; service role (used during signup) can insert
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON users FOR INSERT WITH CHECK (auth.uid() = id);

-- Reviews: anyone can read, authenticated can write
CREATE POLICY "Anyone can read reviews" ON college_reviews FOR SELECT USING (TRUE);
CREATE POLICY "Authenticated users can create reviews" ON college_reviews FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Favorites: users manage their own
CREATE POLICY "Users can manage their own favorites" ON user_favorites FOR ALL USING (auth.uid() = user_id);

-- Applications: users manage their own
CREATE POLICY "Users can manage their own applications" ON applications FOR ALL USING (auth.uid() = user_id);

-- ============================================================
-- SEED DATA - Colleges
-- ============================================================
INSERT INTO colleges (name, abbreviation, nirf_rank, nirf_rank_year, state, city, affiliation, founded_year, is_premier, rating, review_count, placement_percentage, avg_package, highest_package, description)
VALUES
  ('Indian Institute of Technology Delhi', 'IIT Delhi', 4, 2025, 'Delhi', 'Delhi', 'Central Govt. Autonomous', 1961, TRUE, 4.8, 245, 98.5, 25.5, 75.0, 'Premier technical institution offering world-class engineering and management programs'),
  ('Indian Institute of Technology Bombay', 'IIT Bombay', 3, 2025, 'Maharashtra', 'Mumbai', 'Central Govt. Autonomous', 1958, TRUE, 4.9, 312, 99.0, 28.0, 80.0, 'Top-ranked IIT known for excellent placements and research opportunities'),
  ('Indian Institute of Technology Madras', 'IIT Madras', 2, 2025, 'Tamil Nadu', 'Chennai', 'Central Govt. Autonomous', 1959, TRUE, 4.9, 289, 98.8, 26.5, 78.0, 'Oldest IIT with strong industry connections and innovation ecosystem'),
  ('Indian Institute of Technology Kanpur', 'IIT Kanpur', 5, 2025, 'Uttar Pradesh', 'Kanpur', 'Central Govt. Autonomous', 1959, TRUE, 4.7, 178, 97.5, 23.0, 72.0, 'Leading technical institution with excellent faculty and research'),
  ('Amity University', 'Amity', 151, 2025, 'Maharashtra', 'Mumbai', 'UGC Recognized', 1992, FALSE, 3.9, 156, 85.0, 12.5, 45.0, 'Multi-campus university offering diverse undergraduate and postgraduate programs'),
  ('Alliance University', 'Alliance', 1, 2025, 'Karnataka', 'Bangalore', 'Private Autonomous', 2006, FALSE, 4.2, 134, 88.0, 15.0, 50.0, 'Premier private university with strong focus on engineering and management'),
  ('Delhi University', 'DU', 50, 2025, 'Delhi', 'Delhi', 'Central Govt. Autonomous', 1922, TRUE, 4.1, 267, 75.0, 8.5, 35.0, 'Historic institution offering diverse academic programs with strong alumni network'),
  ('Rajasthan University', 'RU', 278, 2025, 'Rajasthan', 'Jaipur', 'State Govt. Autonomous', 1949, FALSE, 3.6, 92, 68.0, 7.0, 30.0, 'Traditional university with strong humanities and science programs'),
  ('Jadavpur University', 'JU', 12, 2025, 'West Bengal', 'Kolkata', 'State Govt. Autonomous', 1955, TRUE, 4.5, 198, 92.0, 18.0, 55.0, 'Premier state university with excellent engineering and science programs'),
  ('National Institute of Technology Trichy', 'NIT Trichy', 9, 2025, 'Tamil Nadu', 'Tiruchirappalli', 'Central Govt. Autonomous', 1964, TRUE, 4.6, 215, 95.0, 20.0, 60.0, 'Top NIT with outstanding placements and industry linkages');

-- ============================================================
-- SEED DATA - Courses
-- ============================================================
INSERT INTO courses (name, code, stream, duration_months, qualification_level, description, career_prospects, avg_fees, eligibility_criteria, rating, review_count)
VALUES
  ('Bachelor of Technology in Computer Science', 'B.Tech CS', 'Engineering', 48, 'Bachelors', 'Comprehensive program covering algorithms, databases, software engineering, AI, and web development', 'Software Engineer, Data Scientist, System Architect', 450000, '12th pass with Mathematics and Physics', 4.7, 564),
  ('Bachelor of Technology in Mechanical Engineering', 'B.Tech ME', 'Engineering', 48, 'Bachelors', 'Focus on mechanical systems, thermal engineering, and manufacturing processes', 'Mechanical Engineer, Design Engineer, Manufacturing Specialist', 400000, '12th pass with Mathematics and Physics', 4.5, 421),
  ('Bachelor of Technology in Electrical Engineering', 'B.Tech EE', 'Engineering', 48, 'Bachelors', 'Study of electrical systems, power generation, and control systems', 'Electrical Engineer, Power Systems Engineer, Automation Specialist', 380000, '12th pass with Mathematics and Physics', 4.4, 387),
  ('Bachelor of Technology in Civil Engineering', 'B.Tech CE', 'Engineering', 48, 'Bachelors', 'Infrastructure design, construction management, and urban planning', 'Civil Engineer, Project Manager, Structural Designer', 350000, '12th pass with Mathematics and Physics', 4.3, 345),
  ('Master of Technology in Computer Science', 'M.Tech CS', 'Engineering', 24, 'Masters', 'Advanced topics in AI, Machine Learning, Cloud Computing, and Cybersecurity', 'Senior Software Engineer, Research Scholar, Tech Lead', 800000, 'B.Tech in relevant field', 4.6, 234),
  ('Bachelor of Commerce', 'B.Com', 'Commerce', 36, 'Bachelors', 'Fundamentals of accounting, finance, taxation, and business management', 'Accountant, Financial Analyst, Tax Consultant', 200000, '12th pass with any stream', 4.0, 289),
  ('Bachelor of Business Administration', 'BBA', 'Management', 36, 'Bachelors', 'Management principles, organizational behavior, marketing, and finance', 'Business Manager, Consultant, Entrepreneur', 350000, '12th pass with 50% marks', 4.1, 312),
  ('Master of Business Administration', 'MBA', 'Management', 24, 'Masters', 'Advanced business strategy, finance, HR, and entrepreneurship', 'Senior Manager, Business Analyst, Entrepreneur', 1200000, 'Graduation + work experience preferred', 4.5, 178),
  ('Bachelor of Science in Physics', 'B.Sc Physics', 'Science', 36, 'Bachelors', 'Classical and modern physics, quantum mechanics, and experimental methods', 'Physicist, Research Scientist, Educator', 150000, '12th pass with Physics and Mathematics', 4.2, 198),
  ('Bachelor of Law', 'LLB', 'Law', 36, 'Bachelors', 'Constitutional law, criminal law, contracts, and legal practice', 'Lawyer, Judge, Legal Consultant', 300000, '12th pass or Graduation', 4.2, 167);

-- ============================================================
-- SEED DATA - Entrance Exams
-- ============================================================
INSERT INTO entrance_exams (name, full_form, exam_type, applicable_streams, exam_date, application_start_date, application_end_date, result_date, exam_fee, official_website, conducting_body, total_seats, difficulty_level, duration_minutes, total_marks, description)
VALUES
  ('JEE Main', 'Joint Entrance Examination Main', 'National Engineering Entrance', 'Engineering', '2025-04-15', '2025-01-01', '2025-02-15', '2025-05-15', 650, 'https://www.nta.ac.in/exams/jee-main', 'NTA (National Test Agency)', 1625000, 'Difficult', 180, 300, 'Gateway exam for top engineering colleges in India. Qualifying exam for JEE Advanced.'),
  ('JEE Advanced', 'Joint Entrance Examination Advanced', 'National Engineering Entrance', 'Engineering', '2025-06-01', '2025-05-01', '2025-05-15', '2025-07-01', 2800, 'https://www.jeeadv.ac.in', 'IIT Kanpur', 17500, 'Very Difficult', 240, 360, 'Elite engineering exam for admission to Indian Institute of Technology (IITs).'),
  ('NEET', 'National Eligibility Entrance Test', 'Medical Entrance', 'Medical', '2025-05-04', '2025-01-15', '2025-02-10', '2025-06-15', 1600, 'https://exams.nta.ac.in/neet', 'NTA (National Test Agency)', 1500000, 'Difficult', 180, 720, 'National level examination for admission to medical colleges in India.'),
  ('GATE', 'Graduate Aptitude Test in Engineering', 'Post-Graduate Engineering Entrance', 'Engineering', '2025-02-01', '2024-09-01', '2024-10-15', '2025-03-15', 1800, 'https://gate.iisc.ac.in', 'IIT Bombay', 25000, 'Difficult', 180, 1000, 'Post-graduate entrance exam for engineering studies and public sector job recruitment.'),
  ('CAT', 'Common Admission Test', 'MBA Entrance', 'Management', '2025-11-23', '2025-08-01', '2025-09-26', '2025-12-28', 2300, 'https://www.iimcat.ac.in', 'IIM (Indian Institute of Management)', 200000, 'Very Difficult', 120, 300, 'Entrance exam for admission to prestigious MBA programs at top IIMs.'),
  ('CLAT', 'Common Law Admission Test', 'Law Entrance', 'Law', '2025-12-14', '2025-09-15', '2025-10-31', '2025-12-31', 4000, 'https://www.clat.ac.in', 'National Law Universities', 10000, 'Moderate', 120, 150, 'National level law entrance exam for undergraduate and postgraduate law programs.'),
  ('CUET', 'Common University Entrance Test', 'Undergraduate Entrance', 'Engineering,Commerce,Science', '2025-05-15', '2025-04-01', '2025-04-30', '2025-06-30', 800, 'https://cuet.nta.nic.in', 'NTA', 500000, 'Moderate', 180, 600, 'Gateway exam for admission to Delhi University and other central universities.'),
  ('BITSAT', 'BITS Admission Test', 'University Entrance', 'Engineering', '2025-05-01', '2025-01-01', '2025-04-15', '2025-06-30', 2750, 'https://www.bitsadmission.com', 'BITS Pilani', 2500, 'Difficult', 180, 450, 'Entrance exam for admission to BITS Pilani, BITS Goa, and BITS Hyderabad campuses.');

-- ============================================================
-- Testimonials seed data
-- ============================================================
INSERT INTO testimonials (user_name, user_location, title, quote, placement_status, company_name, package, rating, featured)
VALUES
  ('Aarav Sharma', 'Mumbai, Maharashtra', 'Life-Changing Experience', 'My time at IIT was transformative. The rigorous curriculum and industry connections opened doors I never imagined.', 'Placed', 'Google', 45.0, 5, TRUE),
  ('Riya Patel', 'Delhi', 'Excellent Academic Support', 'The faculty is world-class. They truly care about student development and future career prospects.', 'Placed', 'Microsoft', 42.0, 5, TRUE),
  ('Priya Singh', 'Bangalore, Karnataka', 'Career Success Story', 'The placement cell actively supports student recruitment. Got placed in a great company!', 'Placed', 'Infosys', 18.0, 4, TRUE),
  ('Vikram Kumar', 'Pune, Maharashtra', 'Management Excellence', 'The MBA program provides excellent business insights and networking with industry leaders.', 'Placed', 'Deloitte', 28.0, 5, TRUE),
  ('Aisha Khan', 'Hyderabad, Telangana', 'Dream Come True', 'Cracking NEET and getting into a top medical college was my dream. BigStudy helped me find the right path.', 'Placed', 'Apollo Hospitals', 12.0, 5, TRUE),
  ('Rahul Mehta', 'Chennai, Tamil Nadu', 'Outstanding Research Opportunities', 'The research facilities and mentor support at NIT were exceptional for my M.Tech journey.', 'Placed', 'ISRO', 22.0, 5, TRUE);

-- ============================================================
-- College-Course mappings
-- ============================================================
INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT c.id, co.id, 450000, 120, 99.0, 48
FROM colleges c, courses co
WHERE c.abbreviation = 'IIT Delhi' AND co.code = 'B.Tech CS';

INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT c.id, co.id, 450000, 100, 98.0, 48
FROM colleges c, courses co
WHERE c.abbreviation = 'IIT Bombay' AND co.code = 'B.Tech CS';

INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT c.id, co.id, 250000, 200, 85.0, 48
FROM colleges c, courses co
WHERE c.abbreviation = 'Amity' AND co.code = 'B.Tech CS';

INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT c.id, co.id, 1200000, 60, 95.0, 24
FROM colleges c, courses co
WHERE c.abbreviation = 'Alliance' AND co.code = 'MBA';

-- Verify data was inserted correctly
SELECT 'colleges' as table_name, COUNT(*) as row_count FROM colleges
UNION ALL SELECT 'courses', COUNT(*) FROM courses
UNION ALL SELECT 'entrance_exams', COUNT(*) FROM entrance_exams
UNION ALL SELECT 'testimonials', COUNT(*) FROM testimonials;
