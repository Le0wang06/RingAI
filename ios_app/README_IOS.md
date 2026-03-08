# 🍎 ScamShield - iOS Native App

## Project Structure

```
ScamShield/
├── ScamShield/
│   ├── App/
│   │   ├── ScamShieldApp.swift          # App entry point
│   │   └── ContentView.swift            # Root view
│   ├── Views/
│   │   ├── HomeView.swift               # Main screen
│   │   ├── LookupView.swift             # Number lookup screen
│   │   ├── ResultView.swift             # Results display
│   │   ├── HistoryView.swift            # Check history
│   │   └── CommunityView.swift          # Community reports
│   ├── Components/
│   │   ├── ScoreCircle.swift            # Circular score indicator
│   │   ├── ResultCard.swift             # Result information card
│   │   └── RedFlagBadge.swift           # Warning indicators
│   ├── Services/
│   │   ├── APIService.swift             # API calls
│   │   ├── DatabaseService.swift        # Core Data
│   │   ├── FirebaseService.swift        # Firebase integration
│   │   └── AreaCodeService.swift        # Area code lookup
│   ├── Models/
│   │   ├── PhoneNumber.swift            # Phone number model
│   │   ├── ScamReport.swift             # Report model
│   │   └── CallLog.swift                # History model
│   └── Utilities/
│       ├── Constants.swift              # App constants
│       └── Extensions.swift             # Helper extensions
├── Assets.xcassets/                     # Images, colors
└── Info.plist                           # App configuration
```

## Setup Instructions

### 1. Create Xcode Project

```bash
# Open Xcode
# File → New → Project
# Choose "App" template
# Product Name: ScamShield
# Interface: SwiftUI
# Language: Swift
# Bundle Identifier: com.yourteam.scamshield
```

### 2. Add Files

Copy all the Swift files from this `ios_app` folder into your Xcode project.

### 3. Install Dependencies

**Add Firebase:**
```
File → Add Packages
Search: https://github.com/firebase/firebase-ios-sdk
Add: FirebaseFirestore, FirebaseAuth
```

### 4. Configure API Keys

Create `Config.swift`:
```swift
struct Config {
    static let numverifyAPIKey = "YOUR_KEY_HERE"
    static let abstractAPIKey = "YOUR_KEY_HERE"
}
```

### 5. Add Firebase Configuration

- Download `GoogleService-Info.plist` from Firebase Console
- Drag into Xcode project root

### 6. Run the App

- Select your device or simulator
- Click Run (⌘R)
- App should launch and show the home screen

## Features Implemented

### ✅ Week 1 (Basic)
- Phone number input screen
- API integration (NumVerify)
- Basic result display
- Area code lookup
- Scam scoring

### 🚧 Week 2 (To Do)
- Community reporting
- History management
- Statistics dashboard
- Firebase integration

### 🎨 Week 3 (Polish)
- Animations
- Dark mode
- App icon
- Testing

## Key Files Explained

### ScamShieldApp.swift
Main app entry point. Sets up Firebase and navigation.

### LookupView.swift
The main screen where users enter phone numbers to check.

### APIService.swift
Handles all API calls to NumVerify and Abstract API.

### DatabaseService.swift
Manages local Core Data storage for offline access.

### PhoneNumber.swift
Data model representing phone number information.

## Running the App

```bash
# Open in Xcode
open ScamShield.xcodeproj

# Or from command line
xcodebuild -project ScamShield.xcodeproj -scheme ScamShield -sdk iphonesimulator
```

## Testing

Test on your iPhones by:
1. Connect iPhone via USB
2. Select your device in Xcode
3. Click Run
4. Trust developer certificate on device

## Common Issues

**"No such module Firebase"**
- Make sure you added Firebase packages
- Build the project once (⌘B)

**"Signing requires a development team"**
- Xcode → Targets → Signing & Capabilities
- Select your team or use automatic signing

**"GoogleService-Info.plist not found"**
- Download from Firebase Console
- Drag into Xcode (make sure "Copy items if needed" is checked)

## Next Steps

1. ✅ Get the basic template running
2. ✅ Test API integration
3. ✅ Customize UI colors/fonts
4. ✅ Add your team's features
5. ✅ Test on all team members' iPhones

## Resources

- SwiftUI Tutorials: https://developer.apple.com/tutorials/swiftui
- Firebase iOS Setup: https://firebase.google.com/docs/ios/setup
- Swift Documentation: https://swift.org/documentation/

---

**Built with ❤️ by [Your Team Name]**
