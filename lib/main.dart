import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'injection.dart';

/// Application entry point
/// 
/// Handles:
/// - Dependency injection initialization
/// - System UI configuration
/// - Error handling setup
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependencies
  await initializeDependencies();

  // Run the app
  runApp(const ListifyApp());
}
