# 🩺 Khushi Hygieia — Mobile Application (UDF)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Khushi Hygieia** is a next-generation, multilingual healthcare mobile application designed to bridge critical gaps in healthcare accessibility across urban and rural communities. It features intelligent AI triage, real-time OPD queue management, ABHA-compliant health records vault, family care circles, medication adherence tracking, and instant emergency dispatch.

---

## 📑 Table of Contents
1. [Key Features](#-key-features)
2. [App Architecture](#-app-architecture)
3. [Prerequisites](#-prerequisites)
4. [Step-by-Step Installation Guide](#-step-by-step-installation-guide)
5. [Running the Application](#-running-the-application)
6. [Building for Production (Android APK / AAB)](#-building-for-production-android-apk--aab)
7. [Environment Configuration](#-environment-configuration)
8. [Demo Test Credentials](#-demo-test-credentials)
9. [Project Directory Structure](#-project-directory-structure)
10. [Troubleshooting & Common Issues](#-troubleshooting--common-issues)

---

## ✨ Key Features

- **🤖 Khushi Care AI Assistant**: Multilingual conversational health guidance and structured clinical symptom checker in English, Hindi, and Telugu.
- **🏥 Hospital & Doctor Discovery**: Filter network hospitals by specialty, beds, rating, and distance with direct consultation booking.
- **⏱️ Live OPD Queue Tokens**: Real-time waiting list tracking with dynamic wait-time estimation and cafeteria departure notifications.
- **📂 Health Vault**: ABHA-compliant digital health locker for prescriptions, lab diagnostics, and radiology with 30-minute secure share codes.
- **💊 Smart Medication Adherence**: Daily pill checklists with meal timing, notifications, adherence percentages, and streak tracking.
- **🚨 Instant Emergency SOS**: One-touch 108 / 112 dialing, emergency contact alerts, and nearest trauma center locator.
- **👨‍👩‍👧 Family Care Circle**: Manage health profiles of elderly dependents and children with granular access control.
- **🩸 Community Blood Bank**: Fast voluntary donor discovery by blood group and regional health drives.
- **📹 Teleconsultation**: Built-in video consultation room with microphone, camera, and chat controls.
- **👩‍⚕️ ASHA Health Worker Mode**: Offline-ready rapid vitals screening for rural health workers.

---

## 🏗️ App Architecture

The app follows a clean, reactive architecture utilizing **Provider** for state management and modular services for clean separation of concerns:

```
lib/
├── core/            # Theme tokens, colors, typography, global constants & utilities
├── models/          # Data models with JSON serialization
├── navigation/      # Route names and central router
├── providers/       # ChangeNotifier reactive state providers
├── screens/         # UI screens organized by domain feature
├── services/        # Supabase client, OpenRouter AI, API layers
└── widgets/         # Reusable design system UI components
```

---

## 📋 Prerequisites

Before running the app, ensure your development machine has:

1. **Flutter SDK** (`v3.0.0` or higher):
   - Check version:
     ```bash
     flutter --version
     ```
   - If not installed, download from [flutter.dev](https://docs.flutter.dev/get-started/install).

2. **Dart SDK** (included automatically with Flutter).

3. **Android Studio** or **VS Code**:
   - For VS Code: Install the **Flutter** and **Dart** extensions.
   - For Android Studio: Install the Flutter plugin and Android SDK Command-line Tools.

4. **Git**: Installed and available in your system `PATH`.

5. **A Device to Run On**:
   - An Android Emulator (configured via Android Studio AVD Manager), OR
   - A physical Android phone with **USB Debugging** enabled, OR
   - Google Chrome (for Flutter Web), OR
   - Windows desktop environment.

---

## 🚀 Step-by-Step Installation Guide

### Step 1: Clone the Repository
```bash
git clone https://github.com/EdlaAbhishek/UDF-app.git
cd UDF-app
```

### Step 2: Verify Flutter Environment
Run Flutter doctor to check if all necessary toolchains are ready:
```bash
flutter doctor
```
Ensure Android toolchain and connected devices checkmarks are green.

### Step 3: Fetch Dependencies
Download all required Flutter packages and libraries:
```bash
flutter pub get
```

### Step 4: Validate Code Health
Verify that there are no compilation or lint warnings:
```bash
flutter analyze
```

---

## 📱 Running the Application

### Option A: Run on Connected Android Device or Emulator
1. Connect your Android phone via USB (with USB Debugging turned on) or launch an Android emulator from Android Studio.
2. Verify device detection:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Option B: Run on Web (Google Chrome)
```bash
flutter run -d chrome
```

### Option C: Run on Windows Desktop
```bash
flutter run -d windows
```

### Option D: Run with Hot Reload in VS Code
1. Open the project folder in VS Code.
2. Press `F5` or click **Run > Start Debugging**.
3. Use `r` in the debug console for hot reload, or `R` for hot restart.

---

## 📦 Building for Production (Android APK / AAB)

### 1. Build Android Release APK
To create a standalone installable APK:
```bash
flutter build apk --release
```
The output file will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```
You can transfer and install this APK directly onto any Android phone.

### 2. Build Android App Bundle (for Google Play Store)
```bash
flutter build appbundle --release
```
The output bundle will be located at:
```
build/app/outputs/bundle/release/app-release.aab
```

### 3. Build Web Bundle
```bash
flutter build web --release
```
Output files will be in `build/web/`.

---

## ⚙️ Environment Configuration

The application uses standard Flutter `--dart-define` parameters for configuration.

| Variable | Description | Default |
| :--- | :--- | :--- |
| `SUPABASE_URL` | Your Supabase project URL | Cloud instance |
| `SUPABASE_ANON_KEY` | Public Supabase client key | Client key |
| `OPENROUTER_API_KEY`| OpenRouter AI API key | Custom injection |
| `OPENROUTER_MODEL`  | AI model identifier | `nex-agi/nex-n2.5-mini:free` |
| `BACKEND_BASE_URL`  | Optional custom server URL | Cloud backend |

To run the app with custom keys:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=OPENROUTER_API_KEY=your-openrouter-key
```

---

## 🔑 Demo Test Credentials

Instant one-tap login chips are built directly into the Login screen for testing:

| Role | Email | Password | Included Features |
| :--- | :--- | :--- | :--- |
| 🧑‍⚕️ **Patient** | `patient.demo@khushi.in` | `Demo@1234` | Live OPD Token, Health Vault, Medication Tracker, Appointments |
| 👨‍⚕️ **Doctor** | `doctor.demo@khushi.in` | `Demo@1234` | Queue Management, Triage Patient List, Teleconsultation |
| 🛡️ **Admin** | `admin.demo@khushi.in` | `Demo@1234` | System KPI Metrics, Doctor Verification, Network Monitoring |

---

## 📁 Project Directory Structure

```
UDF-app/
├── android/                   # Native Android host project & Gradle configuration
├── assets/                    # Static branding, logo, and visual media
│   ├── family-hero.jpg
│   └── logo.png
├── ios/                       # Native iOS host project & CocoaPods configuration
├── lib/                       # Main Flutter application Dart code
│   ├── main.dart              # Application entry point
│   ├── core/                  # App themes, design tokens, constants & utilities
│   │   ├── constants/
│   │   ├── theme/
│   │   └── utils/
│   ├── models/                # Typed data models
│   ├── navigation/            # Routing configuration & route names
│   ├── providers/             # Reactive state management providers
│   ├── screens/               # Feature screens (Auth, AI, Hospitals, Vault, etc.)
│   ├── services/              # Supabase, AI, and HTTP services
│   └── widgets/               # Reusable UI components
├── test/                      # Unit and widget test suites
├── web/                       # Web runner configuration & manifest
├── windows/                   # Windows desktop runner configuration
├── analysis_options.yaml      # Dart static analysis & lint rules
├── pubspec.yaml               # Package dependencies & asset declarations
├── pubspec.lock               # Deterministic dependency lockfile
└── README.md                  # Project setup and documentation
```

---

## ❓ Troubleshooting & Common Issues

### 1. `flutter pub get` Fails
- Ensure your internet connection is active.
- Run `flutter clean` then retry `flutter pub get`.

### 2. Android Gradle Build Fails
- Check that Android SDK licenses are accepted:
  ```bash
  flutter doctor --android-licenses
  ```
- Make sure JDK 17 or JDK 21 is configured in Android Studio.

### 3. Device Not Detected
- For physical devices: Ensure **Developer Options** and **USB Debugging** are enabled on your Android phone.
- Verify ADB detects the device:
  ```bash
  adb devices
  ```

### 4. OpenRouter AI Chat Offline Warning
- If you haven't provided an `OPENROUTER_API_KEY`, the app gracefully displays structured clinical guidance and medical safety advice through its offline fallback engine.

---

## 📄 License
This project is licensed under the MIT License.
