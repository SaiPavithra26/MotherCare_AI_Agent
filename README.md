# MotherCare - Offline Maternal Risk Companion

MotherCare is an offline-first maternal healthcare companion powered by Gemma 4 (via Ollama). Designed for low-literacy users in rural communities, it offers voice-first interaction, maternal danger sign detection, and ASHA worker support.

## Architecture
- **Frontend**: Flutter (Riverpod, GoRouter, Hive, flutter_animate)
- **Backend**: FastAPI (Python)
- **AI**: Gemma locally using Ollama
- **Speech**: Offline STT & TTS wrappers

## Setup Instructions

### 1. Prerequisites
- Python 3.10+
- Flutter SDK
- Ollama installed locally

### 2. Backend Setup
```bash
cd backend
python -m venv venv
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
source venv/bin/activate

pip install -r requirements.txt
```

### 3. AI Setup (Ollama)
Ensure Ollama is running and download the Gemma model:
```bash
ollama run gemma:2b
```
*(You can update the model name in `backend/services/ai_service.py` based on the exact version of Gemma you have downloaded, e.g. `gemma3` or `gemma:2b`)*

### 4. Running the Backend Server
```bash
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
The server will be available at `http://localhost:8000`.

### 5. Frontend Setup
Open a new terminal.
```bash
cd frontend
flutter pub get
```

#### Android Emulator Note:
By default, the Flutter app's `api_service.dart` points to `http://10.0.2.2:8000` which maps to your computer's `localhost` on Android emulators. If you are using a physical device, update the IP address in `frontend/lib/services/api_service.dart` to your computer's local Wi-Fi IP address (e.g., `http://192.168.1.5:8000`).

### 6. Running the Flutter App
```bash
cd frontend
flutter run
```

## Features Demo Walkthrough
1. **Onboarding**: Enter the mother's details (Name, Age, Pregnancy Week).
2. **Dashboard**: View the current week and tap the large microphone button to enter the assistant.
3. **Voice Interaction**: Tap the mic and speak (e.g., in Tamil: "எனக்கு காலை முதல் தலைவலி...").
4. **Processing**: The waveform pulses while the audio is sent to the local edge server (FastAPI).
5. **AI Analysis**: Gemma analyzes the symptoms, classifying the risk level and generating a calm, mother-tongue response.
6. **Result & PDF**: The app displays the risk level and plays the voice response. A PDF is automatically generated on the backend for ASHA workers.
