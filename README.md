# 🛡️ ScamShield (RingAI) - AI-Powered Phone Number Intelligence

**A cross-platform mobile app (iOS & Android) that helps users identify scam phone numbers before answering.**

## 📱 What It Does

- **Manual Number Lookup**: User enters a phone number to check if it's a scam
- **Area Code Analysis**: Geographic location and red flag detection
- **Multi-Source Verification**: Checks against local database + multiple APIs
- **Community Reports**: Users can report and view scam reports
- **Intelligence Dashboard**: View statistics and trends

## 🎯 Project Info

- **Timeline**: 3-4 weeks
- **Team Size**: 4 people
- **Platforms**: iOS + Android (single codebase)
- **Tech Stack**: Flutter, Firebase, Dart

## ✨ Key Features

### Core Features (Week 1)
- ✅ Phone number input with validation
- ✅ Area code location lookup
- ✅ Carrier & line type detection (VOIP detection)
- ✅ Check against 10,000+ known scam numbers
- ✅ API integration (NumVerify, Abstract API)
- ✅ Scam confidence score (0-100)

### Extended Features (Week 2)
- ✅ Community reporting system
- ✅ Search history
- ✅ Detailed analysis breakdown
- ✅ Red flag detection (patterns, spoofing)
- ✅ Beautiful modern UI with animations

### Polish Features (Week 3)
- ✅ Statistics dashboard
- ✅ Trending scams feed
- ✅ Export functionality
- ✅ Educational content
- ✅ Dark mode support

## 🏗️ Architecture

```
ScamShield/
├── Frontend: Flutter (Dart)
├── Backend: Firebase (Firestore + Cloud Functions)
├── Local DB: SQLite (10k+ scam numbers)
├── APIs: NumVerify, Abstract API
└── State Management: Provider/Riverpod
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- API keys (NumVerify, Abstract API)

### Setup Instructions

1. **Install Flutter**
   ```bash
   # macOS
   brew install flutter
   
   # Verify installation
   flutter doctor
   ```

2. **Clone and Setup**
   ```bash
   cd scamshield_app
   flutter pub get
   ```

3. **Configure Firebase**
   - Follow `docs/FIREBASE_SETUP.md`
   - Download `google-services.json` (Android)
   - Download `GoogleService-Info.plist` (iOS)

4. **Add API Keys**
   - Copy `.env.example` to `.env`
   - Add your API keys
   ```
   NUMVERIFY_API_KEY=your_key_here
   ABSTRACT_API_KEY=your_key_here
   ```

5. **Run the App**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   ```

## 👥 Team Structure

### Person 1: UI/UX Lead
- Screens design and implementation
- Animations and transitions
- App icon and branding

### Person 2: API & Backend
- API integrations
- Firebase setup
- Data parsing

### Person 3: Features & Database
- Local database
- Community features
- History management

### Person 4: Documentation & Testing
- Testing on devices
- Documentation
- Demo preparation

## 📚 Documentation

- [Complete Setup Guide](docs/SETUP_GUIDE.md)
- [Team Tasks Breakdown](docs/TEAM_TASKS.md)
- [Week-by-Week Roadmap](docs/ROADMAP.md)
- [Firebase Configuration](docs/FIREBASE_SETUP.md)
- [API Integration Guide](docs/API_GUIDE.md)
- [Git Workflow](docs/GIT_WORKFLOW.md)

## 🎬 Demo

- Demo Video: Coming soon
- Presentation: See `docs/PRESENTATION.md`

## 📊 Progress Tracking

- [ ] Week 1: Core functionality
- [ ] Week 2: Features & polish
- [ ] Week 3: Testing & demo prep

## 🤝 Contributing

See [TEAM_TASKS.md](docs/TEAM_TASKS.md) for your specific responsibilities.

## 📄 License

MIT License - Student Project

---

**Built by [Your Team Name] - University Project 2026**
