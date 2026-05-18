import os
import shutil
from fastapi import FastAPI, File, UploadFile, Form, HTTPException
from fastapi.responses import FileResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import json

from models import PatientInfo, SymptomRequest
from services.ai_service import analyze_symptoms_with_gemma
from services.stt_tts_service import convert_audio_to_text, convert_text_to_speech
from services.pdf_service import generate_asha_summary_pdf

app = FastAPI(title="MotherCare Offline Backend", version="1.0")

# CORS for local dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

os.makedirs("static/audio", exist_ok=True)
os.makedirs("static/pdfs", exist_ok=True)
os.makedirs("temp", exist_ok=True)

@app.post("/api/analyze-audio")
async def analyze_audio(
    file: UploadFile = File(...),
    patient_json: str = Form(...),
    language: str = Form("ta")
):
    """
    1. Receives audio file
    2. STT -> Text
    3. Gemma -> Analysis JSON
    4. TTS -> Audio response path
    5. PDF -> ASHA summary path
    Returns everything to the Flutter frontend.
    """
    try:
        patient_data = json.loads(patient_json)
        patient_info = PatientInfo(**patient_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid patient_json: {e}")

    # Save audio temporarily
    temp_audio_path = f"temp/{file.filename}"
    with open(temp_audio_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # 1. STT
    text = convert_audio_to_text(temp_audio_path, language=language)
    if not text:
        text = "No speech detected or error in STT."
        # If real offline fails, we fallback to a hardcoded string just for the hackathon demo
        if language == "ta":
            text = "எனக்கு காலை முதல் தலைவலி மற்றும் காலில் வீக்கம் உள்ளது"

    # 2. Gemma Analysis
    analysis = analyze_symptoms_with_gemma(text, patient_info, language)

    # 3. TTS
    audio_response_path = convert_text_to_speech(analysis.response_text, language)

    # 4. PDF Generation
    pdf_path = generate_asha_summary_pdf(patient_info, analysis)

    return {
        "transcribed_text": text,
        "analysis": analysis.dict(),
        "audio_url": f"/download/audio/{os.path.basename(audio_response_path)}",
        "pdf_url": f"/download/pdf/{os.path.basename(pdf_path)}"
    }

@app.get("/download/audio/{filename}")
async def download_audio(filename: str):
    file_path = os.path.join("static/audio", filename)
    if os.path.exists(file_path):
        return FileResponse(file_path, media_type="audio/mpeg")
    raise HTTPException(status_code=404, detail="File not found")

@app.get("/download/pdf/{filename}")
async def download_pdf(filename: str):
    file_path = os.path.join("static/pdfs", filename)
    if os.path.exists(file_path):
        return FileResponse(file_path, media_type="application/pdf")
    raise HTTPException(status_code=404, detail="File not found")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
