# Audio Processing & Speech-to-Text Service

## File Location

`src/pipeline/audio_speech/processor.py`

## Service Architecture

### Overview

The Audio Processing & Speech-to-Text Service follows a microservice architecture pattern with a unified pipeline approach. The service is designed as a modular, scalable system that processes video files through multiple stages to produce high-quality transcriptions and audio analysis.

### Core Components

#### 1. Input Handler

- **Video File Processing**: Multi-format support (MP4, AVI, MOV, MKV, WebM)
- **Audio Extraction**: FFmpeg 6.0+ with hardware acceleration
- **Metadata Parsing**: Technical specs, subtitles, and quality validation
- **Format Conversion**: Optimized audio output for STT processing

#### 2. Audio Enhancement Engine

- **Noise Reduction**: Facebook Denoiser (DNS-64), RNNoise, Wiener filtering
- **Source Separation**: MUCS v4.0, Spleeter for voice isolation
- **Audio Enhancement**: Multiband compression, EQ, loudness normalization
- **Quality Assessment**: PESQ, STOI, THD+N measurement

#### 3. Speaker Analysis System

- **Diarization**: PyAnnote Audio 3.1 with transformer architecture
- **Voice Fingerprinting**: X-Vector embeddings, ECAPA-TDNN models
- **Speaker Classification**: Gender, age, accent, emotion detection
- **Voice Clustering**: Hierarchical clustering with PLDA scoring

#### 4. Speech-to-Text Engine

- **Multi-Provider STT**: Whisper Large-v3, Google STT v2, Azure Cognitive Services
- **Language Processing**: 99-language detection, code-switching handling
- **Timestamp Alignment**: Montreal Forced Alignment with 10ms precision
- **Quality Scoring**: Word-level confidence and phrase-level assessment

#### 5. Content Processing & Translation

- **LLM Integration**: GPT-4 Turbo, Gemini Pro, Claude 3 for content enhancement
- **Translation Services**: Google Translate API v3, DeepL Pro with quality assessment
- **Semantic Analysis**: Named entity recognition, sentiment analysis, topic modeling
- **Content Validation**: Cross-modal alignment and quality verification

#### 6. Voice Cloning & Synthesis

- **Speaker Selection**: Primary speaker identification based on content semantics
- **Voice Cloning**: XTTS v2 zero-shot cloning with cross-language support
- **Synthesis**: Text-to-speech with prosody preservation and quality enhancement
- **Future Extensions**: Advanced voice library, real-time cloning, emotion control

#### 7. Output Generation

- **Subtitle Generation**: SRT/WebVTT with precise timing and accessibility compliance
- **Data Export**: JSON, CSV, XML/TTML formats with comprehensive metadata
- **Quality Reporting**: WER, CER, DER metrics and performance analytics
- **API Response**: RESTful endpoints with structured output validation

### Data Flow Architecture

```text
Video Input → Audio Extraction → Enhancement → Speaker Analysis
     ↓              ↓              ↓              ↓
Metadata ←→ Audio Processing ←→ Voice Separation ←→ Diarization
     ↓              ↓              ↓              ↓
STT Processing → Transcription → LLM Processing → Translation
     ↓              ↓              ↓              ↓
Voice Library ←→ Voice Selection ←→ Voice Cloning ←→ Synthesis
     ↓              ↓              ↓              ↓
Output Generation ← Data Aggregation ← Quality Control ← Final Processing
```

### Processing Pipeline Stages

The audio processing pipeline consists of 7 main stages, each with detailed technical specifications:

- **[Stage 1: Input Processing & Validation](stages/stage1-input-processing.md)** - File validation, metadata extraction, audio extraction, and quality assessment
- **[Stage 2: Audio Enhancement & Preprocessing](stages/stage2-audio-enhancement.md)** - Noise reduction, source separation, audio enhancement, and quality metrics
- **[Stage 3: Speaker Analysis & Diarization](stages/stage3-speaker-analysis.md)** - Speaker diarization, voice fingerprinting, clustering, and demographic analysis
- **[Stage 4: Speech-to-Text & Transcription](stages/stage4-speech-to-text.md)** - Multi-provider STT, language detection, timestamp alignment, and confidence scoring
- **[Stage 5: Content Processing, LLM Integration & Translation](stages/stage5-content-processing.md)** - LLM-based content processing, translation, semantic analysis, and validation
- **[Stage 6: Voice Cloning & Synthesis](stages/stage6-voice-cloning.md)** - Speaker-based voice selection, voice cloning, synthesis, and future extensions
- **[Stage 7: Output Generation & Quality Assurance](stages/stage7-output-generation.md)** - Data organization, subtitle generation, quality reporting, and export

Each stage document contains detailed technical specifications, algorithms, models, and implementation details for that specific processing phase.

### Service Interfaces

#### REST API Endpoints

- `POST /api/v1/audio-speech/process` - Main processing endpoint
- `GET /api/v1/audio-speech/status/{job_id}` - Job status monitoring
- `GET /api/v1/audio-speech/result/{job_id}` - Retrieve processing results
- `POST /api/v1/audio-speech/validate` - Input validation endpoint

#### Message Queue Integration

- **Input Queue**: Receives processing requests
- **Progress Queue**: Publishes processing updates
- **Result Queue**: Delivers completed results
- **Error Queue**: Handles processing failures

### Error Handling & Monitoring

#### Error Recovery Mechanisms

- **Automatic Retry Logic**: Configurable retry policies for transient failures
- **Fallback Providers**: Switch between STT providers on failure
- **Partial Processing**: Continue with available data when components fail
- **Graceful Degradation**: Reduce quality settings to ensure completion

#### Monitoring & Observability

- **Performance Metrics**: Processing time, throughput, resource utilization
- **Quality Metrics**: Transcription accuracy, audio enhancement effectiveness
- **Health Checks**: Component availability and performance monitoring
- **Alerting System**: Real-time notifications for critical issues

### Scalability & Performance

#### Horizontal Scaling

- **Containerized Deployment**: Docker-based microservice deployment
- **Load Balancing**: Distribute processing across multiple instances
- **Queue Management**: Handle high-volume processing requests
- **Resource Optimization**: Dynamic resource allocation based on workload

#### Performance Optimizations

- **Parallel Processing**: Concurrent execution of independent stages
- **Caching Strategy**: Cache frequently used models and configurations
- **Streaming Processing**: Real-time processing for live audio streams
- **GPU Acceleration**: Leverage GPU resources for AI model inference

### Security & Compliance

- **Data Encryption**: End-to-end encryption for sensitive audio content
- **Access Control**: Role-based access to processing capabilities
- **Audit Logging**: Comprehensive logging of all processing activities
- **Privacy Protection**: Automatic PII detection and redaction options

This comprehensive architecture ensures high-quality, scalable, and reliable audio processing and speech-to-text conversion while maintaining flexibility for various use cases and deployment scenarios.
