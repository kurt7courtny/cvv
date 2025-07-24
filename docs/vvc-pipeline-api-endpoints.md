# API Endpoints Reference

This document provides a comprehensive reference for all API endpoints in the Video Voice Cloning application.

## Base URL
```
http://localhost:8000/api/v1
```

## Authentication Endpoints

### Login
- **Endpoint:** `POST /api/v1/auth/login`
- **Description:** Authenticate user and receive access token
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response:**
  ```json
  {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "bearer",
    "expires_in": 3600
  }
  ```

### Refresh Token
- **Endpoint:** `POST /api/v1/auth/refresh`
- **Description:** Refresh access token using refresh token
- **Headers:** `Authorization: Bearer <refresh_token>`

### Logout
- **Endpoint:** `DELETE /api/v1/auth/logout`
- **Description:** Invalidate current session
- **Headers:** `Authorization: Bearer <access_token>`

## File Management Endpoints

### Upload File
- **Endpoint:** `POST /api/v1/files/upload`
- **Description:** Upload video file for processing
- **Content-Type:** `multipart/form-data`
- **Request Body:**
  ```
  file: <video_file>
  project_name: "My Project"
  ```

### Get File
- **Endpoint:** `GET /api/v1/files/{file_id}`
- **Description:** Retrieve file information and download URL
- **Parameters:**
  - `file_id` (path): Unique file identifier

### Delete File
- **Endpoint:** `DELETE /api/v1/files/{file_id}`
- **Description:** Delete uploaded file
- **Parameters:**
  - `file_id` (path): Unique file identifier

## Processing Endpoints

### Extract Audio
- **Endpoint:** `POST /api/v1/process/extract-audio`
- **Description:** Extract audio from uploaded video
- **Request Body:**
  ```json
  {
    "video_file_id": "uuid-here",
    "audio_format": "wav",
    "sample_rate": 44100
  }
  ```

### Transcribe Audio
- **Endpoint:** `POST /api/v1/process/transcribe`
- **Description:** Convert audio to text
- **Request Body:**
  ```json
  {
    "audio_file_id": "uuid-here",
    "source_language": "en",
    "model": "whisper-large"
  }
  ```

### Clone Voice
- **Endpoint:** `POST /api/v1/process/clone-voice`
- **Description:** Generate voice clone from audio sample
- **Request Body:**
  ```json
  {
    "audio_file_id": "uuid-here",
    "target_language": "es",
    "voice_profile_id": "uuid-here",
    "text_content": "Translated text to speak"
  }
  ```

### Generate Video
- **Endpoint:** `POST /api/v1/process/generate-video`
- **Description:** Create final video with cloned voice
- **Request Body:**
  ```json
  {
    "original_video_id": "uuid-here",
    "cloned_audio_id": "uuid-here",
    "output_format": "mp4",
    "quality": "high"
  }
  ```

### Check Processing Status
- **Endpoint:** `GET /api/v1/process/status/{job_id}`
- **Description:** Get current status of processing job
- **Parameters:**
  - `job_id` (path): Processing job identifier
- **Response:**
  ```json
  {
    "job_id": "uuid-here",
    "status": "processing",
    "progress": 75,
    "estimated_completion": "2024-01-15T10:30:00Z",
    "result_url": null
  }
  ```

## Voice Management Endpoints

### Get Voice Profiles
- **Endpoint:** `GET /api/v1/voices/profiles`
- **Description:** List all available voice profiles for user
- **Query Parameters:**
  - `language` (optional): Filter by language
  - `gender` (optional): Filter by gender
- **Response:**
  ```json
  {
    "profiles": [
      {
        "id": "uuid-here",
        "name": "Professional Male",
        "language": "en",
        "gender": "male",
        "created_at": "2024-01-15T10:00:00Z"
      }
    ]
  }
  ```

### Create Voice Profile
- **Endpoint:** `POST /api/v1/voices/create-profile`
- **Description:** Create new voice profile from audio sample
- **Request Body:**
  ```json
  {
    "name": "My Voice",
    "audio_sample_id": "uuid-here",
    "language": "en",
    "description": "Professional voice for presentations"
  }
  ```

### Preview Voice
- **Endpoint:** `GET /api/v1/voices/preview/{profile_id}`
- **Description:** Generate preview audio with voice profile
- **Parameters:**
  - `profile_id` (path): Voice profile identifier
- **Query Parameters:**
  - `text` (required): Text to synthesize
  - `language` (optional): Target language

## Error Responses

All endpoints may return the following error responses:

### 400 Bad Request
```json
{
  "error": "validation_error",
  "message": "Invalid request parameters",
  "details": {
    "field": "email",
    "issue": "Invalid email format"
  }
}
```

### 401 Unauthorized
```json
{
  "error": "unauthorized",
  "message": "Invalid or expired token"
}
```

### 404 Not Found
```json
{
  "error": "not_found",
  "message": "Resource not found"
}
```

