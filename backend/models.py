from pydantic import BaseModel
from typing import Optional, List, Dict, Any

class PatientInfo(BaseModel):
    name: str
    age: int
    pregnancy_week: int
    preferred_language: str
    village: str
    previous_conditions: Optional[str] = None

class SymptomRequest(BaseModel):
    text: str
    language: str = "ta"
    patient_context: PatientInfo

class AnalysisResponse(BaseModel):
    symptoms: List[str]
    urgency_level: str  # Low, Moderate, Urgent, Emergency
    response_text: str  # The calm response in the requested language
    recommendations: List[str]
    confidence_score: float
    disclaimer: str

class TextToSpeechRequest(BaseModel):
    text: str
    language: str = "ta"
