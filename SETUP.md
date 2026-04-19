# BigStudy Platform - Complete Setup Guide

## 🎯 Quick Start (5 minutes)

### Step 1: Set Up Supabase Database

1. **Access Supabase Console**
   - Go to: https://app.supabase.com
   - Login with your account
   - Select your project: `tidxcichacbuyweegywz`

2. **Create Database Tables**
   - Navigate to SQL Editor
   - Copy and paste the entire contents of `scripts/01-create-schema.sql`
   - Click "Run" button
   - Wait for completion (should see success message)

3. **Load Sample Data**
   - In SQL Editor, paste contents of `scripts/02-seed-data.sql`
   - Click "Run" button
   - Verify data is loaded (check Colleges table, should see 10+ colleges)

4. **Verify Configuration**
   - Check that your Supabase credentials are correctly set in `public/js/supabase-client.js`:
   ```javascript
   const SUPABASE_URL = 'https://tidxcichacbuyweegywz.supabase.co';
   const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```

### Step 2: Run the Application

**Option A: Using Python (Recommended for simplicity)**
```bash
cd /vercel/share/v0-project
python -m http.server 8000
```
Then open: http://localhost:8000

**Option B: Using Node.js/npm**
```bash
cd /vercel/share/v0-project
npx http-server
```
Then open: http://localhost:8080

**Option C: Using Vercel (Production)**
```bash
vercel deploy
```

### Step 3: Test the Platform

