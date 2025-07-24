# Video Voice Cloning Application

🎬 **Transform any video into any language while preserving the original speaker's voice!**

Imagine watching your favorite foreign film and hearing the actors speak in perfect English with their own authentic voices, or creating multilingual content where you speak fluent words without ever learning the language. This application makes it possible by combining cutting-edge AI voice cloning with seamless video processing.

## What it does
- 🎤 **Extract voices** from any video with crystal-clear quality
- 🌍 **Translate speech** to any language while keeping the original tone and emotion  
- 🎭 **Clone voices** so realistically that even friends can't tell the difference
- 🎥 **Generate new videos** where speakers appear to be fluent in languages they've never spoken

Perfect for content creators, educators, businesses expanding globally, or anyone who wants to break down language barriers in video content.

## Installation with NVIDIA Docker

### Prerequisites

#### System Dependencies
```bash
# Update package list
sudo apt update

# Install system dependencies for audio/video processing
sudo apt install -y \
    ffmpeg \
    libsndfile1-dev \
    libmagic1 \
    libmagic-dev \
    libpq-dev \
    python3-dev \
    build-essential \
    pkg-config \
    libasound2-dev \
    portaudio19-dev \
    libportaudio2 \
    libportaudiocpp0 \
    libopencv-dev \
    python3-opencv \
    redis-server \
    postgresql \
    postgresql-contrib

# Install additional audio processing libraries
sudo apt install -y \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libavresample-dev \
    libavutil-dev \
    libfftw3-dev \
    libsamplerate0-dev \
    libtag1-dev \
    libchromaprint-dev
```

#### NVIDIA Docker Runtime (for GPU acceleration)
```bash
# Install NVIDIA Docker runtime
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### Quick Start
```bash
# Clone repository
git clone https://github.com/kurt7courtny/cvv.git
cd cvv

# Build and run with GPU support
docker build -t cvv-app .
docker run --gpus all -p 8000:8000 -v ./data:/app/data cvv-app
```

### Full Setup with Services
```bash
# Run complete stack with database and redis
docker-compose up -d

# Access application at http://localhost:8000
```

### Environment Variables
```bash
export DATABASE_URL=postgresql://user:password@postgres:5432/cvv_db
export REDIS_URL=redis://redis:6379
export OPENAI_API_KEY=your_openai_key
```
