# Quick Start Guide - NVIDIA GPU Docker Environment

This guide assumes you're running in an NVIDIA GPU Docker environment and want to quickly set up the Video Voice Cloning Application.

## What Changed

✅ **Removed Docker setup complexity**  
✅ **Simplified for GPU Docker environment**  
✅ **Added automated setup scripts**  
✅ **Streamlined installation process**

## Quick Setup

### Option 1: Automated Setup (Recommended)

**Windows:**
```bash
setup.bat
```

**Linux/macOS:**
```bash
./setup.sh
```

### Option 2: Manual Setup

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Setup environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Setup frontend:**
   ```bash
   cd src/web
   npm install
   npm run build
   cd ../..
   ```

4. **Create upload directory:**
   ```bash
   mkdir -p uploads
   ```

## Required Configuration

Edit your `.env` file with:

```bash
# Database Configuration
DATABASE_URL=postgresql://cvv_user:cvv_password@postgres:5432/cvv_db

# Redis Configuration  
REDIS_URL=redis://redis:6379

# API Keys
OPENAI_API_KEY=your_actual_openai_api_key

# Security
SECRET_KEY=your_secret_key_here
JWT_SECRET_KEY=your_jwt_secret_key_here
```

## Start the Application

1. **Database migrations:**
   ```bash
   alembic upgrade head
   ```

2. **Start API server:**
   ```bash
   uvicorn src.pipeline.main:app --host 0.0.0.0 --port 8000
   ```

3. **Start Celery worker (in another terminal):**
   ```bash
   celery -A src.pipeline.celery_app worker --loglevel=info
   ```

## Verify GPU Setup

Check if CUDA is available:
```bash
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
```

## Access Points

- **API Documentation:** http://localhost:8000/docs
- **Frontend (if running dev server):** http://localhost:5173

## Key Dependencies Installed

- **AI/ML:** PyTorch, Transformers, OpenAI, Whisper
- **Web Framework:** FastAPI, Uvicorn
- **Database:** SQLAlchemy, PostgreSQL
- **Task Queue:** Celery, Redis
- **Audio/Video:** FFmpeg, LibROSA, OpenCV, MoviePy

## Troubleshooting

- **GPU not detected:** Ensure NVIDIA drivers and CUDA are properly installed
- **Memory issues:** Monitor GPU memory usage and adjust batch sizes
- **Database errors:** Verify PostgreSQL is running and accessible
- **Redis errors:** Ensure Redis server is running

For detailed information, see the main [README.md](README.md).
