# 🚀 Complete Setup Guide - ScamShield

## Prerequisites Installation

### 1. Install Flutter

**macOS:**
```bash
# Using Homebrew
brew install flutter

# OR download from flutter.dev
# Extract and add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

**Verify Installation:**
```bash
flutter doctor
```

Fix any issues shown by `flutter doctor` before proceeding.

### 2. Install IDE

**Option A: VS Code (Recommended for beginners)**
```bash
brew install --cask visual-studio-code

# Install Flutter extension
code --install-extension Dart-Code.flutter
```

**Option B: Android Studio**
- Download from: https://developer.android.com/studio
- Install Flutter plugin

### 3. Setup iOS Development (Mac only)

```bash
# Install Xcode from App Store
# Then install command line tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 4. Setup Android Development

```bash
# Install Android Studio
brew install --cask android-studio

# Accept licenses
flutter doctor --android-licenses
```

---

## Project Setup

### Step 1: Create Flutter Project

```bash
# Navigate to your projects folder
cd ~/Desktop/Projects/RingAI

# Create new Flutter project
flutter create scamshield_app --org com.yourteam.scamshield

# Navigate into project
cd scamshield_app
```

### Step 2: Replace with Our Structure

Copy all files from this repo into your `scamshield_app` folder.

### Step 3: Install Dependencies

```bash
# Install all packages
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build
```

---

## Firebase Setup

### Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add Project"
3. Name it: `ScamShield`
4. Disable Google Analytics (optional)
5. Click "Create Project"

### Step 2: Add iOS App

1. In Firebase Console, click "Add App" → iOS
2. iOS Bundle ID: `com.yourteam.scamshield`
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`

### Step 3: Add Android App

1. Click "Add App" → Android
2. Android Package Name: `com.yourteam.scamshield`
3. Download `google-services.json`
4. Place in: `android/app/google-services.json`

### Step 4: Enable Firestore

1. In Firebase Console → Build → Firestore Database
2. Click "Create Database"
3. Start in **Test Mode** (we'll secure later)
4. Choose location closest to you

### Step 5: Enable Authentication (Optional)

1. Firebase Console → Build → Authentication
2. Click "Get Started"
3. Enable "Anonymous" for now

---

## API Keys Setup

### Step 1: Get NumVerify API Key

1. Go to: https://numverify.com/
2. Sign up for free account
3. Get your API key (100 requests/month free)

### Step 2: Get Abstract API Key

1. Go to: https://www.abstractapi.com/api/phone-validation-api
2. Sign up for free account
3. Get your API key (250 requests/month free)

### Step 3: Configure Environment Variables

Create `.env` file in project root:

```bash
# Copy example
cp .env.example .env

# Edit with your keys
nano .env
```

Add your keys:
```
NUMVERIFY_API_KEY=your_numverify_key_here
ABSTRACT_API_KEY=your_abstract_key_here
```

**Important:** Never commit `.env` to Git!

---

## Database Setup

### Load Scam Numbers Database

```bash
# The scam database is in assets/data/scam_numbers.csv
# It will be loaded automatically on first app launch

# To update the database:
cd scripts
dart load_scam_database.dart
```

---

## Verify Setup

### Test Flutter Installation

```bash
flutter doctor -v
```

Should show ✅ for:
- Flutter
- iOS toolchain (if on Mac)
- Android toolchain
- Connected device or simulator

### Test Project Build

```bash
# iOS (Mac only)
flutter run -d ios

# Android
flutter run -d android

# You should see the app launch with a simple home screen
```

---

## IDE Setup

### VS Code Extensions

Install these extensions:
- Flutter
- Dart
- Error Lens
- GitLens
- Prettier

### VS Code Settings

Create `.vscode/settings.json`:
```json
{
  "editor.formatOnSave": true,
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.rulers": [80],
  "files.trimTrailingWhitespace": true
}
```

---

## Git Setup

### Initialize Repository

```bash
# Initialize git (if not already)
git init

# Add all files
git add .

# First commit
git commit -m "Initial project setup"

# Create repository on GitHub and push
git remote add origin https://github.com/yourteam/scamshield.git
git push -u origin main
```

### Git Workflow

See [GIT_WORKFLOW.md](GIT_WORKFLOW.md) for team collaboration.

---

## Troubleshooting

### "Flutter not found"
```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$PATH:/path/to/flutter/bin"
source ~/.zshrc
```

### "No devices found"
```bash
# iOS: Open Xcode → Window → Devices and Simulators
# Create a new simulator

# Android: Open Android Studio → AVD Manager
# Create a new virtual device
```

### "Pod install failed" (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

### "Firebase not configured"
- Double-check `google-services.json` and `GoogleService-Info.plist` placement
- Rebuild the app: `flutter clean && flutter run`

---

## Next Steps

1. ✅ Verify all setup steps complete
2. ✅ Read [TEAM_TASKS.md](TEAM_TASKS.md) for your assignments
3. ✅ Check [ROADMAP.md](ROADMAP.md) for timeline
4. ✅ Start coding! 🚀

---

**Need Help?**
- Check Flutter docs: https://docs.flutter.dev
- Ask in team chat
- Google the error message
- Ask ChatGPT/Claude for help
