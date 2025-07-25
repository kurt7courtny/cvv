# Stage 2: Audio Enhancement & Preprocessing

**Technologies**: librosa 0.10+, noisereduce 3.0+, MUCS v4.0, scipy 1.11+

## 1. Advanced Noise Reduction

- **Spectral Subtraction**: Wiener filtering with adaptive noise floor estimation
- **Deep Learning Denoising**: Facebook Denoiser (DNS-64) for real-time noise suppression
- **RNNoise Integration**: Recurrent neural network-based noise reduction
- **Adaptive Filtering**: Kalman filter implementation for dynamic noise adaptation

## 2. Source Separation & Voice Isolation

- **MUCS v4.0 Implementation**: Music/Voice separation using Hybrid Demucs model
- **Spleeter Integration**: Deezer's 4-stem separation (vocals, drums, bass, other)
- **Voice Activity Detection (VAD)**: WebRTC VAD algorithm for speech segment identification
- **Harmonic-Percussive Separation**: librosa HPSS for music/speech distinction

## 3. Audio Enhancement & Normalization

- **Dynamic Range Compression**: Multiband compressor with 4:1 ratio, 10ms attack
- **Loudness Normalization**: EBU R128 standard (-23 LUFS target)
- **Equalization**: Parametric EQ with speech intelligibility enhancement (1-4kHz boost)
- **De-essing**: Frequency-selective compression for sibilant reduction

## 4. Quality Metrics & Validation

- **PESQ Scoring**: Perceptual Evaluation of Speech Quality (ITU-T P.862)
- **STOI Measurement**: Short-Time Objective Intelligibility index
- **THD+N Analysis**: Total Harmonic Distortion plus Noise measurement
- **Enhancement Effectiveness**: Before/after SNR improvement quantification
