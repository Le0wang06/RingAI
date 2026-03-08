# 🔥 Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click **"Add project"**
3. Enter project name: **"ScamShield"**
4. Click Continue
5. Disable Google Analytics (optional for this project)
6. Click **"Create project"**
7. Wait for project creation (~30 seconds)
8. Click **"Continue"** when done

---

## Step 2: Register Your Apps

### For iOS:

1. In Firebase Console, click **iOS icon** to add iOS app
2. Fill in details:
   - **iOS bundle ID**: `com.yourteam.scamshield`
   - **App nickname**: "ScamShield iOS"
   - Click **"Register app"**

3. Download **GoogleService-Info.plist**

4. Add to your Flutter project:
   ```
   scamshield_app/
   └── ios/
       └── Runner/
           └── GoogleService-Info.plist  ← Put file here
   ```

5. Open Xcode, drag the file into Runner folder (important!)

### For Android:

1. Click **Android icon** to add Android app
2. Fill in details:
   - **Android package name**: `com.yourteam.scamshield`
   - **App nickname**: "ScamShield Android"
   - Click **"Register app"**

3. Download **google-services.json**

4. Add to your Flutter project:
   ```
   scamshield_app/
   └── android/
       └── app/
           └── google-services.json  ← Put file here
   ```

---

## Step 3: Configure Flutter Project

### Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.0
  cloud_firestore: ^4.13.0
  firebase_auth: ^4.15.0  # Optional, for user accounts
```

### Install packages:

```bash
flutter pub get
```

### Update `android/app/build.gradle`:

Add at the end of the file:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### Update `android/build.gradle`:

Add to `dependencies` section:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

---

## Step 4: Initialize Firebase in App

### Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScamShield',
      home: HomeScreen(),
    );
  }
}
```

### Test Firebase Connection:

```bash
flutter run

# Should see in console:
# [firebase_core] Configured Firebase successfully
```

---

## Step 5: Setup Firestore Database

### Create Database:

1. In Firebase Console → **Build** → **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (we'll secure it later)
4. Choose location: **us-central1** (or closest to you)
5. Click **"Enable"**

### Test Firestore:

```dart
// lib/test_firebase.dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirestore() async {
  // Get Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // Add a test document
  await firestore.collection('test').add({
    'message': 'Hello from ScamShield!',
    'timestamp': FieldValue.serverTimestamp(),
  });
  
  print('✅ Firestore test successful!');
}
```

---

## Step 6: Create Firestore Collections

### Collection Structure:

```
scamshield/  (root)
├── scam_reports/
│   ├── document1
│   │   ├── phone_number: "+15551234567"
│   │   ├── scam_type: "IRS Scam"
│   │   ├── description: "Claimed to be IRS..."
│   │   ├── reported_by: "anonymous"
│   │   ├── timestamp: (server timestamp)
│   │   └── report_count: 1
│   └── ...
│
├── checked_numbers/
│   ├── document1
│   │   ├── phone_number: "+15551234567"
│   │   ├── total_checks: 247
│   │   ├── scam_reports: 189
│   │   └── last_checked: (timestamp)
│   └── ...
│
└── global_stats/
    └── document1
        ├── total_checks: 10523
        ├── total_reports: 3421
        ├── active_users: 847
        └── updated_at: (timestamp)
```

### Create Collections via Code:

```dart
// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Submit scam report
  static Future<void> submitReport(String phoneNumber, String scamType, String description) async {
    try {
      // Add to scam_reports collection
      await _db.collection('scam_reports').add({
        'phone_number': phoneNumber,
        'scam_type': scamType,
        'description': description,
        'reported_by': 'anonymous',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Update checked_numbers collection
      DocumentReference checkedNumberRef = _db.collection('checked_numbers').doc(phoneNumber);
      
      await checkedNumberRef.set({
        'phone_number': phoneNumber,
        'total_checks': FieldValue.increment(1),
        'scam_reports': FieldValue.increment(1),
        'last_checked': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('✅ Report submitted successfully');
    } catch (e) {
      print('❌ Error submitting report: $e');
      rethrow;
    }
  }
  
  // Fetch reports for a number
  static Future<List<Map<String, dynamic>>> fetchReports(String phoneNumber) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('scam_reports')
          .where('phone_number', isEqualTo: phoneNumber)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('❌ Error fetching reports: $e');
      return [];
    }
  }
  
  // Get report count for a number
  static Future<int> getReportCount(String phoneNumber) async {
    try {
      DocumentSnapshot doc = await _db
          .collection('checked_numbers')
          .doc(phoneNumber)
          .get();
      
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['scam_reports'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('❌ Error getting report count: $e');
      return 0;
    }
  }
}
```

---

## Step 7: Security Rules (Important!)

### Initial Rules (Test Mode):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // ⚠️ ONLY FOR DEVELOPMENT
    }
  }
}
```

### Production Rules (Use After Testing):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Scam reports: Anyone can read, write with validation
    match /scam_reports/{report} {
      allow read: if true;
      allow write: if request.resource.data.phone_number is string
                   && request.resource.data.scam_type is string
                   && request.resource.data.description is string;
    }
    
    // Checked numbers: Anyone can read and update
    match /checked_numbers/{phoneNumber} {
      allow read: if true;
      allow write: if true;
    }
    
    // Global stats: Read only for users
    match /global_stats/{stat} {
      allow read: if true;
      allow write: if false;  // Only via Cloud Functions
    }
  }
}
```

