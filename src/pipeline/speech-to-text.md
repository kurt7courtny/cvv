# Speech-to-Text Service

## File Location
`src/pipeline/stt/transcriber.py`

## Features
- Multi-language speech recognition
- Timestamp-accurate transcription
- Confidence scoring for each word/phrase
- Custom vocabulary and domain adaptation
- Real-time streaming transcription
- Integration with multiple STT providers (OpenAI Whisper, Google, Azure)

## Key Functions
```python
async def transcribe_audio(audio_data: AudioData, language: str) -> Transcript
async def generate_subtitles(transcript: Transcript) -> SubtitleFile
async def validate_transcription(transcript: Transcript) -> QualityScore
```

## Implementation Requirements
- OpenAI Whisper integration
- Multi-provider STT support (Google, Azure)
- Timestamp synchronization
- Confidence scoring system
- Custom vocabulary support
- Real-time streaming capabilities
- Subtitle generation (SRT, VTT formats)
- Quality validation and scoring
- Language detection and support
