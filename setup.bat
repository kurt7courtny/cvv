@echo off
REM Video Voice Cloning Application Setup Script
REM For NVIDIA GPU Docker Environment (Windows)

echo 🎬 Setting up Video Voice Cloning Application...

REM Check if .env file exists
if not exist ".env" (
    if exist ".env.example" (
        echo 📝 Creating .env file from .env.example...
        copy ".env.example" ".env"
        echo ⚠️  Please edit .env file with your configuration before proceeding
    ) else (
        echo ⚠️  .env.example not found. Creating basic .env file...
        (
            echo # Database Configuration
            echo DATABASE_URL=postgresql://cvv_user:cvv_password@postgres:5432/cvv_db
            echo POSTGRES_DB=cvv_db
            echo POSTGRES_USER=cvv_user
            echo POSTGRES_PASSWORD=cvv_password
            echo.
            echo # Redis Configuration
            echo REDIS_URL=redis://redis:6379
            echo.
            echo # API Keys
            echo OPENAI_API_KEY=your_openai_api_key_here
            echo.
            echo # Security
            echo SECRET_KEY=your_secret_key_here
            echo JWT_SECRET_KEY=your_jwt_secret_key_here
            echo.
            echo # File Storage
            echo UPLOAD_DIR=/app/uploads
            echo MAX_FILE_SIZE=500MB
            echo.
            echo # Application Settings
            echo DEBUG=false
            echo ENVIRONMENT=production
        ) > .env
        echo ⚠️  Please edit .env file with your actual configuration
    )
) else (
    echo ✅ .env file already exists
)

REM Install Python dependencies
echo 📦 Installing Python dependencies...
pip install -r requirements.txt

REM Check if we're in a directory with frontend
if exist "src\web" (
    echo 🌐 Setting up frontend...
    cd src\web
    
    REM Install Node.js dependencies
    echo 📦 Installing Node.js dependencies...
    npm install
    
    REM Build for production
    echo 🏗️  Building frontend for production...
    npm run build
    
    cd ..\..
) else (
    echo ⚠️  Frontend directory not found, skipping frontend setup
)

REM Create upload directory
echo 📁 Creating upload directory...
if not exist "uploads" mkdir uploads

REM Check GPU availability
echo 🔍 Checking GPU availability...
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader,nounits 2>nul && (
    echo ✅ NVIDIA GPU detected
) || (
    echo ⚠️  nvidia-smi not found. Make sure NVIDIA drivers are installed.
)

REM Check CUDA availability
echo 🔍 Checking CUDA availability...
python -c "import torch; print(f'✅ PyTorch CUDA available: {torch.cuda.is_available()}'); print(f'✅ CUDA devices: {torch.cuda.device_count()}') if torch.cuda.is_available() else print('⚠️  CUDA not available')" 2>nul || echo ⚠️  Could not check CUDA (PyTorch not installed yet)

echo.
echo 🎉 Setup completed!
echo.
echo Next steps:
echo 1. Edit .env file with your actual configuration
echo 2. Set up your database (PostgreSQL) and Redis
echo 3. Run database migrations: alembic upgrade head
echo 4. Start the application:
echo    - API: uvicorn src.pipeline.main:app --host 0.0.0.0 --port 8000
echo    - Worker: celery -A src.pipeline.celery_app worker --loglevel=info
echo.
echo 📖 For more details, see README.md
pause
