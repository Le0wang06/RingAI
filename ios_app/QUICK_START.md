# 🚀 Quick Start Guide - iOS App

## Get Running in 30 Minutes!

### Step 1: Create Xcode Project (5 min)

1. Open Xcode
2. File → New → Project
3. Choose **App** template
4. Settings:
   - Product Name: `ScamShield`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Bundle ID: `com.yourteam.scamshield`
5. Click Create

### Step 2: Add These Files (10 min)

**Copy all files from `ios_app/` folder into your Xcode project:**

```
1. Drag files into Xcode sidebar
2. Check "Copy items if needed"
3. Make sure "Add to targets: ScamShield" is checked
```

**File structure in Xcode:**
```
ScamShield/
├── ScamShieldApp.swift          ← Main entry point
├── Config.swift                 ← API keys (edit this!)
├── Views/
│   ├── HomeView.swift
│   ├── LookupView.swift
│   ├── ResultView.swift
│   ├── HistoryView.swift
│   └── CommunityView.swift
├── Models/
│   └── PhoneNumber.swift
├── Services/
│   ├── APIService.swift
│   └── DatabaseService.swift
├── Info.plist
└── Assets.xcassets/
```

### Step 3: Install Firebase (5 min)

1. In Xcode: File → Add Packages
2. Enter: `https://github.com/firebase/firebase-ios-sdk`
3. Click "Add Package"
4. Select these products:
   - ✅ FirebaseFirestore
   - ✅ FirebaseAuth (optional)
5. Click "Add Package"

### Step 4: Configure API Keys (3 min)

**Edit `Config.swift`:**

```swift
static let numverifyAPIKey = "your_actual_key_here"
static let abstractAPIKey = "your_actual_key_here"
```

**Get API keys:**
- NumVerify: https://numverify.com/ (free 100 calls/month)
- Abstract: https://abstractapi.com/ (free 250 calls/month)

### Step 5: Setup Firebase (5 min)

1. Go to https://console.firebase.google.com/
2. Create new project: "ScamShield"
3. Add iOS app
4. Bundle ID: `com.yourteam.scamshield`
5. Download `GoogleService-Info.plist`
6. Drag into Xcode project root
7. Make sure "Copy items" is checked

### Step 6: Create Core Data Model (2 min)

1. File → New → File
2. Choose "Data Model"
3. Name it: `ScamShield`
4. Add 3 entities (click + button):

**Entity 1: ScamNumberEntity**
- phoneNumber (String)
- scamType (String)
- reportCount (Integer 32)
- lastReported (Date)

**Entity 2: CallHistoryEntity**
- id (UUID)
- phoneNumber (String)
- scamScore (Integer 16)
- isScam (Boolean)
- location (String, optional)
- checkedAt (Date)

**Entity 3: BlockedNumberEntity**
- phoneNumber (String)
- note (String, optional)
- addedAt (Date)

### Step 7: Run the App! ▶️

1. Select your device or simulator
2. Click Run (▶️ button or ⌘R)
3. App should launch!

---

## What You'll See

### Home Screen
- Welcome message
- "Check Phone Number" button
- Stats cards (will be 0 initially)
- Quick tips

### Tap "Check Phone Number"
- Enter: `+1 (555) 123-4567`
- Tap "Check Number"
- See results!

---

## Testing the App

### Test Numbers:

**Safe number:**
```
+1 (555) 123-4567
```

**Test with mock scam (edit APIService.swift):**
```swift
// In APIService.swift, change this line:
if phoneNumber.contains("555-0123") {
    return .mockScam  // Shows high-risk scam result
}
```

Then test with:
```
+1 (561) 555-0123
```

---

## Common Issues & Fixes

### ❌ "No such module 'Firebase'"
**Fix:**
1. Product → Clean Build Folder (⇧⌘K)
2. Close Xcode
3. Delete derived data: `~/Library/Developer/Xcode/DerivedData`
4. Reopen Xcode
5. Build (⌘B)

### ❌ "GoogleService-Info.plist not found"
**Fix:**
1. Make sure file is in project root (same level as Info.plist)
2. Right-click file → Show File Inspector
3. Check "Target Membership" includes ScamShield

### ❌ "No devices found"
**Fix:**
1. Window → Devices and Simulators
2. Click + to add simulator
3. Choose iPhone 14 or newer

### ❌ "Signing requires a development team"
**Fix:**
1. Click project name in sidebar
2. Select "ScamShield" target
3. Signing & Capabilities tab
4. Team: Select your Apple ID
5. Or enable "Automatically manage signing"

### ❌ App builds but crashes immediately
**Fix:**
1. Check Console for error message (⌘Y to show)
2. Most common: Firebase not configured
3. Make sure GoogleService-Info.plist is added
4. Rebuild: ⇧⌘K then ⌘B

---

## Next Steps

### Week 1 Tasks:
- [ ] Get app running on all team members' devices
- [ ] Test with real phone numbers
- [ ] Customize colors/fonts in `HomeView.swift`
- [ ] Add your team name in settings

### Week 2 Tasks:
- [ ] Implement Firebase community reports
- [ ] Add history functionality
- [ ] Create custom app icon
- [ ] Implement pattern detection

### Week 3 Tasks:
- [ ] Polish UI
- [ ] Test extensively
- [ ] Create demo video
- [ ] Prepare presentation

---

## Customization Ideas

### Change App Colors:
Edit views, change `.blue` to your color:
```swift
.background(Color.purple)  // or .green, .red, etc.
.foregroundColor(.orange)
```

### Change App Icon:
1. Create 1024x1024 image
2. Assets.xcassets → AppIcon
3. Drag image into slots

### Change App Name:
1. Targets → ScamShield
2. General tab
3. Display Name: "Your Name"

---

## Resources

**SwiftUI Tutorials:**
- https://developer.apple.com/tutorials/swiftui
- https://www.hackingwithswift.com/100/swiftui

**Firebase iOS:**
- https://firebase.google.com/docs/ios/setup

**Stack Overflow:**
- Search: "SwiftUI [your question]"

**YouTube:**
- Search: "SwiftUI tutorial for beginners"
- Sean Allen, Paul Hudson channels

---

## Team Collaboration

### Sharing Code:
Since you're sharing 1-2 Macs:

**Option 1: Git (Recommended)**
```bash
cd ~/Desktop/ScamShield
git init
git add .
git commit -m "Initial iOS app"
git remote add origin [your-repo-url]
git push
```

**Option 2: AirDrop**
- Right-click Xcode project folder
- Compress
- AirDrop to teammates

**Option 3: iCloud**
- Store project in iCloud Drive
- Share folder with team

---

## Getting Help

1. **Check Console logs** (⌘Y) - shows error messages
2. **Google the error** - usually has StackOverflow answer
3. **Ask ChatGPT/Claude** - paste error message
4. **Ask team** - someone might know!
5. **Check Apple docs** - developer.apple.com

---

## Success Checklist

After setup, you should be able to:
- ✅ App runs without crashing
- ✅ Home screen displays
- ✅ Can open lookup sheet
- ✅ Can type phone number
- ✅ "Check Number" button works
- ✅ (Mock) results display

---

**Ready to code? Let's build! 🚀**

Questions? Check the main README_IOS.md for more details.