### Update Security Rules:

1. Firebase Console → **Firestore Database** → **Rules**
2. Copy production rules above
3. Click **"Publish"**

---

## Step 8: Test Everything

### Create Test File:

```dart
// lib/test_firebase_integration.dart
import 'package:flutter/material.dart';
import 'services/firebase_service.dart';

class TestFirebasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Test submitting report
                await FirebaseService.submitReport(
                  '+15551234567',
                  'Test Scam',
                  'This is a test report',
                );
                print('✅ Report submitted');
              },
              child: Text('Test Submit Report'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Test fetching reports
                var reports = await FirebaseService.fetchReports('+15551234567');
                print('✅ Fetched ${reports.length} reports');
                reports.forEach((report) => print(report));
              },
              child: Text('Test Fetch Reports'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Test getting report count
                int count = await FirebaseService.getReportCount('+15551234567');
                print('✅ Report count: $count');
              },
              child: Text('Test Report Count'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Run Tests:

```bash
flutter run

# Click each button and check Firebase Console
# You should see data appear in Firestore
```

---

## Step 9: Firebase Console Walkthrough

### View Data:

1. Firebase Console → **Firestore Database** → **Data**
2. Click on collections to view documents
3. Click on documents to edit
4. Use **"Add Document"** button to add manually

### Monitor Usage:

1. Firebase Console → **Firestore Database** → **Usage**
2. Check:
   - Reads per day
   - Writes per day
   - Deletes per day
   - Storage used

### Free Tier Limits:

```
✅ Reads: 50,000 per day
✅ Writes: 20,000 per day
✅ Deletes: 20,000 per day
✅ Storage: 1 GB

For student project, this is MORE than enough!
```

---

## Troubleshooting

### "FirebaseException: [core/no-app]"

**Solution:**
```dart
// Make sure Firebase is initialized in main.dart
await Firebase.initializeApp();
```

### "GoogleService-Info.plist not found"

**Solution:**
- Download again from Firebase Console
- Make sure it's in `ios/Runner/` folder
- Open in Xcode and drag to Runner folder

### "google-services.json not found"

**Solution:**
- Download again from Firebase Console
- Make sure it's in `android/app/` folder
- Rebuild: `flutter clean && flutter run`

### "Permission denied" in Firestore

**Solution:**
- Check Firebase Console → Firestore → Rules
- Make sure rules allow read/write
- Wait 1-2 minutes for rules to propagate

### "FirebaseException: [cloud_firestore/unavailable]"

**Solution:**
- Check internet connection
- Try on real device instead of emulator
- Check Firebase status: https://status.firebase.google.com/

---

## Advanced: Cloud Functions (Optional)

If you want to add server-side logic:

### Install Firebase CLI:

```bash
npm install -g firebase-tools
firebase login
firebase init functions
```

### Example Function:

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Triggered when new scam report is added
exports.onNewReport = functions.firestore
  .document('scam_reports/{reportId}')
  .onCreate(async (snap, context) => {
    const report = snap.data();
    const phoneNumber = report.phone_number;
    
    // Update global stats
    const statsRef = admin.firestore().collection('global_stats').doc('main');
    await statsRef.update({
      total_reports: admin.firestore.FieldValue.increment(1),
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    console.log(`New report for ${phoneNumber}`);
  });
```

---

## Best Practices

### ✅ DO:
- Use test mode during development
- Update to production rules before launch
- Monitor usage in Firebase Console
- Handle errors gracefully
- Use FieldValue.serverTimestamp() for timestamps
- Cache data locally when possible

### ❌ DON'T:
- Leave test mode rules in production
- Store sensitive data in Firestore
- Make unnecessary reads/writes
- Forget to handle offline mode
- Ignore Firebase quota limits

---

## Next Steps

1. ✅ Firebase configured
2. ✅ Test report submission
3. ✅ Test report fetching
4. ✅ Integrate into app
5. ✅ Add real-time listeners (optional)
6. ✅ Monitor usage

**You're ready to use Firebase in your app! 🚀**
