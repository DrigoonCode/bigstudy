-- BigStudy Platform - Seed Data with Real Indian Colleges and Exams
-- Sample of top Indian colleges, courses, and entrance exams

-- Insert Top Premier Colleges (NIRF Top 50)
INSERT INTO colleges (name, abbreviation, nirf_rank, nirf_rank_year, state, city, affiliation, founded_year, is_premier, rating, review_count, placement_percentage, avg_package, highest_package, description) 
VALUES 
  ('Indian Institute of Technology Delhi', 'IIT Delhi', 4, 2025, 'Delhi', 'Delhi', 'Central Govt. Autonomous', 1961, TRUE, 4.8, 245, 98.5, 25.5, 75.0, 'Premier technical institution offering world-class engineering and management programs'),
  ('Indian Institute of Technology Bombay', 'IIT Bombay', 3, 2025, 'Maharashtra', 'Mumbai', 'Central Govt. Autonomous', 1958, TRUE, 4.9, 312, 99.0, 28.0, 80.0, 'Top-ranked IIT known for excellent placements and research opportunities'),
  ('Indian Institute of Technology Madras', 'IIT Madras', 2, 2025, 'Tamil Nadu', 'Chennai', 'Central Govt. Autonomous', 1959, TRUE, 4.9, 289, 98.8, 26.5, 78.0, 'Oldest IIT with strong industry connections and innovation ecosystem'),
  ('Indian Institute of Technology Kanpur', 'IIT Kanpur', 5, 2025, 'Uttar Pradesh', 'Kanpur', 'Central Govt. Autonomous', 1959, TRUE, 4.7, 178, 97.5, 23.0, 72.0, 'Leading technical institution with excellent faculty and research'),
  ('Amity University', 'Amity', 151, 2025, 'Maharashtra', 'Mumbai', 'UGC Recognized', 1992, FALSE, 3.9, 156, 85.0, 12.5, 45.0, 'Multi-campus university offering diverse undergraduate and postgraduate programs'),
  ('Alliance University', 'AUB', 1, 2025, 'Karnataka', 'Bangalore', 'Private Autonomous', 2006, FALSE, 4.2, 134, 88.0, 15.0, 50.0, 'Premier private university with strong focus on engineering and management'),
  ('Delhi University', 'DU', 50, 2025, 'Delhi', 'Delhi', 'Central Govt. Autonomous', 1922, TRUE, 4.1, 267, 75.0, 8.5, 35.0, 'Historic institution offering diverse academic programs with strong alumni network'),
  ('Madhya Pradesh University of Agriculture and Technology', 'MPUAT', 122, 2025, 'Madhya Pradesh', 'Indore', 'State Govt. Autonomous', 1997, FALSE, 3.7, 89, 70.0, 6.5, 25.0, 'Specialized institution for agricultural and technology education'),
  ('Centaurion University of Technology and Management', 'CUTM', 300, 2025, 'Odisha', 'Bhubaneswar', 'Private Autonomous', 2002, FALSE, 3.5, 67, 75.0, 10.0, 40.0, 'Private university offering engineering, commerce, and management courses'),
  ('Rajasthan University', 'RU', 278, 2025, 'Rajasthan', 'Jaipur', 'State Govt. Autonomous', 1949, FALSE, 3.6, 92, 68.0, 7.0, 30.0, 'Traditional university with strong humanities and science programs');

-- Insert Courses
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
  ('Bachelor of Science in Chemistry', 'B.Sc Chemistry', 'Science', 36, 'Bachelors', 'Organic, inorganic, and physical chemistry with lab work', 'Chemist, Pharmaceutical Analyst, Chemical Engineer', 140000, '12th pass with Chemistry and Mathematics', 4.1, 176),
  ('Bachelor of Science in Biology', 'B.Sc Biology', 'Science', 36, 'Bachelors', 'Molecular biology, genetics, ecology, and microbiology', 'Biologist, Research Scientist, Medical Professional', 160000, '12th pass with Biology and Chemistry', 4.3, 201),
  ('Bachelor of Law', 'LLB', 'Law', 36, 'Bachelors', 'Constitutional law, criminal law, contracts, and legal practice', 'Lawyer, Judge, Legal Consultant', 300000, '12th pass or Graduation', 4.2, 167);

