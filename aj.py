import os
from flask import Flask, request, jsonify
from dotenv import load_dotenv
import pandas as pd
import google.generativeai as genai
from io import BytesIO
from PIL import Image

# Load environment variables
load_dotenv()
google_api_key = os.getenv("google_api_key")
# Configure Google Generative AI model
genai.configure(api_key=google_api_key)
model = genai.GenerativeModel('gemini-1.5-pro')

# Initialize the Flask app
app = Flask(__name__)

# Load doctor's data from Excel
try:
    doc_data = pd.read_excel("doc_data.xlsx")
except Exception as e:
    print(f"Error loading doctor data: {e}")
    raise

# Helper function to schedule an appointment
def schedule_appointment(doctor_name):
    try:
        doctor = doc_data[doc_data['Names'] == doctor_name]
        if not doctor.empty:
            if 'Appointments' not in doc_data.columns:
                doc_data['Appointments'] = 0
            doc_data.loc[doc_data['Names'] == doctor_name, 'Appointments'] += 1
            doc_data.to_excel("doc_data.xlsx", index=False)
            return f"Appointment scheduled with Dr. {doctor_name}."
        else:
            return f"Doctor {doctor_name} not found."
    except Exception as e:
        print(f"Error scheduling appointment: {e}")
        return "An error occurred while scheduling the appointment."

# Helper function to get a response from the AI model
def get_gemini_response(prompt, image=None):
    try:
        if image:
            response = model.generate_content([prompt, image])
        else:
            response = model.generate_content(prompt)
        if response:
            return response.text
        else:
            return "Unable to generate a response."
    except Exception as e:
        print(f"Error generating response from AI model: {e}")
        return "An error occurred while generating a response."


@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Welcome To Doc Talk"})

# API route to handle text and image input
@app.route("/chatbot/", methods=["POST"])
def chatbot():
    try:
        prompt = request.form.get('prompt')
        image = request.files.get('image')
        img = None
        if image:
            image_bytes = image.read()
            img = Image.open(BytesIO(image_bytes))
            img.save('upload.png') 

        response_text = get_gemini_response(prompt, img)

        # Find recommended doctors based on the response
        possible_specialties = doc_data['Speciality'].str.lower().tolist()
        recommended_doctors = []
        for specialty in possible_specialties:
            if specialty in response_text.lower():
                recommended_doctors.append(doc_data[doc_data['Speciality'].str.lower() == specialty])

        return jsonify({
            "bot_response": response_text,
            "recommended_doctors": recommended_doctors[:3]  # Limit to top 3 recommendations
        })
    except Exception as e:
        print(f"Error in chatbot endpoint: {e}")
        return jsonify({"detail": "Internal Server Error"}), 500

# API route to schedule an appointment
@app.route("/schedule/", methods=["POST"])
def schedule():
    try:
        doctor_name = request.form.get('doctor_name')
        appointment_message = schedule_appointment(doctor_name)
        return jsonify({"message": appointment_message})
    except Exception as e:
        print(f"Error in schedule endpoint: {e}")
        return jsonify({"detail": "Internal Server Error"}), 500


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
