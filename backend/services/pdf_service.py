import os
import uuid
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from models import PatientInfo, AnalysisResponse
from datetime import datetime

def generate_asha_summary_pdf(patient: PatientInfo, analysis: AnalysisResponse) -> str:
    """
    Generates a PDF summary for the ASHA worker.
    """
    output_dir = "static/pdfs"
    os.makedirs(output_dir, exist_ok=True)
    filename = f"asha_summary_{uuid.uuid4()}.pdf"
    filepath = os.path.join(output_dir, filename)

    c = canvas.Canvas(filepath, pagesize=letter)
    width, height = letter

    # Title
    c.setFont("Helvetica-Bold", 16)
    c.drawString(50, height - 50, "MotherCare - ASHA Worker Summary")
    
    # Date
    c.setFont("Helvetica", 10)
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    c.drawString(50, height - 70, f"Generated on: {current_time}")

    # Patient Info
    c.setFont("Helvetica-Bold", 12)
    c.drawString(50, height - 100, "Patient Details:")
    c.setFont("Helvetica", 12)
    c.drawString(50, height - 120, f"Name: {patient.name}")
    c.drawString(50, height - 140, f"Age: {patient.age}")
    c.drawString(50, height - 160, f"Pregnancy Week: {patient.pregnancy_week}")
    c.drawString(50, height - 180, f"Village: {patient.village}")
    if patient.previous_conditions:
        c.drawString(50, height - 200, f"Previous Conditions: {patient.previous_conditions}")

    # Assessment
    y_pos = height - 240
    c.setFont("Helvetica-Bold", 12)
    c.drawString(50, y_pos, "Assessment & Symptoms:")
    c.setFont("Helvetica", 12)
    y_pos -= 20
    c.drawString(50, y_pos, f"Urgency Level: {analysis.urgency_level}")
    y_pos -= 20
    
    c.drawString(50, y_pos, "Reported Symptoms:")
    y_pos -= 20
    for sym in analysis.symptoms:
        c.drawString(70, y_pos, f"- {sym}")
        y_pos -= 20

    y_pos -= 10
    c.setFont("Helvetica-Bold", 12)
    c.drawString(50, y_pos, "Recommendations:")
    c.setFont("Helvetica", 12)
    y_pos -= 20
    for rec in analysis.recommendations:
        c.drawString(70, y_pos, f"- {rec}")
        y_pos -= 20

    y_pos -= 30
    c.setFont("Helvetica-Oblique", 10)
    c.drawString(50, y_pos, "Disclaimer: " + analysis.disclaimer)

    c.save()
    return filepath
