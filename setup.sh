#!/bin/bash

# Video Voice Cloning Application Setup Script
# For NVIDIA GPU Docker Environment

set -e

echo "🎬 Setting up Video Voice Cloning Application..."

# Check if .env file exists
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "📝 Creating .env file from .env.example..."
        cp .env.example .env
        echo "⚠️  Please edit .env file with your configuration before proceeding"
    else
        echo "⚠️  .env.example not found. Creating basic .env file..."
        cat > .env << EOF
# Database Configuration
DATABASE_URL=postgresql://cvv_user:cvv_password@postgres:5432/cvv_db
POSTGRES_DB=cvv_db
POSTGRES_USER=cvv_user
POSTGRES_PASSWORD=cvv_password

# Redis Configuration
REDIS_URL=redis://redis:6379

# API Keys
OPENAI_API_KEY=your_openai_api_key_here

# Security
SECRET_KEY=your_secret_key_here
JWT_SECRET_KEY=your_jwt_secret_key_here

# File Storage
UPLOAD_DIR=/app/uploads
MAX_FILE_SIZE=500MB

# Application Settings
DEBUG=false
ENVIRONMENT=production
EOF
        echo "⚠️  Please edit .env file with your actual configuration"
    fi
else
    echo "✅ .env file already exists"
fi

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Check if we're in a directory with frontend
if [ -d "src/web" ]; then
    echo "🌐 Setting up frontend..."
    cd src/web
    
    # Install Node.js dependencies
    echo "📦 Installing Node.js dependencies..."
    npm install
    
    # Build for production
    echo "🏗️  Building frontend for production..."
    npm run build
    
    cd ../..
else
    echo "⚠️  Frontend directory not found, skipping frontend setup"
fi

# Create upload directory
echo "📁 Creating upload directory..."
mkdir -p uploads

# Check GPU availability
echo "🔍 Checking GPU availability..."
if command -v nvidia-smi &> /dev/null; then
    echo "✅ NVIDIA GPU detected:"
    nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader,nounits
else
    echo "⚠️  nvidia-smi not found. Make sure NVIDIA drivers are installed."
fi

# Check CUDA availability
echo "🔍 Checking CUDA availability..."
python -c "import torch; print(f'✅ PyTorch CUDA available: {torch.cuda.is_available()}'); print(f'✅ CUDA devices: {torch.cuda.device_count()}') if torch.cuda.is_available() else print('⚠️  CUDA not available')" 2>/dev/null || echo "⚠️  Could not check CUDA (PyTorch not installed yet)"

echo ""
echo "🎉 Setup completed!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your actual configuration"
echo "2. Set up your database (PostgreSQL) and Redis"
echo "3. Run database migrations: alembic upgrade head"
echo "4. Start the application:"
echo "   - API: uvicorn src.pipeline.main:app --host 0.0.0.0 --port 8000"
echo "   - Worker: celery -A src.pipeline.celery_app worker --loglevel=info"
echo ""
echo "📖 For more details, see README.md"
