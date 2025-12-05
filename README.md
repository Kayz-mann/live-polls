# LivePolls

A real-time polling application for iOS with live activities, push notifications, and universal link sharing. Create polls, share them anywhere, and watch results update in real-time!

## Features

- 📊 **Real-time Polling** - Vote and see results update instantly
- 🔴 **Live Activities** - Track polls on your lock screen and Dynamic Island
- 🔔 **Push Notifications** - Get notified when poll results change
- 🔗 **Universal Links** - Share polls via WhatsApp, Messages, or any platform
- 📈 **Live Charts** - Beautiful visualizations of poll results
- ⚡ **Firebase Backend** - Scalable real-time database and cloud functions

## Screenshots

<!-- Add your screenshots here -->

## Tech Stack

### iOS App
- **SwiftUI** - Modern declarative UI framework
- **Firebase iOS SDK** - Real-time database and authentication
- **ActivityKit** - Live Activities for lock screen and Dynamic Island
- **Observation Framework** - State management with @Observable
- **Charts** - Native SwiftUI charts for data visualization

### Backend
- **Firebase Firestore** - Real-time NoSQL database
- **Firebase Cloud Functions** - Serverless backend (Node.js/TypeScript)
- **Firebase Hosting** - Static web hosting for universal links
- **APNs** - Apple Push Notification service for Live Activities

## Project Structure

