
# 🐠 AquaNexis – AI & IoT Smart Aquarium Monitoring App

AquaNexis is an **AI-powered smart aquarium monitoring and automatic feeding system** designed to help aquarium owners monitor fish health, track abnormal behavior, and manage aquarium conditions through a Flutter mobile application.

The system integrates **Artificial Intelligence (AI), Internet of Things (IoT), and mobile technology** to provide intelligent aquarium monitoring, real-time notifications, and automated feeding support.

---

## 📱 App Overview

The AquaNexis Flutter application serves as the primary interface between aquarium owners and the smart aquarium system.

Users can monitor aquarium conditions, receive fish health alerts, view fish behavior, and interact with connected IoT devices through a mobile application.

### 🎯 Project Objectives

- Monitor fish behavior using AI-based detection.
- Detect abnormal fish behavior and provide notifications.
- Monitor aquarium water quality using IoT sensors.
- Support automatic fish feeding.
- Provide an intuitive and user-friendly mobile interface.
- Help aquarium owners manage aquarium health efficiently.

---

## ✨ Features

### 🐟 Fish Health Monitoring
- AI-based fish behavior detection.
- Detection of normal, abnormal, and dead fish.
- Fish monitoring through aquarium video.
- Abnormal behavior notifications.

### 🤖 AI-Powered Detection
- AI-based fish detection and classification.
- YOLO-based object detection experiments.
- Fish tracking using ByteTrack.
- Support for fish behavior analysis.

### 🌊 Aquarium Monitoring
- Water temperature monitoring.
- pH level monitoring.
- Turbidity monitoring.
- Real-time sensor data visualization.

### 🍽️ Automatic Feeding
- Automated fish feeding system.
- ESP32-based IoT integration.
- Feeding control through the smart aquarium system.

### 📲 Mobile Application
- Modern Flutter UI.
- Aquarium dashboard.
- Fish health information.
- Notification interface.
- Sensor data monitoring.
- User-friendly navigation.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter 3.38.5 | Mobile application development |
| Dart | Programming language |
| ESP32 | IoT device control |
| AI / Computer Vision | Fish behavior analysis |
| YOLO | Object detection |
| ByteTrack | Fish tracking |
| MQTT / WebSocket | Real-time communication |
| Figma | UI/UX design |

> **Note:** Update the technology list according to the libraries and communication protocols implemented in your current version.

---

## 🏗️ System Architecture

The AquaNexis system combines a Flutter mobile application, AI-based fish monitoring, and IoT hardware.

```text
                 ┌────────────────────────┐
                 │    Aquarium Camera     │
                 │  Webcam / Smartphone   │
                 └───────────┬────────────┘
                             │
                             ▼
                 ┌────────────────────────┐
                 │    AI Processing       │
                 │ Fish Detection &       │
                 │ Behavior Analysis      │
                 └───────────┬────────────┘
                             │
                             ▼
                 ┌────────────────────────┐
                 │     Backend / API      │
                 │ Data & Notifications   │
                 └───────────┬────────────┘
                             │
              ┌──────────────┴──────────────┐
              ▼                             ▼
   ┌────────────────────┐       ┌────────────────────┐
   │ Flutter Mobile App                     │       │   ESP32 IoT System                      │ 
   │ Monitoring & Alerts                   │       │ Sensors & Feeder                        │
   └────────────────────┘       └────────────────────┘
```

---

## 📂 Project Structure

```text
lib/
│
├── main.dart
│
├── core/
│   ├── theme/
│   ├── constants/
│   └── routes/
│
├── models/
│
├── providers/
│
├── services/
│
├── screens/
│   ├── home/
│   ├── aquarium/
│   ├── monitoring/
│   ├── notifications/
│   └── profile/
│
├── widgets/
│
└── utils/
```


## 📸 App Screenshots

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/099712b4-7cd4-459f-972c-a9e186c2ae82" />
---



> The folder structure above is an example. Adjust it to match your actual Flutter project.

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/rokayaraka/AquaNexis.git
```

Navigate to the project directory:

```bash
cd AquaNexis
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Connect a Device

Connect an Android device or start an Android emulator.

Check connected devices:

```bash
flutter devices
```

### 4. Run the Application

```bash
flutter run
```

---

## ⚙️ Configuration

Before running the application, configure the required services:

- Backend API base URL.
- IoT device connection settings.
- MQTT or WebSocket configuration (if implemented).
- AI inference service (if used).
- Notification settings.

**Important:** Do not commit API keys, passwords, or private credentials to GitHub.


---

## 🔬 Research & Development

AquaNexis is developed as a **Final Year Design Project (FYDP)** focused on AI-based fish behavior monitoring and IoT-enabled aquarium management.

The project explores:

- Fish behavior classification.
- Abnormal behavior detection.
- Object detection and multi-object tracking.
- AI-assisted aquarium monitoring.
- IoT-based water quality management.
- Automated feeding systems.

---

## 🔮 Future Improvements

- Real-time fish identification and tracking.
- Improved abnormal behavior detection.
- AI-based water quality correlation analysis.
- Cloud-based aquarium data storage.
- Historical monitoring and analytics.
- Smart feeding recommendations.
- Multi-aquarium support.
- Improved alert and notification management.

---


## 📄 License

This project is developed for academic and research purposes.

Add an appropriate open-source license if you plan to distribute the project publicly.

---

⭐ If you find this project interesting, consider starring the repository!
