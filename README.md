# 🩺 Khushi Hygieia — Mobile Application (UDF)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](https://flutter.dev)
[![Release](https://img.shields.io/badge/Release-v1.0.0--APK-success)](https://github.com/EdlaAbhishek/UDF-app/releases)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Khushi Hygieia** is a next-generation, multilingual healthcare mobile application designed to bridge critical gaps in healthcare accessibility across urban and rural communities. It features intelligent AI triage, real-time OPD queue management, ABHA-compliant health records vault, family care circles, medication adherence tracking, and instant emergency dispatch.

---

## 📑 Table of Contents
1. [📲 Quick Install via Pre-built APK (No Coding Required)](#-quick-install-via-pre-built-apk-no-coding-required)
2. [✨ Key Features](#-key-features)
3. [🏗️ App Architecture](#️-app-architecture)
4. [💻 Developer Setup: Build & Run from Source](#-developer-setup-build--run-from-source)
5. [📦 Generating New Release APK & App Bundle](#-generating-new-release-apk--app-bundle)
6. [⚙️ Environment Configuration](#️-environment-configuration)
7. [🔑 Demo Test Credentials](#-demo-test-credentials)
8. [📁 Project Directory Structure](#-project-directory-structure)
9. [❓ Troubleshooting & Common Issues](#-troubleshooting--common-issues)

---

## 📲 Quick Install via Pre-built APK (No Coding Required)

If you are a **tester, doctor, patient, or evaluator**, you do **NOT** need to install Flutter or build any code. You can directly install the pre-compiled standalone Android APK (`app-release.apk`) on your phone!

### 📥 1. Getting the APK File
- **From GitHub Releases**: Go to [GitHub Releases (v1.0.0)](https://github.com/EdlaAbhishek/UDF-app/releases) and download `app-release.apk`.
- **From Local Build**: If cloned locally, the compiled binary is located at:
  ```
  build/app/outputs/flutter-apk/app-release.apk
  ```
  *(Size: ~56 MB | Universal release supporting all standard Android architectures: `arm64-v8a`, `armeabi-v7a`, `x86_64`)*

---

### 📱 2. How to Install on Any Android Phone (Step-by-Step)

#### Step 1: Transfer or Download to Phone
- Download `app-release.apk` directly on your phone using Chrome, OR
- Transfer it from your computer to your phone via USB cable, Google Drive, WhatsApp, or Telegram.

#### Step 2: Open the APK
- Open your phone's **Files**, **File Manager**, or **Downloads** folder.
- Tap on `app-release.apk`.

#### Step 3: Enable "Install Unknown Apps" (One-Time Android Permission)
- If Android blocks the installation with a warning:
  > *"For your security, your phone is not allowed to install unknown apps from this source."*
- Tap **Settings** on the prompt.
- Toggle **Allow from this source** to **ON**.
- Press the **Back** button.

#### Step 4: Complete Installation
- Tap **Install**.
- Once installed, tap **Open** to launch **Khushi Hygieia**!

---

### 💻 3. Quick Install via Computer (ADB - One Command)
If you have an Android device connected to your PC with **USB Debugging** enabled:
```bash
# Install new or reinstall existing app without losing data
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

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

## 💻 Developer Setup: Build & Run from Source

### Prerequisites
1. **Flutter SDK** (`v3.0.0` or higher) from [flutter.dev](https://docs.flutter.dev/get-started/install).
2. **Dart SDK** (included with Flutter).
3. **Android Studio** or **VS Code** with Flutter and Dart extensions.
4. **Git** in your system `PATH`.

### Step-by-Step Build Commands
```bash
# 1. Clone the repository
git clone https://github.com/EdlaAbhishek/UDF-app.git
cd UDF-app

# 2. Check Flutter environment health
flutter doctor

# 3. Download dependencies
flutter pub get

# 4. Run static analysis
flutter analyze
```

### Running on Devices
- **Connected Android Phone / Emulator**:
  ```bash
  flutter run
  ```
- **Google Chrome (Web)**:
  ```bash
  flutter run -d chrome
  ```
- **Windows Desktop**:
  ```bash
  flutter run -d windows
  ```

---

## 📦 Generating New Release APK & App Bundle

Whenever you update the code and want to generate an updated APK:

```bash
# 1. Clean previous build artifacts
flutter clean

# 2. Re-fetch packages
flutter pub get

# 3. Build optimized release APK
flutter build apk --release
```
The output file will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

To build a Google Play Store App Bundle (`.aab`):
```bash
flutter build appbundle --release
# Generated at: build/app/outputs/bundle/release/app-release.aab
```

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

### 1. "App Not Installed" on Android
- If an older or debug version with a different signing key is already installed on your phone, uninstall the existing app first, then install `app-release.apk`.
- Ensure your phone has at least 150 MB of free storage.

### 2. "Install Unknown Apps" Blocked by Play Protect
- When Google Play Protect pops up, tap **More details** and select **Install anyway**.

### 3. `flutter pub get` Fails
- Ensure your internet connection is active.
- Run `flutter clean` then retry `flutter pub get`.

### 4. Device Not Detected via USB
- Ensure **Developer Options** and **USB Debugging** are enabled on your Android phone.
- Verify ADB detects the device using `adb devices`.

---

## 📄 License
This project is licensed under the MIT License.
