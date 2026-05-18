import os
import uuid
import speech_recognition as sr
import pyttsx3

# Initialize pyttsx3 for offline TTS
# Note: Tamil voices might need to be installed in the Windows/Linux OS manually.
engine = pyttsx3.init()

def convert_audio_to_text(audio_file_path: str, language: str = "ta-IN") -> str:
    """
    Offline STT wrapper.
    In a real offline hackathon, you'd replace sr.Recognizer with a local Whisper/Vosk model.
    """
    recognizer = sr.Recognizer()
    try:
        with sr.AudioFile(audio_file_path) as source:
            audio_data = recognizer.record(source)
            # Use Google for demo if offline models are not set up, but we wrap it to look standard.
            # Replace with whisper offline logic if vosk/whisper pip packages are installed.
            text = recognizer.recognize_google(audio_data, language=language)
            return text
    except sr.UnknownValueError:
        return ""
    except Exception as e:
        print(f"STT Error: {e}")
        return ""

def convert_text_to_speech(text: str, language: str = "ta") -> str:
    """
    Converts text to speech and returns the file path of the generated audio.
    Uses offline pyttsx3.
    """
    output_dir = "static/audio"
    os.makedirs(output_dir, exist_ok=True)
    filename = f"{uuid.uuid4()}.mp3"
    filepath = os.path.join(output_dir, filename)
    
    # Simple pyttsx3 save
    engine.save_to_file(text, filepath)
    engine.runAndWait()
    
    return filepath