1. **Homepage** (http://localhost:8000)
   - View top colleges
   - See testimonials
   - Explore statistics

2. **Sign Up** (http://localhost:8000/pages/auth/signup.html)
   - Create test account
   - Use any email (testing@test.com)
   - Password must be 8+ characters

3. **Browse Colleges** (http://localhost:8000/pages/colleges/index.html)
   - See list of colleges
   - Apply filters (state, premier status, rating)
   - Search for specific colleges
   - Click on a college to view details

4. **Explore Courses** (http://localhost:8000/pages/courses/index.html)
   - Filter by stream (Engineering, Management, etc.)
   - View course details

5. **Check Exams** (http://localhost:8000/pages/exams/index.html)
   - See entrance exams with dates
   - Check application deadlines
   - View exam details

6. **User Dashboard** (After signing in)
   - View saved colleges
   - Track applications
   - Edit profile

## 📊 Database Schema Overview

### Essential Tables

**users**
```sql
id (UUID) - User ID
email - Email address
password_hash - Hashed password
full_name - User's name
state - Home state
target_exam - Target entrance exam
```

**colleges**
```sql
id (UUID) - College ID
name - College name
nirf_rank - NIRF ranking
rating - Star rating (1-5)
state, city - Location
placement_percentage - Placement rate
avg_package - Average salary package
```

**courses**
```sql
id (UUID) - Course ID
name - Course name
stream - Stream (Engineering/Management/etc)
duration_months - Duration in months
qualification_level - Bachelors/Masters/Diploma
rating - Course rating
```

**entrance_exams**
```sql
id (UUID) - Exam ID
name - Exam name (JEE/NEET/etc)
exam_date - When exam happens
application_start_date - When applications open
application_end_date - Last date to apply
exam_fee - Application fee
```

## 🔑 Key Features & How to Use

### 1. College Search & Filtering
```
- Navigate to: /pages/colleges/index.html
- Use filters on left sidebar:
  * Premier colleges toggle
  * State selector (Maharashtra, Delhi, etc)
  * Minimum rating
- Sort by: Rating, NIRF Rank, Name
- Click "View Details" for full information
```

### 2. User Authentication
```
- Sign Up: /pages/auth/signup.html
- Sign In: /pages/auth/signin.html
- Forgot Password: /pages/auth/forgot-password.html
- Data is securely stored in Supabase
```

### 3. Save Favorites
```
- Click "❤️ Save" button on college cards
- View saved colleges in: /pages/dashboard/favorites.html
- Compare multiple colleges easily
```

### 4. Track Applications
```
- Create applications from college detail page
- Track status in: /pages/dashboard/applications.html
- See pending, accepted, rejected applications
```

## 🛠️ File Organization

```
BigStudy/
├── index.html                          # Entry point
├── public/
│   ├── css/styles.css                 # All styling (900+ lines)
│   └── js/
│       ├── supabase-client.js         # Database & Auth
│       └── utils.js                   # Helper functions
├── pages/
│   ├── auth/                          # Authentication pages
│   ├── colleges/                      # College pages
│   ├── courses/                       # Course pages
│   ├── exams/                         # Exam pages
│   ├── dashboard/                     # User dashboard
│   └── legal/                         # T&C, Privacy, Contact
└── scripts/                           # SQL scripts
    ├── 01-create-schema.sql
    └── 02-seed-data.sql
```

## 🔐 Important Configuration

### Supabase Connection
File: `public/js/supabase-client.js`
```javascript
// Update these with your project credentials
const SUPABASE_URL = 'https://tidxcichacbuyweegywz.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### Enable Authentication
In Supabase Console:
1. Go to Authentication → Providers
2. Ensure "Email" is enabled
3. Go to URL Configuration
4. Add your domain to Redirect URLs

### Row Level Security (RLS)
All sensitive tables have RLS enabled:
- Users can only see their own data
- Public tables (colleges, courses, exams) are readable by all
- Reviews and applications are protected

## 🧪 Testing Checklist

- [ ] Database tables created successfully
- [ ] Sample data loaded (10+ colleges visible)
- [ ] Homepage loads and displays colleges
- [ ] Sign up creates new user account
- [ ] Sign in works with created account
- [ ] Password reset email functionality
- [ ] College search and filtering work
- [ ] Course filtering works
- [ ] Exam listing displays dates correctly
- [ ] Save favorite colleges works
- [ ] Dashboard shows saved colleges
- [ ] Application tracking works
- [ ] Mobile responsive design works
- [ ] All links and navigation work

## 📱 Mobile Testing

Test on different screen sizes:
- **Mobile** (375px): Should stack vertically, readable
- **Tablet** (768px): 2-column layout for colleges
- **Desktop** (1200px+): Full 3-4 column layout

Use browser DevTools (F12) to test responsive design.

## 🚀 Deployment

### Deploy to Vercel
```bash
vercel deploy --prod
```

### Deploy to Netlify
```bash
netlify deploy --prod --dir=.
```

### Deploy to GitHub Pages
```bash
git push origin main
# Enable Pages in GitHub repo settings
```

## 📞 Troubleshooting

### Issue: "Colleges not loading"
**Solution:**
- Check Supabase credentials in `supabase-client.js`
- Verify database tables exist (SQL Editor → Run)
- Check browser console for errors (F12 → Console)

### Issue: "Sign up fails"
**Solution:**
- Ensure Supabase Auth is enabled
- Check email format is valid
- Password must be 8+ characters
- Check browser console for error details

### Issue: "404 on page navigation"
**Solution:**
- Ensure you're serving from project root
- Check file paths in href attributes
- Use relative paths (e.g., `/pages/colleges/index.html`)

### Issue: "Search not working"
**Solution:**
- Verify data is loaded in database
- Check browser console for API errors
- Try clearing browser cache (Ctrl+Shift+Delete)

## 📚 API Reference

All API calls are in `BigStudyAPI` object:

```javascript
// Colleges
BigStudyAPI.getColleges(filters, limit, offset)
BigStudyAPI.getPremierColleges()
BigStudyAPI.searchColleges(query)
BigStudyAPI.getCollegeById(id)

// Courses
BigStudyAPI.getCourses(filters, limit)
BigStudyAPI.getCollegeCourses(collegeId)

// Exams
BigStudyAPI.getExams(filters)

// User Features
BigStudyAPI.addFavorite(collegeId)
BigStudyAPI.removeFavorite(collegeId)
BigStudyAPI.createApplication(collegeId, courseId)
```

## ✨ Next Steps

### To Add More Features:
1. Create new pages in appropriate folders
2. Use existing utility functions from `utils.js`
3. Follow existing HTML/CSS patterns
4. Test on mobile and desktop
5. Push to GitHub/Vercel

### Recommended Additions:
- College comparison tool
- AI recommendation engine
- Exam preparation materials
- Forum/discussions
- Mobile app

## 📖 Documentation

- **Full README**: See `README.md`
- **Database Schema**: Details in `scripts/01-create-schema.sql`
- **Code Comments**: See JavaScript files for inline documentation

---

**Platform Ready!** 🎉 You're all set to use BigStudy. Start by visiting http://localhost:8000
