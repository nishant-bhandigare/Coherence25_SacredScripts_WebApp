import streamlit as st
import pickle
import numpy as np
import os
import google.generativeai as genai
from dotenv import load_dotenv
import matplotlib.pyplot as plt
import pandas as pd
import io
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

# Load environment variables
load_dotenv()

# Configure Google Gemini API
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# Load the trained AQI prediction model
model_path = "air_quality_model.pkl"
with open(model_path, "rb") as file:
    model = pickle.load(file)

# Streamlit UI
st.set_page_config(page_title="Air Quality & Health Guide")
st.title("🌍 Air Quality Index (AQI) Prediction & Health Guide")
st.write("Enter the weather conditions to predict PM 2.5 levels and get health + environment recommendations.")

# Input fields
T = st.number_input("🌡 Temperature (°C)", value=25.0)
TM = st.number_input("🌞 Max Temperature (°C)", value=30.0)
Tm = st.number_input("❄ Min Temperature (°C)", value=20.0)
SLP = st.number_input("🌪 Sea Level Pressure (hPa)", value=1013.0)
H = st.number_input("💧 Humidity (%)", value=60.0)
VV = st.number_input("👀 Visibility (km)", value=5.0)
V = st.number_input("🌬 Wind Speed (km/h)", value=10.0)
VM = st.number_input("💨 Max Wind Speed (km/h)", value=15.0)

# Prediction button
if st.button("🚀 Predict AQI (PM 2.5)"):

    # Prepare input data
    input_data = np.array([[T, TM, Tm, SLP, H, VV, V, VM]])
    
    # Make prediction
    pm25_level = model.predict(input_data)[0]
    
    # Display AQI level
    st.subheader(f"📊 Predicted PM 2.5 Level: {pm25_level:.2f} µg/m³")
    
    # Determine AQI category
    if pm25_level <= 50:
        aqi_category = "Good 😊"
        aqi_color = "green"
    elif pm25_level <= 100:
        aqi_category = "Moderate 😐"
        aqi_color = "yellow"
    elif pm25_level <= 150:
        aqi_category = "Unhealthy for Sensitive Groups 😷"
        aqi_color = "orange"
    elif pm25_level <= 200:
        aqi_category = "Unhealthy 🚨"
        aqi_color = "red"
    elif pm25_level <= 300:
        aqi_category = "Very Unhealthy ☠️"
        aqi_color = "purple"
    else:
        aqi_category = "Hazardous ⚠️"
        aqi_color = "maroon"

    st.markdown(f"<h3 style='color:{aqi_color};'>AQI Category: {aqi_category}</h3>", unsafe_allow_html=True)

    # Visualization: Simple bar chart for AQI levels
    st.subheader("📊 AQI Level Visualization")
    categories = ["Good", "Moderate", "Unhealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous"]
    levels = [50, 100, 150, 200, 300, 500]
    colors = ["green", "yellow", "orange", "red", "purple", "maroon"]

    plt.figure(figsize=(8, 4))
    plt.bar(categories, levels, color=colors, alpha=0.7)
    plt.axhline(y=pm25_level, color="blue", linestyle="--", label=f"Predicted PM 2.5: {pm25_level:.2f}")
    plt.xlabel("AQI Categories")
    plt.ylabel("PM 2.5 Levels (µg/m³)")
    plt.title("AQI Levels and Predicted PM 2.5")
    plt.legend()
    st.pyplot(plt)

    # Define Gemini prompt for health recommendations & AQI improvement
    health_prompt = f"""
    You are an AI environmental and health advisor. The predicted PM 2.5 level is {pm25_level:.2f} µg/m³, categorized as '{aqi_category}'.

    Based on this AQI level, provide detailed insights on:
    1. Health impacts and precautions.
    2. Immediate preventive measures.
    3. Long-term solutions to improve AQI.
    4. Sustainable practices for maintaining AQI.
    """

    # Get response from Google Gemini
    model = genai.GenerativeModel('gemini-1.5-pro')
    response = model.generate_content(health_prompt)
    health_advice = response.text

    # Display health recommendations & solutions
    st.subheader("🩺 Health & Environmental Recommendations")
    st.write(health_advice)

    # Generate a downloadable PDF report
    st.subheader("📄 Download Report")

    def create_pdf():
        buffer = io.BytesIO()
        c = canvas.Canvas(buffer, pagesize=letter)
        width, height = letter

        c.setFont("Helvetica-Bold", 16)
        c.drawString(200, height - 50, "Air Quality Report")

        c.setFont("Helvetica", 12)
        c.drawString(50, height - 80, f"Temperature (°C): {T}")
        c.drawString(50, height - 100, f"Max Temperature (°C): {TM}")
        c.drawString(50, height - 120, f"Min Temperature (°C): {Tm}")
        c.drawString(50, height - 140, f"Sea Level Pressure (hPa): {SLP}")
        c.drawString(50, height - 160, f"Humidity (%): {H}")
        c.drawString(50, height - 180, f"Visibility (km): {VV}")
        c.drawString(50, height - 200, f"Wind Speed (km/h): {V}")
        c.drawString(50, height - 220, f"Max Wind Speed (km/h): {VM}")
        c.drawString(50, height - 240, f"Predicted PM 2.5 (µg/m³): {pm25_level:.2f}")
        c.drawString(50, height - 260, f"AQI Category: {aqi_category}")

        c.setFont("Helvetica-Bold", 14)
        c.drawString(50, height - 290, "Health & Environmental Recommendations:")

        text = c.beginText(50, height - 310)
        text.setFont("Helvetica", 10)
        text.textLines(health_advice[:4000])  # Avoid text overflow
        c.drawText(text)
        c.save()

        buffer.seek(0)
        return buffer

    pdf_file = create_pdf()

    st.download_button(
        label="📥 Download Report as PDF",
        data=pdf_file,
        file_name="AQI_Report.pdf",
        mime="application/pdf"
    )

# Footers
st.markdown("""
    ---
    🌱 *This AI-powered tool helps predict air quality and suggests ways to improve & maintain a clean environment.*  
    *Stay safe, breathe fresh! 💚*
""")
