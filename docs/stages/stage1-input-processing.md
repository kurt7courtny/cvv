# Stage 1: Input Processing & Validation

**Technologies**: FFmpeg 6.0+, MediaInfo, OpenCV 4.8+

## 1. File Validation & Format Detection
- **Container Analysis**: MP4, AVI, MOV, MKV, WebM format detection using FFprobe
- **Codec Verification**: H.264/H.265 video, AAC/MP3/WAV audio codec validation
- **Integrity Checking**: CRC32 checksums, file header validation
- **Bitrate Analysis**: Variable/Constant bitrate detection (CBR/VBR)

## 2. Metadata Extraction & Parsing
- **Technical Specs**: Resolution, frame rate, duration, aspect ratio extraction
- **Subtitle Detection**: SRT/VTT/ASS embedded subtitle stream identification
- **Audio Properties**: Sample rate (8kHz-48kHz), bit depth (16/24-bit), channel configuration
- **Timestamp Mapping**: Frame-accurate timecode extraction for synchronization

## 3. Audio Stream Extraction
- **FFmpeg Audio Extraction**: `-acodec pcm_s16le -ar 16000 -ac 1` for optimal STT processing
- **Multi-track Handling**: Automatic primary audio track selection or user-specified track
- **Format Conversion**: WAV PCM 16kHz mono output for consistent processing
- **Quality Preservation**: Lossless extraction maintaining original dynamic range

## 4. Initial Audio Quality Assessment
- **SNR Calculation**: Signal-to-Noise Ratio analysis using spectral analysis
- **Dynamic Range Measurement**: Peak-to-RMS ratio calculation
- **Frequency Analysis**: FFT-based spectral content analysis (20Hz-20kHz)
- **Clipping Detection**: Digital saturation and distortion identification
