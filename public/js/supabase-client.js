// BigStudy Supabase Client Configuration
const SUPABASE_URL = 'https://tidxcichacbuyweegywz.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpZHhjaWNoYWNidXl3ZWVneXd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1ODQyOTQsImV4cCI6MjA5MjE2MDI5NH0.9FtowGkhvGMvtJK1BcrP2FmVsXBgIfGJFS3bh74W6yM';

// Supabase Client Class
class SupabaseClient {
  constructor(url, key) {
    this.url = url;
    this.key = key;
  }

  async request(method, table, options = {}) {
    const endpoint = `${this.url}/rest/v1/${table}`;
    const token = this.getAuthToken();
    const headers = {
      'apikey': this.key,
      'Authorization': `Bearer ${token || this.key}`,
      'Content-Type': 'application/json'
    };

    // Ask Supabase to return the inserted/updated row
    if (method === 'POST' || method === 'PATCH') {
      headers['Prefer'] = 'return=representation';
    }

    const config = {
      method,
      headers
    };

    if (method !== 'GET' && options.data) {
      config.body = JSON.stringify(options.data);
    }

    let url = endpoint;
    if (options.select) {
      url += `?select=${encodeURIComponent(options.select)}`;
    }
    if (options.filters) {
      Object.entries(options.filters).forEach(([key, value]) => {
        // Skip null/undefined values
        if (value === null || value === undefined) return;
        const separator = url.includes('?') ? '&' : '?';
        if (typeof value === 'boolean' || typeof value === 'number') {
          // Booleans and numbers: exact match
          url += `${separator}${key}=eq.${value}`;
        } else if (typeof value === 'string' && value.includes(',')) {
          // Comma-separated list: IN query
          url += `${separator}${key}=in.(${value})`;
        } else if (key === 'id' || key.endsWith('_id') || key === 'user_id' || key === 'college_id') {
          // ID fields: exact match (not ilike)
          url += `${separator}${key}=eq.${value}`;
        } else {
          // Other strings: partial match
          url += `${separator}${key}=ilike.%${value}%`;
        }
      });
    }
    if (options.order) {
      const separator = url.includes('?') ? '&' : '?';
      url += `${separator}order=${options.order}`;
    }
    if (options.limit) {
      const separator = url.includes('?') ? '&' : '?';
      url += `${separator}limit=${options.limit}`;
    }
    if (options.offset) {
      const separator = url.includes('?') ? '&' : '?';
      url += `${separator}offset=${options.offset}`;
    }

    try {
      const response = await fetch(url, config);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${await response.text()}`);
      }
      return await response.json();
    } catch (error) {
      console.error('[Supabase] Error:', error);
      throw error;
    }
  }

  // Query methods
  async select(table, options = {}) {
    return this.request('GET', table, options);
  }

  async insert(table, data) {
    return this.request('POST', table, { data });
  }

  async update(table, data, filters) {
    return this.request('PATCH', table, { data, filters });
  }

  async delete(table, filters) {
    return this.request('DELETE', table, { filters });
  }

  // Auth methods
  async signUp(email, password, fullName = '') {
    const authUrl = `${this.url}/auth/v1/signup`;
    const response = await fetch(authUrl, {
      method: 'POST',
      headers: {
        'apikey': this.key,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email,
        password,
        data: { full_name: fullName }
      })
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      if (response.status === 429) {
        throw new Error('429: Too many signup requests. Please wait a few minutes before trying again.');
      }
      throw new Error(errorData.msg || errorData.message || `Sign up failed (${response.status})`);
    }

    // Supabase signup returns: { user, session } 
    // session may be null if email confirmation is required
    const data = await response.json();
    if (data.session) {
      this.saveSession(data.session);
    }
    // Return full response so caller can check data.user
    return data;
  }

  async signIn(email, password) {
    const authUrl = `${this.url}/auth/v1/token?grant_type=password`;
    const response = await fetch(authUrl, {
      method: 'POST',
      headers: {
        'apikey': this.key,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email, password })
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      if (response.status === 429) {
        throw new Error('Too many login attempts. Please wait a few minutes before trying again.');
      }
      if (response.status === 400) {
        throw new Error(errorData.error_description || errorData.msg || errorData.message || 'Invalid email or password. Please check your credentials.');
      }
      throw new Error(errorData.error_description || errorData.msg || errorData.message || 'Sign in failed');
    }

    const data = await response.json();
    this.saveSession(data);
    return data;
  }

  async signOut() {
    localStorage.removeItem('bigStudySession');
    window.location.href = '/';
  }

  async resetPassword(email) {
    const authUrl = `${this.url}/auth/v1/recover`;
    const response = await fetch(authUrl, {
      method: 'POST',
      headers: {
        'apikey': this.key,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email })
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Reset request failed');
    }

    return true;
  }

  saveSession(data) {
    localStorage.setItem('bigStudySession', JSON.stringify(data));
  }

  getSession() {
    const session = localStorage.getItem('bigStudySession');
    return session ? JSON.parse(session) : null;
  }

  getAuthToken() {
    const session = this.getSession();
    if (!session) return null;
    // Handle both session object formats
    return session.access_token || null;
  }

  getCurrentUser() {
    const session = this.getSession();
    if (!session) return null;
    return session.user || null;
  }

  isAuthenticated() {
    return !!this.getAuthToken();
  }
}

// Initialize global Supabase client
const supabase = new SupabaseClient(SUPABASE_URL, SUPABASE_KEY);

// Utility functions for common queries
const BigStudyAPI = {
  // Colleges
  async getColleges(filters = {}, limit = 20, offset = 0) {
    return supabase.select('colleges', {
      select: '*',
      filters,
      order: 'nirf_rank,name',
      limit,
      offset
    });
  },

  async getCollegeById(id) {
    const result = await supabase.select('colleges', {
      filters: { id }
    });
    return result[0] || null;
  },

  async searchColleges(query) {
    return supabase.select('colleges', {
      filters: { name: query },
      limit: 10
    });
  },

  async getPremierColleges() {
    return supabase.select('colleges', {
      filters: { is_premier: true },
      order: 'nirf_rank',
      limit: 10
    });
  },

  // Courses
  async getCourses(filters = {}, limit = 20) {
    return supabase.select('courses', {
      select: '*',
      filters,
      order: 'name',
      limit
    });
  },

  async getCourseById(id) {
    const result = await supabase.select('courses', {
      filters: { id }
    });
    return result[0] || null;
  },

  async getCollegeCourses(collegeId) {
    return supabase.select('college_courses', {
      filters: { college_id: collegeId },
      limit: 100
    });
  },

  // Exams
  async getExams(filters = {}) {
    return supabase.select('entrance_exams', {
      select: '*',
      filters,
      order: 'exam_type,name',
      limit: 50
    });
  },

  async getExamById(id) {
    const result = await supabase.select('entrance_exams', {
      filters: { id }
    });
    return result[0] || null;
  },

  // Testimonials
  async getFeaturedTestimonials() {
    return supabase.select('testimonials', {
      filters: { featured: true },
      limit: 6
    });
  },

  // Reviews
  async getCollegeReviews(collegeId) {
    return supabase.select('college_reviews', {
      filters: { college_id: collegeId },
      order: 'created_at'
    });
  },

  // Favorites
  async addFavorite(collegeId) {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');
    
    return supabase.insert('user_favorites', {
      user_id: session.user.id,
      college_id: collegeId
    });
  },

  async removeFavorite(collegeId) {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');
    
    return supabase.delete('user_favorites', {
      user_id: session.user.id,
      college_id: collegeId
    });
  },

  async getUserFavorites() {
    const session = supabase.getSession();
    if (!session) return [];
    
    return supabase.select('user_favorites', {
      filters: { user_id: session.user.id }
    });
  },

  // Applications
  async createApplication(collegeId, courseId, examId = null) {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');
    
    return supabase.insert('applications', {
      user_id: session.user.id,
      college_id: collegeId,
      course_id: courseId,
      exam_id: examId
    });
  },

  async getUserApplications() {
    const session = supabase.getSession();
    if (!session) return [];
    
    return supabase.select('applications', {
      filters: { user_id: session.user.id },
      order: 'created_at'
    });
  },

  async submitApplication(collegeId, courseId, examScore = null) {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');

    return supabase.insert('applications', {
      user_id: session.user.id,
      college_id: collegeId,
      course_id: courseId,
      exam_score: examScore,
      application_status: 'pending',
      application_date: new Date().toISOString(),
      submission_date: new Date().toISOString()
    });
  },

  async getApplicationById(id) {
    const result = await supabase.select('applications', { filters: { id } });
    return result[0] || null;
  },

  async getUserProfile() {
    const session = supabase.getSession();
    if (!session) return null;
    const user = session.user;

    try {
      const result = await supabase.select('users', {
        filters: { id: user.id }
      });

      if (result && result.length > 0) return result[0];

      // No row found — auto-create a minimal row via upsert
      // This handles users who signed up before the DB trigger was added
      console.log('[v0] No user profile row found, creating one...');
      const created = await this.updateUserProfile({
        full_name: user.user_metadata?.full_name || ''
      });
      return created;
    } catch (err) {
      console.error('[v0] getUserProfile error:', err);
      return null;
    }
  },

  async updateUserProfile(profileData) {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');
    const userId = session.user.id;
    const user   = session.user;

    // Use UPSERT: POST with merge-duplicates.
    // This INSERT-or-UPDATEs based on the primary key (id).
    // Solves the case where no users row exists yet for this auth user.
    const endpoint = `${SUPABASE_URL}/rest/v1/users`;
    const response = await fetch(endpoint, {
      method: 'POST',
      headers: {
        'apikey':        SUPABASE_KEY,
        'Authorization': `Bearer ${supabase.getAuthToken()}`,
        'Content-Type':  'application/json',
        'Prefer':        'resolution=merge-duplicates,return=representation'
      },
      body: JSON.stringify({
        id:    userId,
        email: user.email,           // required — NOT NULL column
        ...profileData,
        updated_at: new Date().toISOString()
      })
    });
    if (!response.ok) {
      const err = await response.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to update profile');
    }
    const result = await response.json();
    return Array.isArray(result) ? result[0] : result;
  },

  async hasAlreadyApplied(collegeId, courseId) {
    const session = supabase.getSession();
    if (!session) return false;
    const apps = await supabase.select('applications', {
      filters: { user_id: session.user.id, college_id: collegeId, course_id: courseId }
    });
    return apps.length > 0;
  },

  // ===== STORAGE: Avatars =====
  async uploadAvatar(file) {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');
    const userId = session.user.id;
    const ext    = file.name.split('.').pop();
    const path   = `${userId}/avatar.${ext}`;

    const url = `${SUPABASE_URL}/storage/v1/object/avatars/${path}`;
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'apikey':        SUPABASE_KEY,
        'Authorization': `Bearer ${supabase.getAuthToken()}`,
        'Content-Type':  file.type,
        'x-upsert':      'true'   // overwrite existing
      },
      body: file
    });
    if (!response.ok) {
      const err = await response.json().catch(() => ({}));
      throw new Error(err.error || err.message || 'Avatar upload failed');
    }
    // Build public URL
    const publicUrl = `${SUPABASE_URL}/storage/v1/object/public/avatars/${path}`;
    // Save URL in users table
    await this.updateUserProfile({ avatar_url: publicUrl });
    return publicUrl;
  },

  getAvatarUrl(userId, ext = 'jpg') {
    return `${SUPABASE_URL}/storage/v1/object/public/avatars/${userId}/avatar.${ext}`;
  },

  // ===== STORAGE: Documents =====
  async uploadDocument(file, label = 'document') {
    const session = supabase.getSession();
    if (!session) throw new Error('Not authenticated');
    const userId = session.user.id;
    const ext    = file.name.split('.').pop();
    const ts     = Date.now();
    const path   = `${userId}/${label}_${ts}.${ext}`;

    const url = `${SUPABASE_URL}/storage/v1/object/documents/${path}`;
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'apikey':        SUPABASE_KEY,
        'Authorization': `Bearer ${supabase.getAuthToken()}`,
        'Content-Type':  file.type
      },
      body: file
    });
    if (!response.ok) {
      const err = await response.json().catch(() => ({}));
      throw new Error(err.error || err.message || 'Document upload failed');
    }
    return path; // return path for storing in applications table
  },

  async getSignedDocumentUrl(path) {
    if (!path) return null;
    const url = `${SUPABASE_URL}/storage/v1/object/sign/documents/${path}`;
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${supabase.getAuthToken()}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ expiresIn: 3600 }) // 1 hour validity
    });
    if (!response.ok) return null;
    const data = await response.json();
    return `${SUPABASE_URL}${data.signedURL}`;
  }
};

