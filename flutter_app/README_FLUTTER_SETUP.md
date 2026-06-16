Flutter app — local setup checklist

This file lists the minimal steps to get the Flutter mobile app running (Android + iOS) and to enable FCM push notifications.

Prerequisites
- Install Flutter SDK: https://docs.flutter.dev/get-started/install
- For macOS + iOS: Xcode and Xcode Command Line Tools
- For Android: Android Studio + Android SDK + emulator or a device
- Ensure `flutter` is on your PATH (run `flutter --version`)

1) Install Flutter packages
```bash
cd flutter_app
flutter pub get
```

2) Android native setup
- Add `google-services.json` from your Firebase Android app into `android/app/`.
- Edit `android/build.gradle` (project-level) and ensure the Google services classpath is present (Firebase setup instructions will show this).
- Edit `android/app/build.gradle` and add `apply plugin: 'com.google.gms.google-services'` at the bottom.
- Ensure `minSdkVersion` in `android/app/build.gradle` is at least 21 for `firebase_messaging`.
- Request runtime permissions for notifications on Android 13+ if needed (the plugin handles most flow).

3) iOS native setup
- Add `GoogleService-Info.plist` from your Firebase iOS app into `ios/Runner/` (add via Xcode or copy and ensure it's in Runner target).
- In Xcode, enable push notifications capability and background modes (remote notifications).
- Run `pod install` in `ios/` (Flutter handles this via `flutter run` but you can run manually):
```bash
cd ios && pod install && cd ..
```

4) Firebase configuration & service account (server)
- For sending server pushes from backend, create a Firebase service account (JSON) and set path or JSON in backend env: `FIREBASE_SERVICE_ACCOUNT_JSON` or `FIREBASE_SERVICE_ACCOUNT_PATH`.

5) Run the app
- Android emulator:
```bash
flutter devices
flutter run -d emulator-5554
```
- iOS simulator (macOS only):
```bash
flutter run -d ios
```

6) Test FCM registration
- Install app on device/emulator, open logs, and verify you see FCM token printed from `PushService` in `lib/src/services/push_service.dart`.
- Confirm backend `/notifications/register` receives the token (backend must be running and reachable from the emulator/device).

Notes and troubleshooting
- Android emulators use `10.0.2.2` to reach host `localhost`. `lib/src/core/env.dart` currently has `apiBaseUrl = 'http://10.0.2.2:4000'` which is correct for Android emulator. For iOS Simulator use `http://localhost:4000`.
- If you use a physical device, ensure your phone and the backend host are on the same network and use the host machine's IP in `Env.apiBaseUrl`.
- If you get build errors, run `flutter doctor -v` and fix reported issues.

If you want, I can:
- Add `flutter_local_notifications` integration to show foreground notifications.
- Add platform-specific manifest/property edits automatically (I can patch `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`), but you'll still need to add the Firebase files and run `pod install` on macOS.
