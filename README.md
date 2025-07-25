# Video Voice Cloning Application

🎬 **Transform any video into any language while preserving the original speaker's voice!**

Imagine watching your favorite foreign film and hearing the actors speak in perfect English with their own authentic voices, or creating multilingual content where you speak fluent words without ever learning the language. This application makes it possible by combining cutting-edge AI voice cloning with seamless video processing.

## What it does
- 🎤 **Extract voices** from any video with crystal-clear quality
- 🌍 **Translate speech** to any language while keeping the original tone and emotion  
- 🎭 **Clone voices** so realistically that even friends can't tell the difference
- 🎥 **Generate new videos** where speakers appear to be fluent in languages they've never spoken

Perfect for content creators, educators, businesses expanding globally, or anyone who wants to break down language barriers in video content.

## Architecture

This application consists of two main components:
- **Frontend**: Vue.js 3 web application with modern UI (`src/web/`)
- **Backend**: Python FastAPI microservices pipeline (`src/pipeline/`)

### Technology Stack

**Frontend:**
- Vue.js 3 with Composition API
- Tailwind CSS for styling
- Pinia for state management
- Video.js for video playback
- Socket.io for real-time updates

**Backend:**
- FastAPI with async/await
- Celery with Redis for task queuing
- PostgreSQL with SQLAlchemy
- PyTorch & Transformers for AI/ML
- FFmpeg for audio/video processing
- OpenAI API for advanced voice processing

## Prerequisites

### System Requirements
- **GPU**: NVIDIA GPU with CUDA support (already configured in Docker environment)
- **Memory**: 8GB RAM minimum, 16GB+ recommended
- **Storage**: 10GB free space minimum

## Installation & Setup

### 1. Environment Setup

Create a `.env` file in the project root:
```bash
cp .env.example .env
```

Edit the `.env` file with your configuration:
```bash
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
```

### 2. Install Python Dependencies

```bash
# Install Python requirements
pip install -r requirements.txt
```

### 3. Database Setup

```bash
# Set up database
export DATABASE_URL="postgresql://cvv_user:cvv_password@postgres:5432/cvv_db"

# Run database migrations
alembic upgrade head
```

### 4. Frontend Setup

```bash
cd src/web

# Install Node.js dependencies
npm install

# Build for production
npm run build
```

### 5. Start Services

#### Backend Services
```bash
# Start the API server
uvicorn src.pipeline.main:app --host 0.0.0.0 --port 8000

# In another terminal, start Celery worker
celery -A src.pipeline.celery_app worker --loglevel=info
```

#### Frontend Development (Optional)
```bash
cd src/web

# Start development server
npm run dev

# Access at http://localhost:5173
```

## Usage

1. **Upload Video**: Navigate to the upload page and select your video file
2. **Voice Extraction**: The system automatically extracts and analyzes voices
3. **Language Selection**: Choose your target language for translation
4. **Voice Cloning**: The AI clones the original speaker's voice in the new language
5. **Download**: Get your processed video with the cloned voice

## API Documentation

Once the backend is running, visit `http://localhost:8000/docs` for interactive API documentation.

### Key Endpoints
- `POST /api/v1/upload` - Upload video files
- `GET /api/v1/projects` - List user projects
- `POST /api/v1/process` - Start voice cloning process
- `GET /api/v1/status/{task_id}` - Check processing status
- `GET /api/v1/download/{project_id}` - Download processed video

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | Required |
| `REDIS_URL` | Redis connection string | Required |
| `OPENAI_API_KEY` | OpenAI API key for voice processing | Required |
| `SECRET_KEY` | Application secret key | Required |
| `JWT_SECRET_KEY` | JWT token secret | Required |
| `MAX_FILE_SIZE` | Maximum upload file size | 500MB |
| `DEBUG` | Enable debug mode | false |

## Troubleshooting

### Common Issues

1. **Out of Memory Errors**
   - Reduce batch size in processing settings
   - Monitor GPU memory usage

2. **Slow Processing**
   - GPU acceleration is enabled by default
   - Increase worker count in Celery if needed

3. **Audio Quality Issues**
   - Check input video audio quality
   - Adjust audio processing parameters

4. **Database Connection Errors**
   - Verify PostgreSQL is running
   - Check DATABASE_URL configuration

### Performance Optimization

- **GPU Memory**: Monitor CUDA memory usage during processing
- **Batch Processing**: Adjust batch sizes based on available GPU memory
- **Worker Scaling**: Scale Celery workers based on workload

## Development

### Backend Development
```bash
# Create virtual environment (if not in Docker)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run in development mode
uvicorn src.pipeline.main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend Development
```bash
cd src/web

# Install dependencies
npm install

# Start development server
npm run dev
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@cvv-app.com
- 🐛 Issues: [GitHub Issues](https://github.com/kurt7courtny/cvv/issues)
- 📖 Documentation: [Full Documentation](docs/)

## Acknowledgments

- OpenAI for voice processing capabilities
- The open-source community for the amazing tools and libraries
- Contributors who help improve this project

---

**Note**: This application is optimized for NVIDIA GPU environments and requires significant computational resources for voice cloning.
