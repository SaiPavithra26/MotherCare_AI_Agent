import json
import google.generativeai as genai

from models import PatientInfo, AnalysisResponse

# ==========================================
# GEMINI API CONFIG
# ==========================================

GEMINI_API_KEY = "AIzaSyCJb02A5fqXh1aw61Q9wtzIbyRPg-VZI34"

genai.configure(api_key=GEMINI_API_KEY)

model = genai.GenerativeModel("gemini-1.5-flash")


def analyze_symptoms_with_gemma(
    text: str,
    patient_context: PatientInfo,
    language: str
) -> AnalysisResponse:

    prompt = f"""
You are a highly capable AI maternal healthcare companion for rural areas.

You must analyze the user's symptoms and classify the risk level:
Low, Moderate, Urgent, Emergency.

Return ONLY valid raw JSON.

Patient Context:
- Name: {patient_context.name}
- Age: {patient_context.age}
- Pregnancy Week: {patient_context.pregnancy_week}
- Previous Conditions: {patient_context.previous_conditions}

User Speech ({language}):
{text}

Rules:
- Do NOT diagnose diseases
- Do NOT prescribe medicines
- Give calm and safe guidance
- Respond in user's language

Return JSON in this format:

{{
  "symptoms": ["symptom1", "symptom2"],
  "urgency_level": "Moderate",
  "response_text": "response here",
  "recommendations": ["item1", "item2"],
  "confidence_score": 0.92,
  "disclaimer": "This is an AI assessment. Please consult a doctor."
}}
"""

    try:

        response = model.generate_content(prompt)

        raw_text = response.text.strip()

        # Remove markdown wrappers if Gemini adds them
        raw_text = raw_text.replace("```json", "")
        raw_text = raw_text.replace("```", "")

        result_json = json.loads(raw_text)

        return AnalysisResponse(**result_json)

    except Exception as e:

        print("Gemini Error:", e)

        return AnalysisResponse(
            symptoms=["Headache", "Swelling"],
            urgency_level="Moderate",
            response_text=(
                "தயவுசெய்து ஓய்வு எடுத்துக்கொள்ளுங்கள். "
                "தண்ணீர் அதிகமாக குடிக்கவும். "
                "அறிகுறிகள் தொடர்ந்தால் அருகிலுள்ள மருத்துவரை அணுகவும்."
                if language == "ta"
                else
                "Please take rest and drink enough water. "
                "Consult a nearby doctor if symptoms continue."
            ),
            recommendations=[
                "Take proper rest",
                "Drink enough water",
                "Visit doctor if symptoms worsen"
            ],
            confidence_score=0.70,
            disclaimer="Fallback response due to AI parsing error."
        )