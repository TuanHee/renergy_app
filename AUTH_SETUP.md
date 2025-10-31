# Authentication Setup Guide

This app supports platform-specific authentication:
- **Android**: Google Sign-In
- **iOS**: Sign in with Apple (and Google Sign-In)

## Setup Instructions

### Android Setup (Google Sign-In)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Sign-In API
4. Create OAuth 2.0 credentials (Web application type)
5. Add your SHA-1 certificate fingerprint to the OAuth credentials
   - Get SHA-1: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
6. Download `google-services.json` and place it in `android/app/`

### iOS Setup (Sign in with Apple)

1. Open your project in Xcode: `open ios/Runner.xcworkspace`
2. Select the Runner target
3. Go to "Signing & Capabilities" tab
4. Click "+ Capability" and add "Sign in with Apple"
5. In your Apple Developer account:
   - Enable "Sign in with Apple" capability
   - Configure your App ID with Sign in with Apple service

### iOS Setup (Google Sign-In - Optional)

1. Add your iOS bundle ID to Google Cloud Console OAuth credentials
2. Download `GoogleService-Info.plist` and add it to `ios/Runner/` via Xcode
3. Or add the REVERSED_CLIENT_ID to your `Info.plist` URL schemes

## Usage

The login functionality is ready to use. The `LoginController` handles:
- Platform detection (automatically uses Apple on iOS, Google on Android)
- Authentication flow
- Error handling
- User session management

You can access the login screen by importing:
```dart
import 'package:renergy_app/screens/login_screen/login_screen.dart';
```

## Backend Integration

After successful authentication, you'll receive:
- **Google Sign-In**: `idToken`, `accessToken`, `email`, `displayName`, `photoUrl`
- **Apple Sign-In**: `identityToken`, `authorizationCode`, `userIdentifier`, `email`, `givenName`, `familyName`

Send these tokens to your backend server to verify and create user sessions.

