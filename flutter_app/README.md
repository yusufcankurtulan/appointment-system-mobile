# Barber Appointments - Flutter Mobile

Quick start:

1. Install Flutter SDK (see flutter.dev).
2. From this folder run:

```bash
flutter pub get
flutter run
```

This scaffold includes:
- Riverpod for state management
- Dio for HTTP
- GoRouter for navigation
- flutter_secure_storage for secure token persistence

Configure API base URL in `lib/src/core/env.dart` if needed.

Firebase Cloud Messaging (FCM) setup:

- Add Firebase project and follow platform-specific setup (add `google-services.json` for Android, `GoogleService-Info.plist` for iOS).
- In `pubspec.yaml` we included `firebase_core` and `firebase_messaging` packages.
- The app registers the FCM device token using `PushService` and sends it to the backend endpoint `POST /notifications/register`.

Important: add `FCM_SERVER_KEY` to backend `.env` so the server can send push notifications.

Android notes:
- Update `android/app/build.gradle` and add `google-services.json` to the app following Firebase setup docs.

iOS notes:
- Add `GoogleService-Info.plist` and enable push capabilities + APNs certificate in Apple Developer portal.

