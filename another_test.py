import streamlit as st
import textwrap
import google.generativeai as genai
import pandas as pd

# Load doctor's data from an Excel file
doc_data = pd.read_excel("doc_data.xlsx")

# Configure the Generative AI model
google_api_key = 'AIzaSyDJNtNl2fj65uiQwmkZpKys6_bPWKLJ05I'
genai.configure(api_key=google_api_key)
model = genai.GenerativeModel('gemini-1.5-flash')

# Function to generate a response from the model
def get_gemini_response(user_input, conversation_history):
    full_prompt = f"{conversation_history}\nUser: {user_input}\nBot:"
    response = model.generate_content(full_prompt)
    if response:
        return response.text
    else:
        return "I cannot answer that!"

# Function to format text for markdown
def to_markdown(text):
    text = text.replace('•', '  *')
    return textwrap.indent(text, ">", predicate=lambda _: True)

# Function to schedule an appointment
def schedule_appointment(doctor_name):
    # Read the current Excel file
    doc_data = pd.read_excel("doc_data.xlsx")
    
    # Find the doctor in the dataframe
    doctor = doc_data[doc_data['Names'] == doctor_name]
    
    if not doctor.empty:
        # Update the 'Appointments' column for the selected doctor
        if 'Appointments' not in doc_data.columns:
            doc_data['Appointments'] = 0
        
        doc_data.loc[doc_data['Names'] == doctor_name, 'Appointments'] += 1
        
        # Save the updated dataframe back to the Excel file
        doc_data.to_excel("doc_data.xlsx", index=False)
        
        return f"Appointment scheduled with Dr. {doctor_name}. Their appointment count has been updated."
    else:
        return f"Doctor {doctor_name} not found in the database."

# Streamlit app
st.set_page_config(page_title="Medical Symptom Chatbot", layout="wide")
st.title("Medical Symptom Chatbot")

st.write("""
    ## Welcome to the Medical Symptom Chatbot
    This chatbot will help you identify possible medical conditions based on the symptoms you provide. It will also suggest possible solutions and doctors to consult.
""")

# Initialize session state for conversation history if not already present
if 'history' not in st.session_state:
    st.session_state.history = []
    st.session_state.conversation_stage = 'initial'

# Sidebar for history
with st.sidebar:
    st.write("### Conversation History")
    if st.session_state.history:
        for entry in st.session_state.history:
            st.write(f"**User:** {entry['user']}")
            st.write(f"**Bot:** {entry['bot']}")
    else:
        st.write("No history yet.")

# User input section
user_input = st.text_input("Describe your symptoms and keep up with the follow up questions:")

if st.button('Continue'):
    if user_input:
        conversation_history = "\n".join([f"User: {entry['user']}\nBot: {entry['bot']}" for entry in st.session_state.history])
        
        prompt = ""  # Initialize prompt variable

        if st.session_state.conversation_stage == 'initial':
            prompt = f"""You are a medical chatbot. The user has described their initial symptoms. 
            Ask 2-3 follow-up questions to gather more information. Focus on key symptoms, 
            duration, severity, and any relevant medical history. Do not provide a diagnosis yet.
            
            Current conversation:
            {conversation_history}
            User: {user_input}
            Bot:"""
            
            st.session_state.conversation_stage = 'follow_up'
        
        elif st.session_state.conversation_stage == 'follow_up':
            if len(st.session_state.history) < 3:  # Continue asking follow-up questions
                prompt = f"""Based on the information provided so far, ask 1-2 more specific 
                follow-up questions to clarify the user's condition. Do not provide a diagnosis yet.
                
                Current conversation:
                {conversation_history}
                User: {user_input}
                Bot:"""
            else:  # Provide final response
                prompt = f"""You are a highly specialized medical chatbot with extensive knowledge in 
                various medical fields. Based on the conversation history and symptoms described, 
                provide a detailed analysis of the most likely conditions, taking into account common 
                and rare possibilities. Suggest appropriate medical specialists for further consultation 
                and provide specific treatment options, lifestyle changes, and potential risks. 
                Ensure that your answer is precise, medically accurate, and in the range of 200 to 300 words.
                
                Current conversation:
                {conversation_history}
                User: {user_input}
                Bot:"""
                st.session_state.conversation_stage = 'final'
        
        if prompt:  # Only call get_gemini_response if prompt is not empty
            response_text = get_gemini_response(prompt, conversation_history)

            # Store the conversation in history
            st.session_state.history.append({
                'user': user_input,
                'bot': response_text
            })
            
            # Update sidebar history
            with st.sidebar:
                st.write("### Conversation History")
                for entry in st.session_state.history:
                    st.write(f"**User:** {entry['user']}")
                    st.write(f"**Bot:** {entry['bot']}")
            
            # Display the latest response
            st.markdown(to_markdown(response_text))

            # Recommend doctors if it's the final stage
            if st.session_state.conversation_stage == 'final':
                possible_specialties = doc_data['Speciality'].str.lower().tolist()
                recommended_doctors = []

                for specialty in possible_specialties:
                    if specialty in response_text.lower():
                        recommended_doctors.append(doc_data[doc_data['Speciality'].str.lower() == specialty])

                if recommended_doctors:
                    st.write("Recommended doctors based on the conversation:")
                    for _, col in pd.concat(recommended_doctors).iterrows():
                        st.write(f"**Doctor:** {col['Names']}, **Speciality:** {col['Speciality']}, **Contact:** {col['Contact']}")
                    
                    # Add appointment scheduling option
                    selected_doctor = st.selectbox("Select a doctor to schedule an appointment:", 
                                                   options=[doc['Names'].iloc[0] for doc in recommended_doctors])
                    
                    if st.button("Schedule Appointment"):
                        appointment_message = schedule_appointment(selected_doctor)
                        st.write(appointment_message)
                else:
                    st.write("No specific doctor suggestions based on the symptoms provided.")
        else:
            st.error("An error occurred while processing your request. Please try again.")
    else:
        st.error("Please enter some symptoms or respond to the question to continue.")

# Footer
st.write("""
    ---
    Powered By Gemini | ~ Team Celestials
""")