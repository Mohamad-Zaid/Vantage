# Google Sign-In Troubleshooting Guide

## Why It Might Not Be Working

### 1. Firebase Console Setup (Most Common)

**Enable Google Sign-In:**
- Firebase Console > Authentication > Sign-in method
- Enable the **Google** provider

**Add SHA-1 Fingerprint (Android):**
- Run: `cd android && ./gradlew signingReport` (or `gradlew signingReport` on Windows)
- Copy the **SHA-1** from the `debug` variant
- Firebase Console > Project settings > Your apps > Android app > Add fingerprint
- Add both debug and release SHA-1 if you publish to Play Store

**Get Web Client ID (if needed):**
- Firebase Console > Project settings > General > Your apps
- Add a **Web app** if you haven't
- Copy the Web client ID (format: `xxxxx.apps.googleusercontent.com`)
- Add to `main.dart`:
  ```dart
  await GoogleSignIn.instance.initialize(
    serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  );
  ```

### 2. Platform-Specific Notes

**Android:**
- Ensure `google-services.json` is in `android/app/`
- Package name in `build.gradle.kts` must match Firebase (`com.example.vantage`)

**iOS:**
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Add URL scheme in `Info.plist` (FlutterFire CLI usually does this)

**Web:**
- `authenticate()` may not be supported on web
- Consider using Firebase `signInWithPopup` for web

### 3. Code Fixes Applied

- **await googleUser.authentication**: The `authentication` getter returns a `Future`; it must be awaited.
- **accessToken in credential**: Added `accessToken` to `GoogleAuthProvider.credential` for better compatibility.

---

## Do You Need Separate "Create Account" for Google/Facebook?

**No.** With Firebase Auth, Google and Facebook sign-in are **unified**:

- **"Continue with Google"** and **"Continue with Facebook"** work for both:
  - **New users**: Firebase creates an account automatically on first sign-in
  - **Existing users**: Signs them in

You do **not** need separate "Create Account with Google" or "Create Account with Facebook" buttons. The same buttons on the Sign In page handle both flows.
