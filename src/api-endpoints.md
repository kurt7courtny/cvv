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

## Authentication

Most endpoints require authentication using Bearer tokens:

```
Authorization: Bearer <your_access_token>
```

Tokens expire after 1 hour and must be refreshed using the refresh endpoint.