-- Insert Entrance Exams
INSERT INTO entrance_exams (name, full_form, exam_type, applicable_streams, exam_date, application_start_date, application_end_date, result_date, exam_fee, official_website, conducting_body, total_seats, difficulty_level, duration_minutes, total_marks, description)
VALUES
  ('JEE Main', 'Joint Entrance Examination Main', 'National Engineering Entrance', 'Engineering', '2025-04-15'::DATE, '2025-01-01'::DATE, '2025-02-15'::DATE, '2025-05-15'::DATE, 650, 'https://www.nta.ac.in/exams/jee-main', 'NTA (National Test Agency)', 1625000, 'Difficult', 180, 300, 'Gateway exam for top engineering colleges in India. Qualifying exam for JEE Advanced and NEET.'),
  ('JEE Advanced', 'Joint Entrance Examination Advanced', 'National Engineering Entrance', 'Engineering', '2025-06-01'::DATE, '2025-05-01'::DATE, '2025-05-15'::DATE, '2025-07-01'::DATE, 2800, 'https://www.jeeadv.ac.in', 'IIT Kanpur', 17500, 'Very Difficult', 240, 360, 'Elite engineering exam for admission to Indian Institute of Technology (IITs).'),
  ('NEET', 'National Eligibility Entrance Test', 'Medical Entrance', 'Medical', '2025-05-04'::DATE, '2025-01-15'::DATE, '2025-02-10'::DATE, '2025-06-15'::DATE, 1600, 'https://exams.nta.ac.in/neet', 'NTA (National Test Agency)', 1500000, 'Difficult', 180, 720, 'National level examination for admission to medical colleges and dental colleges in India.'),
  ('GATE', 'Graduate Aptitude Test in Engineering', 'Post-Graduate Engineering Entrance', 'Engineering', '2025-02-01'::DATE, '2024-09-01'::DATE, '2024-10-15'::DATE, '2025-03-15'::DATE, 1800, 'https://gate.iisc.ac.in', 'IIT Bombay', 25000, 'Difficult', 180, 1000, 'Post-graduate entrance exam for engineering studies and public sector job recruitment.'),
  ('CAT', 'Common Admission Test', 'MBA Entrance', 'Management', '2025-11-23'::DATE, '2025-08-01'::DATE, '2025-09-26'::DATE, '2025-12-28'::DATE, 2300, 'https://www.iimcat.ac.in', 'IIM (Indian Institute of Management)', 200000, 'Very Difficult', 120, 300, 'Entrance exam for admission to prestigious MBA programs at top IIMs and other business schools.'),
  ('CLAT', 'Common Law Admission Test', 'Law Entrance', 'Law', '2025-12-14'::DATE, '2025-09-15'::DATE, '2025-10-31'::DATE, '2025-12-31'::DATE, 4000, 'https://www.clat.ac.in', 'National Law Universities', 10000, 'Moderate', 120, 150, 'National level law entrance exam for undergraduate and postgraduate law programs.'),
  ('CUET', 'Common University Entrance Test', 'Undergraduate Entrance', 'Engineering,Commerce,Science', '2025-05-15'::DATE, '2025-04-01'::DATE, '2025-04-30'::DATE, '2025-06-30'::DATE, 800, 'https://cuet.samakondu.ac.in', 'NTA', 500000, 'Moderate', 180, 600, 'Gateway exam for admission to Delhi University and other central universities.'),
  ('BITSAT', 'BITS Admission Test', 'University Entrance', 'Engineering', '2025-05-01'::DATE, '2025-01-01'::DATE, '2025-04-15'::DATE, '2025-06-30'::DATE, 2750, 'https://www.bitsadmission.com', 'BITS Pilani', 2500, 'Difficult', 180, 450, 'Entrance exam for admission to BITS Pilani, BITS Goa, and BITS Hyderabad campuses.');

-- Insert College Specializations
INSERT INTO college_specializations (college_id, specialization, duration_years)
SELECT id, 'Computer Science and Engineering', 4 FROM colleges WHERE abbreviation = 'IIT Delhi'
UNION ALL
SELECT id, 'Mechanical Engineering', 4 FROM colleges WHERE abbreviation = 'IIT Delhi'
UNION ALL
SELECT id, 'Electrical Engineering', 4 FROM colleges WHERE abbreviation = 'IIT Delhi'
UNION ALL
SELECT id, 'Civil Engineering', 4 FROM colleges WHERE abbreviation = 'IIT Delhi'
UNION ALL
SELECT id, 'Engineering', 4 FROM colleges WHERE abbreviation = 'Amity'
UNION ALL
SELECT id, 'Commerce', 3 FROM colleges WHERE abbreviation = 'Amity'
UNION ALL
SELECT id, 'Management', 2 FROM colleges WHERE abbreviation = 'Amity'
UNION ALL
SELECT id, 'Computer Science and Engineering', 4 FROM colleges WHERE abbreviation = 'IIT Bombay'
UNION ALL
SELECT id, 'Electronics Engineering', 4 FROM colleges WHERE abbreviation = 'IIT Bombay'
UNION ALL
SELECT id, 'Engineering', 4 FROM colleges WHERE abbreviation = 'Alliance'
UNION ALL
SELECT id, 'Management', 2 FROM colleges WHERE abbreviation = 'Alliance';

