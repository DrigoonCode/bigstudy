import csv
import random
import math

colleges_input = "c:\\Users\\Piyush\\Downloads\\b_ehpHjzB74Iv\\Colleges_Dataset.csv"
colleges_output = "c:\\Users\\Piyush\\Downloads\\b_ehpHjzB74Iv\\Supabase_Ready_Colleges.csv"

courses_input = "c:\\Users\\Piyush\\Downloads\\b_ehpHjzB74Iv\\Courses_Dataset.csv"
courses_output = "c:\\Users\\Piyush\\Downloads\\b_ehpHjzB74Iv\\Supabase_Ready_Courses.csv"

# 1. PROCESS COLLEGES
print("Processing Colleges...")
affiliations = ["State University Affiliated", "Private Autonomous", "UGC Recognized", "AICTE Approved", "Central University Affiliated"]
college_rows = []

try:
    with open(colleges_input, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            name = row.get('name', '').strip()
            if not name: continue
            
            city = row.get('city', '').strip()
            state = row.get('state', '').strip()
            
            nirf_str = str(row.get('nirfRank', '')).lower()
            if nirf_str == 'nan' or not nirf_str.strip() or not nirf_str.replace('.0', '').isdigit():
                nirf_rank = ''
                is_premier = 'FALSE'
            else:
                nirf_rank = int(float(nirf_str))
                is_premier = 'TRUE' if nirf_rank <= 100 else 'FALSE'
            
            # Generate realistic synthetic data for missing filtering fields
            abbreviation = "".join([word[0] for word in name.split() if word[0].isalpha()]).upper()[:5]
            rating = round(random.uniform(3.4, 4.9), 1)
            review_count = random.randint(12, 450)
            affiliation = random.choice(affiliations)
            founded_year = random.randint(1950, 2012)
            placement_percentage = round(random.uniform(55.0, 99.0), 1)
            
            # Packages logic
            if nirf_rank and type(nirf_rank) == int and nirf_rank < 50:
                avg_package = round(random.uniform(12.0, 25.0), 1)
            elif is_premier == 'TRUE':
                avg_package = round(random.uniform(8.0, 15.0), 1)
            else:
                avg_package = round(random.uniform(3.5, 7.5), 1)
                
            highest_package = round(random.uniform(avg_package * 1.5, avg_package * 5.0), 1)
            
            # Clean descriptions to avoid CSV breakages
            description = f"{name} is a renowned institution located in {city}, {state}. It offers comprehensive higher education programs."

            college_rows.append({
                'name': name,
                'abbreviation': abbreviation,
                'nirf_rank': nirf_rank,
                'nirf_rank_year': '2024' if nirf_rank else '',
                'rating': rating,
                'review_count': review_count,
                'state': state,
                'city': city,
                'affiliation': affiliation,
                'founded_year': founded_year,
                'is_premier': is_premier,
                'placement_percentage': placement_percentage,
                'avg_package': avg_package,
                'highest_package': highest_package,
                'description': description
            })
            
    with open(colleges_output, 'w', encoding='utf-8', newline='') as f:
        fields = ['name', 'abbreviation', 'nirf_rank', 'nirf_rank_year', 'rating', 'review_count', 'state', 'city', 'affiliation', 'founded_year', 'is_premier', 'placement_percentage', 'avg_package', 'highest_package', 'description']
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(college_rows)
    print(f"Successfully wrote {len(college_rows)} colleges to Supabase_Ready_Colleges.csv")

except Exception as e:
    print(f"Error processing colleges: {e}")

# 2. PROCESS COURSES
print("Processing Courses...")
course_rows = []

try:
    with open(courses_input, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            name = row.get('course', '').strip()
            code = row.get('abbreviation', '').replace('(', '').replace(')', '').strip()
            
            if not name: continue
            
            name_lower = name.lower()
            code_lower = code.lower()
            
            # Intelligent Stream Inference
            if any(x in name_lower or x in code_lower for x in ['engineering', 'technology', 'computer', 'b.tech', 'm.tech', 'b.e']):
                stream = 'Engineering'
                duration = 48
            elif any(x in name_lower or x in code_lower for x in ['medic', 'surg', 'dental', 'nursing', 'm.b.b.s', 'b.d.s', 'ayurved', 'homeopath']):
                stream = 'Medical'
                duration = 60
            elif any(x in name_lower or x in code_lower for x in ['business', 'management', 'bba', 'mba', 'commerce', 'b.com', 'm.com', 'finance']):
                stream = 'Management & Commerce'
                duration = 36 if not name_lower.startswith('master') else 24
            elif any(x in name_lower or x in code_lower for x in ['art', 'humanities', 'b.a', 'm.a', 'social']):
                stream = 'Arts & Humanities'
                duration = 36 if not name_lower.startswith('master') else 24
            elif any(x in name_lower or x in code_lower for x in ['science', 'b.sc', 'm.sc']):
                stream = 'Science'
                duration = 36 if not name_lower.startswith('master') else 24
            elif 'law' in name_lower or 'llb' in code_lower or 'll.b' in code_lower or 'llm' in code_lower:
                stream = 'Law'
                duration = 36 if not name_lower.startswith('master') else 24
            else:
                stream = 'Other'
                duration = 36
                
            qual_level = 'Masters' if name_lower.startswith('master') or name_lower.startswith('m.') else 'Bachelors' if name_lower.startswith('bachelor') or name_lower.startswith('b.') else 'Diploma/Other'
            
            course_rows.append({
                'name': name,
                'code': code,
                'stream': stream,
                'duration_months': duration,
                'qualification_level': qual_level,
                'rating': round(random.uniform(3.8, 4.8), 1),
                'review_count': random.randint(20, 300)
            })

    with open(courses_output, 'w', encoding='utf-8', newline='') as f:
        fields = ['name', 'code', 'stream', 'duration_months', 'qualification_level', 'rating', 'review_count']
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(course_rows)
    print(f"Successfully wrote {len(course_rows)} courses to Supabase_Ready_Courses.csv")

except Exception as e:
    print(f"Error processing courses: {e}")