```
LivePolls/
├── LivePolls/                      # Main iOS app
│   ├── Models/
│   │   ├── Poll.swift             # Poll data model
│   │   └── Option.swift           # Poll option model
│   ├── Views/
│   │   ├── Home.swift             # Main home screen
│   │   ├── PollView.swift         # Individual poll view
│   │   └── PollChart.swift        # Chart visualization
│   ├── Observables/
│   │   ├── HomeViewModel.swift    # Home screen logic
│   │   └── PollViewModel.swift    # Poll screen logic
│   ├── DeepLinkManager.swift      # Universal link handling
│   ├── LivePollsApp.swift         # App entry point
│   └── ContentView.swift          # Root view
├── LivePollsWidget/               # Widget Extension
│   ├── LivePollsWidget.swift      # Widget implementation
│   └── LivePollsWidgetLiveActivity.swift  # Live Activity
├── XCODE_CONFIGURATION.md         # Xcode setup guide
├── DEEP_LINKING_SUMMARY.md        # Deep linking overview
└── Info.plist.example             # Example Info.plist config

Firebase Backend (../nodejs-projects/firebase_livepolls/):
├── functions/
│   ├── src/
│   │   ├── index.ts               # Cloud Functions
│   │   └── apple-app-site-association.json  # AASA file
│   ├── package.json
│   └── tsconfig.json
├── public/
│   └── index.html                 # Landing page
├── firebase.json                  # Firebase configuration
├── firestore.rules                # Security rules
└── DEEP_LINKING_SETUP.md          # Backend setup guide
```

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later (for Live Activities)
- Node.js 18 or later
- Firebase CLI (`npm install -g firebase-tools`)
- Apple Developer account (for push notifications and universal links)
- Firebase project ([create one here](https://console.firebase.google.com/))

### Firebase Backend Setup

The Firebase backend is located at: `/Users/kayzmann/Documents/nodejs-projects/firebase_livepolls`

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

2. **Navigate to Firebase project**
   ```bash
   cd /Users/kayzmann/Documents/nodejs-projects/firebase_livepolls
   ```

3. **Install dependencies**
   ```bash
   cd functions
   npm install
   cd ..
   ```

4. **Configure Firebase**
   - The project is already initialized (see `.firebaserc`)
   - Project ID: `livepolls-65180`

5. **Update configuration**

   In `functions/src/index.ts`, update:
   ```typescript
   const teamId = "YOUR_TEAM_ID";      // Your Apple Developer Team ID
   const keyId = "YOUR_KEY_ID";        // Your APNs key ID
   const p8FilePath = `../../AuthKey_${keyId}`;  // Path to your .p8 file
   ```

6. **Update AASA file**

   In `functions/src/apple-app-site-association.json`, replace `YOUR_TEAM_ID`:
   ```json
   {
     "applinks": {
       "apps": [],
       "details": [
         {
           "appID": "YOUR_TEAM_ID.com.LivePolls.app",
           "paths": ["/poll/*", "/polls/*"]
         }
       ]
     }
   }
   ```

7. **Deploy to Firebase**
   ```bash
   firebase deploy --only functions,hosting,firestore
   ```

8. **For local development**
   ```bash
   firebase emulators:start
   ```
   The app is already configured to use the emulator (see `LivePollsApp.swift:19-21`)

### iOS App Setup

1. **Clone and open the project**
   ```bash
   cd /Users/kayzmann/Documents/swift-projects/LivePolls
   open LivePolls.xcodeproj
   ```

2. **Configure Firebase**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to the Xcode project (if not already present)

3. **Update Bundle Identifier** (if needed)
   - Target: LivePolls
   - Bundle Identifier: `com.LivePolls.app`

4. **Configure Signing**
   - Select your development team
   - Note your Team ID (you'll need this for universal links)

5. **Add Capabilities**

   Go to **Signing & Capabilities** tab and add:

   - **Push Notifications**
   - **Background Modes**: Check "Remote notifications"
   - **Associated Domains**: Add `applinks:livepolls-65180.web.app`

   See [XCODE_CONFIGURATION.md](XCODE_CONFIGURATION.md) for detailed steps.

6. **Update share URL**

   In `LivePolls/Views/PollView.swift` line 82, update:
   ```swift
   let shareURL = URL(string: "https://livepolls-65180.web.app/poll/\(pollId)")!
   ```

7. **Build and Run**
   - Select a physical device (Live Activities don't work in simulator)
   - Press Cmd+R to build and run

## Usage

### Creating a Poll

1. Launch the app
2. Scroll to "create a poll" section
3. Enter poll name
4. Add 2-4 options using the "+ Add Option" button
5. Tap "Submit"

### Joining a Poll

**Method 1: Via Poll ID**
1. Get a poll ID from someone
2. Open "Join a Poll" section
3. Enter the poll ID
4. Tap "Join"

**Method 2: Via Deep Link**
1. Receive a shared link (e.g., `https://livepolls-65180.web.app/poll/abc123`)
2. Tap the link
3. App opens directly to the poll

### Sharing a Poll

1. Open any poll
2. Tap "Share Poll" button
3. Choose a platform (WhatsApp, Messages, Email, etc.)
4. Recipients can tap the link to join

### Voting

1. Open a poll
2. Tap any option button to vote
3. Watch the chart update in real-time
4. Vote as many times as you want!

### Live Activities

1. Open a poll
2. The app automatically starts a Live Activity
3. Lock your device
4. See live poll updates on your lock screen and Dynamic Island
5. Live results update in real-time via push notifications

## Deep Linking

The app supports two types of deep links for sharing polls:

### Universal Links (Preferred)
```
https://livepolls-65180.web.app/poll/{pollId}
```

**How it works:**
- User taps link from any app (Messages, WhatsApp, etc.)
- If app is installed → Opens directly in app
- If app is not installed → Shows web page with poll details

### Custom URL Scheme (Fallback)
```
livepolls://poll/{pollId}
```

**Configuration Guide:**
- [XCODE_CONFIGURATION.md](XCODE_CONFIGURATION.md) - iOS setup
- `firebase_livepolls/DEEP_LINKING_SETUP.md` - Backend setup
- [DEEP_LINKING_SUMMARY.md](DEEP_LINKING_SUMMARY.md) - Complete overview

## Firebase Backend Details

### Location
```
/Users/kayzmann/Documents/nodejs-projects/firebase_livepolls
```

### Cloud Functions

1. **myFunction** - Poll Update Handler
   - Trigger: Firestore document update on `polls/{pollId}`
   - Function: Sends APNs push notifications to Live Activities
   - Updates: Real-time poll results on lock screen

2. **appleAppSiteAssociation** - AASA File Server
   - Endpoint: `/.well-known/apple-app-site-association`
   - Function: Serves Apple App Site Association file for universal links

3. **poll** - Poll Landing Page
   - Endpoint: `/poll/{pollId}`
   - Function: Generates beautiful HTML page for shared polls
   - Features: Poll preview, vote count, "Open in App" button

4. **helloWorld** - Health Check
   - Endpoint: `/helloWorld`
   - Function: Simple health check endpoint

### Database Structure

```
Firestore:
  polls/{pollId}
    ├── id: string
    ├── name: string
    ├── totalCount: number
    ├── option0: { id, name, count }
    ├── option1: { id, name, count }
    ├── option2?: { id, name, count }
    ├── option3?: { id, name, count }
    ├── lastUpdatedOptionId: string
    ├── createdAt: timestamp
    └── updatedAt: timestamp

    └── push_tokens/{activityId}
        ├── token: string
        ├── activityId: string
        ├── pollId: string
        └── updatedAt: timestamp
```

### Firestore Rules

Security rules are defined in `firestore.rules`:
- Read: Public (anyone can read polls)
- Write: Public (anyone can vote and create polls)
- Note: Update rules for production to add proper authentication

## Architecture

### iOS App Architecture

```
┌─────────────────────────────────────────┐
│           LivePollsApp.swift            │
│  (App Entry, Deep Link Management)      │
└─────────────────┬───────────────────────┘
                  │
    ┌─────────────┴──────────────┐
    │                            │
┌───▼─────┐              ┌───────▼────────┐
│  Home   │              │  DeepLink      │
│  View   │◄─────────────┤  Manager       │
└───┬─────┘              └────────────────┘
    │
    │ HomeViewModel
    │ (Observable)
    │
┌───▼──────────┐
│   PollView   │
└───┬──────────┘
    │
    │ PollViewModel
    │ (Observable)
    │
    ├─► Firestore Listener
    ├─► Vote Handler
    ├─► Share Sheet
    └─► Live Activity Manager
```

### Backend Architecture

```
                    Client Request
                          │
                          ▼
                ┌─────────────────┐
                │  Firebase       │
                │  Hosting        │
                └────────┬────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
┌───────────────┐  ┌──────────┐  ┌──────────────┐
│ AASA Function │  │   Poll   │  │ Static Files │
│               │  │ Function │  │ (index.html) │
└───────────────┘  └────┬─────┘  └──────────────┘
                        │
                        ▼
                  ┌──────────┐
                  │Firestore │
                  │  Query   │
                  └────┬─────┘
                       │
                       ▼
                  HTML Response
                       │
                       ▼
        ┌──────────────┴─────────────┐
        │                            │
        ▼                            ▼
   App Installed               No App Installed
   Opens in App                Web Page with
                              "Download" button
```

### Data Flow

```
User Votes
    │
    ▼
PollViewModel.incrementOption()
    │
    ▼
Firestore.updateData()
    │
    ▼
Firestore triggers Cloud Function
    │
    ▼
Cloud Function fetches push tokens
    │
    ▼
Sends APNs push notification
    │
    ▼
iOS receives push → Updates Live Activity
    │
    ▼
All users see updated chart
```

## Environment Configuration

### Development (Emulator)

The app is configured to use Firebase emulators by default:

```swift
// LivePollsApp.swift:19-21
settings.host = "127.0.0.1:8080"
settings.cacheSettings = MemoryCacheSettings()
```

To use emulators:
```bash
cd /Users/kayzmann/Documents/nodejs-projects/firebase_livepolls
firebase emulators:start
```

### Production

To use production Firebase:

1. Comment out emulator settings in `LivePollsApp.swift`:
   ```swift
   // settings.host = "127.0.0.1:8080"
   // settings.cacheSettings = MemoryCacheSettings()
   ```

2. Deploy Firebase backend:
   ```bash
   firebase deploy
   ```

3. Update share URL to production domain in `PollView.swift`

## Testing

### Testing Deep Links

1. **Universal Links** (Physical device only):
   - Share a poll via Messages
   - Tap the link from Messages
   - App should open to the poll

2. **Custom URL Scheme**:
   - Send yourself: `livepolls://poll/abc123`
   - Tap the link
   - App should open

3. **Web Fallback**:
   - Open poll URL in Safari
   - Should see landing page
   - Tap "Open in LivePolls App" button

### Testing Live Activities

1. Create a poll
2. Open it on a physical device
3. Lock the device
4. Vote from another device
5. Check lock screen updates

## Troubleshooting

### Universal Links Not Working

- ✓ Must test on physical device (not simulator)
- ✓ Link must be tapped from another app (not Safari address bar)
- ✓ Associated Domains capability must be added
- ✓ AASA file must be accessible at `/.well-known/apple-app-site-association`
- ✓ App must be installed and reinstalled after AASA changes

### Live Activities Not Working

- ✓ Must test on physical device (iOS 16.1+)
- ✓ Live Activities must be enabled in Settings
- ✓ Push notification capability must be added
- ✓ APNs certificate must be configured
- ✓ Check console logs for push token

### Firebase Connection Issues

- ✓ Check Firebase console for project status
- ✓ Verify `GoogleService-Info.plist` is added to project
- ✓ Check firestore rules allow read/write
- ✓ For emulator: ensure `firebase emulators:start` is running

### Build Errors

- ✓ Clean build folder: Product → Clean Build Folder
- ✓ Delete derived data: `~/Library/Developer/Xcode/DerivedData`
- ✓ Update pods if using CocoaPods
- ✓ Verify all required frameworks are linked

## Roadmap

- [ ] User authentication
- [ ] Private polls with invite codes
- [ ] Poll expiration dates
- [ ] Poll editing and deletion
- [ ] Vote analytics and insights
- [ ] Multiple choice polls
- [ ] Image/GIF support in polls
- [ ] Dark mode (system-based)
- [ ] macOS, watchOS, visionOS support
- [ ] Android version
- [ ] Web voting interface

## Contributing

This is a personal project, but suggestions and feedback are welcome!

## License

<!-- Add your license here -->

## Related Projects

- [Firebase iOS SDK](https://github.com/firebase/firebase-ios-sdk)
- [Firebase Functions](https://firebase.google.com/docs/functions)
- [ActivityKit](https://developer.apple.com/documentation/activitykit)

## Contact

<!-- Add your contact information here -->

## Acknowledgments

- Firebase for the excellent real-time database and cloud functions
- Apple for ActivityKit and Live Activities
- SwiftUI community for inspiration and examples

---

**Project Status**: ✅ Active Development

**Last Updated**: December 2025

**iOS Version**: 17.0+

**Firebase Backend**: `/Users/kayzmann/Documents/nodejs-projects/firebase_livepolls`
