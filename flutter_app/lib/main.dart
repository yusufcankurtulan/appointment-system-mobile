import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/core/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureApiClient();
  runApp(const ProviderScope(child: App()));
}