-- Insert Sample Testimonials
INSERT INTO testimonials (user_name, user_location, college_id, course_id, exam_id, title, quote, placement_status, company_name, package, rating, featured)
SELECT 
  'Aarav Sharma', 'Mumbai', colleges.id, courses.id, exams.id,
  'Life-Changing Experience',
  'My time at IIT Delhi was transformative. The rigorous curriculum and industry connections opened doors I never imagined.',
  'Placed', 'Google', 45.0, 5, TRUE
FROM colleges, courses, entrance_exams exams
WHERE colleges.abbreviation = 'IIT Delhi' AND courses.code = 'B.Tech CS' AND exams.name = 'JEE Advanced'
LIMIT 1;

INSERT INTO testimonials (user_name, user_location, college_id, course_id, exam_id, title, quote, placement_status, company_name, package, rating, featured)
SELECT 
  'Riya Patel', 'Delhi', colleges.id, courses.id, exams.id,
  'Excellent Academic Support',
  'The faculty at this institution is world-class. They truly care about student development and future career prospects.',
  'Placed', 'Microsoft', 42.0, 5, TRUE
FROM colleges, courses, entrance_exams exams
WHERE colleges.abbreviation = 'IIT Bombay' AND courses.code = 'B.Tech CS' AND exams.name = 'JEE Advanced'
LIMIT 1;

INSERT INTO testimonials (user_name, user_location, college_id, course_id, exam_id, title, quote, placement_status, company_name, package, rating, featured)
SELECT 
  'Priya Singh', 'Bangalore', colleges.id, courses.id, exams.id,
  'Career Success Story',
  'Amity University prepared me well for industry challenges. The placement cell actively supports student recruitment.',
  'Placed', 'Infosys', 18.0, 4, TRUE
FROM colleges, courses, entrance_exams exams
WHERE colleges.abbreviation = 'Amity' AND courses.code = 'B.Tech CS' AND exams.name = 'JEE Main'
LIMIT 1;

INSERT INTO testimonials (user_name, user_location, college_id, course_id, exam_id, title, quote, placement_status, company_name, package, rating, featured)
SELECT 
  'Vikram Kumar', 'Pune', colleges.id, courses.id, exams.id,
  'Management Excellence',
  'The MBA program provides excellent business insights and networking opportunities with industry leaders.',
  'Placed', 'Deloitte', 28.0, 5, TRUE
FROM colleges, courses, entrance_exams exams
WHERE colleges.abbreviation = 'Alliance' AND courses.code = 'MBA' AND exams.name = 'CAT'
LIMIT 1;

-- Insert sample exam cutoffs for premier colleges
INSERT INTO exam_cutoffs (college_id, exam_id, course_id, stream, general_cutoff, obc_cutoff, sc_st_cutoff, year)
SELECT 
  colleges.id, exams.id, courses.id, 'General',
  99.5, 98.0, 95.0, 2024
FROM colleges, entrance_exams exams, courses
WHERE colleges.abbreviation = 'IIT Delhi' AND exams.name = 'JEE Advanced' AND courses.code = 'B.Tech CS'
LIMIT 1;

INSERT INTO exam_cutoffs (college_id, exam_id, course_id, stream, general_cutoff, obc_cutoff, sc_st_cutoff, year)
SELECT 
  colleges.id, exams.id, courses.id, 'General',
  98.8, 97.5, 94.0, 2024
FROM colleges, entrance_exams exams, courses
WHERE colleges.abbreviation = 'IIT Bombay' AND exams.name = 'JEE Advanced' AND courses.code = 'B.Tech CS'
LIMIT 1;

-- Insert college-course mappings
INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT colleges.id, courses.id, 450000, 120, 99.0, 48
FROM colleges, courses
WHERE colleges.abbreviation = 'IIT Delhi' AND courses.code = 'B.Tech CS'
LIMIT 1;

INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT colleges.id, courses.id, 450000, 100, 98.0, 48
FROM colleges, courses
WHERE colleges.abbreviation = 'IIT Bombay' AND courses.code = 'B.Tech CS'
LIMIT 1;

INSERT INTO college_courses (college_id, course_id, fees, seats, cutoff_score, course_duration_months)
SELECT colleges.id, courses.id, 250000, 200, 85.0, 48
FROM colleges, courses
WHERE colleges.abbreviation = 'Amity' AND courses.code = 'B.Tech CS'
LIMIT 1;
