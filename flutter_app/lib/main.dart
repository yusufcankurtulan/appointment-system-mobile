import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';
import 'src/services/push_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Temporarily skip Firebase initialization for troubleshooting so the
  // app can launch without Android Firebase resources (google-services.json).
  // Once Firebase config is added, restore the initialize calls.
  // await Firebase.initializeApp();
  // initialize push service (register token, handlers)
  // await PushService.initialize();
  runApp(const ProviderScope(child: App()));
}
