# 🐄 GauRaksha – Smart Cattle Health Monitoring System

**AI-Powered Real-Time Cow Health Monitoring for Dairy Farms**
*Devsubmit 2026 | 24-Hour Hackathon Prototype*

---

## 📌 Problem Statement
Indian dairy farmers frequently suffer significant financial losses — often ₹50,000 or more per cow — due to delayed disease detection. Continuous manual monitoring of cattle health and behavior is highly impractical for small and medium-scale farmers.

**GauRaksha** is an intelligent, affordable solution that provides early warnings by combining computer vision, behavioral analysis, and real-time IoT sensor data.

---

## 🚀 Solution
GauRaksha uses a standard webcam or video feed to detect and track cows individually without requiring ear tags. It monitors lying vs. standing behavior, integrates environmental data (Temperature, Humidity, Air Quality) from an Arduino Nano, and generates instant health alerts. All data is synced in real-time to Firebase and accessible via a Flutter mobile app.

### ✨ Key Features
- Tag-free Individual Cow Detection & Tracking using YOLOv8 + IoU Tracker
- Behavior Analysis — Monitors lying and standing duration for each cow
- Real IoT Sensor Integration — Temperature, Humidity, and Air Quality via Arduino Nano
- 4-Level Health Alert System: Normal 🟢 | Watch 🟡 | Critical 🟠 | Emergency 🔴
- Intelligent Disease Risk Prediction (lameness, fever, respiratory distress, etc.)
- Mock ML Module for future machine learning upgrades
- Real-time Data Synchronization with Firebase Firestore
- Companion Flutter Mobile Dashboard with live alerts and vet contact feature

---

## 🛠 Tech Stack

| Layer                  | Technology                                      |
|------------------------|-------------------------------------------------|
| Computer Vision        | YOLOv8 (Ultralytics), OpenCV                    |
| Object Tracking        | YOLOv8 + IoU Tracker                            |
| Sensors                | Arduino Nano (Temperature, Humidity, Air Quality) |
| Alert & Decision Logic | Custom Rule Engine (Python)                     |
| Machine Learning       | Mock ML Predictor (extensible)                  |
| Backend                | Python                                          |
| Real-time Database     | Firebase Firestore                              |
| Mobile Application     | Flutter (Dart) + Firebase                       |
| Deployment             | Laptop / Raspberry Pi                           |

---

## 📂 Project Structure

GauRaksha/
├── backend/
│   ├── main.py                 # Main orchestration and live dashboard
│   ├── tracker.py              # YOLOv8-based cow detection and tracking
│   ├── sensor_sim.py           # Sensor data handling (simulated + Arduino support)
│   ├── rule_engine.py          # Health alert levels and disease logic
│   ├── ml_predictor.py         # Mock ML module for disease prediction
│   ├── firebase_push.py        # Real-time data push to Firebase
│   └── real_sensor_client.py   # Arduino Nano integration placeholder
├── cowraksha_app/              # Flutter Mobile Application
├── videos/                     # Place your cow_video.mp4 here
├── cow-health-vital-signs-datasets-main/   # Optional dataset folder
├── requirements.txt
└── README.md

---

## ⚙️ Getting Started

### 1. Clone the Repository
git clone https://github.com/subodhkryadav/GauRaksha.git
cd GauRaksha

### 2. Install Dependencies
pip install -r requirements.txt

### 3. Prepare Video Input
- Place your cow video inside the `videos/` folder and rename it to `cow_video.mp4`.
- If no video is found, the system will automatically default to the webcam.

### 4. Firebase Setup (Optional)
1. Create a new Firebase project.
2. Enable Firestore Database in test mode.
3. Download the `serviceAccount.json` file and place it inside the `backend/` folder.

### 5. Run the Backend System
cd backend
python main.py

You will see a live terminal dashboard and an OpenCV window showing detected cows with bounding boxes.

---

## 📱 Mobile App (Flutter)
The `cowraksha_app/` folder contains the companion Flutter mobile application that allows farmers to:

- View real-time health status (color-coded)
- Monitor live sensor readings (Temperature, Humidity, Air Quality)
- Track lying duration and predicted disease risks
- Contact a veterinarian with one tap

**To run the mobile app:**
cd cowraksha_app
flutter pub get
flutter run

---

## 🔮 Future Enhancements
- Full real-time integration with hardware Arduino Nano sensors
- Live camera streaming support
- Training a real ML/LSTM model using actual farm data
- Hindi voice alerts for better accessibility
- Multi-camera and cloud web dashboard support

---

## 📜 License
MIT License — Feel free to use, modify, and contribute. Especially encouraged for projects benefiting dairy farmers.

---

## 👥 Team
- Subodh Kumar Yadav – Tech Lead & Developer
- Hritik Kumar – Backend Developer
- Rohit Kumar – UI/UX & Documentation

**Built with ❤️ for Indian Dairy Farmers**
*Devsubmit 2026 – 24 Hour Hackathon*