### 429 Too Many Requests
```json
{
  "error": "rate_limit_exceeded",
  "message": "Too many requests, please try again later",
  "retry_after": 60
}
```

### 500 Internal Server Error
```json
{
  "error": "internal_error",
  "message": "An unexpected error occurred"
}
```

## Rate Limiting

- **Authentication endpoints:** 5 requests per minute per IP
- **File upload:** 10 requests per hour per user
- **Processing endpoints:** 20 requests per hour per user
- **Other endpoints:** 100 requests per minute per user

## Database Schema

The following database schema supports all API endpoints and operations:

### Core Tables

#### Users and Authentication
```sql
-- User management
users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  subscription_tier VARCHAR(50) DEFAULT 'free',
  is_active BOOLEAN DEFAULT true
);

-- Session management for auth endpoints
user_sessions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  access_token VARCHAR(500) NOT NULL,
  refresh_token VARCHAR(500),
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  is_revoked BOOLEAN DEFAULT false
);
```

#### Projects and Files
```sql
-- Project management for file organization
projects (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- File management for upload/download endpoints
video_files (
  id UUID PRIMARY KEY,
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  original_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size BIGINT NOT NULL,
  duration_seconds INTEGER,
  format VARCHAR(20),
  resolution VARCHAR(20),
  upload_status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Audio extraction results
audio_files (
  id UUID PRIMARY KEY,
  video_file_id UUID REFERENCES video_files(id) ON DELETE CASCADE,
  file_path VARCHAR(500) NOT NULL,
  sample_rate INTEGER NOT NULL,
  channels INTEGER NOT NULL,
  duration_seconds INTEGER,
  format VARCHAR(20),
  file_size BIGINT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### Processing and Jobs
```sql
-- Processing job tracking for status endpoints
processing_jobs (
  id UUID PRIMARY KEY,
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  job_type VARCHAR(50) NOT NULL, -- 'extract_audio', 'transcribe', 'clone_voice', 'generate_video'
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
  progress INTEGER DEFAULT 0,
  input_file_id UUID,
  output_file_id UUID,
  parameters JSONB,
  error_message TEXT,
  estimated_completion TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Voice profile management
voice_profiles (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  language VARCHAR(10) NOT NULL,
  gender VARCHAR(20),
  model_path VARCHAR(500),
  audio_sample_id UUID REFERENCES audio_files(id),
  characteristics JSONB,
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Transcription results
transcripts (
  id UUID PRIMARY KEY,
  audio_file_id UUID REFERENCES audio_files(id) ON DELETE CASCADE,
  processing_job_id UUID REFERENCES processing_jobs(id),
  content TEXT NOT NULL,
  language VARCHAR(10) NOT NULL,
  confidence_score DECIMAL(3,2),
  word_timestamps JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Generated voice clones
voice_clones (
  id UUID PRIMARY KEY,
  voice_profile_id UUID REFERENCES voice_profiles(id) ON DELETE CASCADE,
  transcript_id UUID REFERENCES transcripts(id),
  target_language VARCHAR(10) NOT NULL,
  cloned_audio_path VARCHAR(500),
  text_content TEXT NOT NULL,
  processing_job_id UUID REFERENCES processing_jobs(id),
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### API Usage and Monitoring
```sql
-- Rate limiting and API usage tracking
api_usage_logs (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  endpoint VARCHAR(255) NOT NULL,
  method VARCHAR(10) NOT NULL,
  ip_address INET,
  user_agent TEXT,
  response_status INTEGER,
  response_time_ms INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Rate limiting counters
rate_limit_counters (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  endpoint_group VARCHAR(100) NOT NULL, -- 'auth', 'upload', 'processing', 'general'
  request_count INTEGER DEFAULT 0,
  window_start TIMESTAMP NOT NULL,
  window_end TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Database Indexes

```sql
-- Performance indexes for API endpoints
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_user_sessions_token ON user_sessions(access_token);
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_projects_user_id ON projects(user_id);
CREATE INDEX idx_video_files_project_id ON video_files(project_id);
CREATE INDEX idx_audio_files_video_id ON audio_files(video_file_id);
CREATE INDEX idx_processing_jobs_status ON processing_jobs(status);
CREATE INDEX idx_processing_jobs_project_id ON processing_jobs(project_id);
CREATE INDEX idx_voice_profiles_user_id ON voice_profiles(user_id);
CREATE INDEX idx_transcripts_audio_file_id ON transcripts(audio_file_id);
CREATE INDEX idx_api_usage_user_id_created ON api_usage_logs(user_id, created_at);
CREATE INDEX idx_rate_limit_user_endpoint ON rate_limit_counters(user_id, endpoint_group);
```

## Authentication

Most endpoints require authentication using Bearer tokens:

```
Authorization: Bearer <your_access_token>
```

Tokens expire after 1 hour and must be refreshed using the refresh endpoint.
