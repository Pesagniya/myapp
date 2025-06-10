import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/auth/auth_gate.dart';
import 'package:myapp/firebase_options.dart';
import 'package:reactive_theme/reactive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final thememode = await ReactiveMode.getSavedThemeMode();
  runApp(MyApp(savedThemeMode: thememode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});
  final ThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return ReactiveThemer(
      savedThemeMode: savedThemeMode,
      builder:
          (reactiveMode) => MaterialApp(
            title: 'Fatec Ride',
            themeMode: reactiveMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: Brightness.light,
                seedColor: Colors.red,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: Brightness.dark,
                seedColor: Colors.orange,
              ),
            ),
            home: const AuthGate(),
          ),
    );
  }
}


/* after authgate
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/auth/auth_gate.dart';
import 'package:myapp/firebase_options.dart';
import 'package:reactive_theme/reactive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final thememode = await ReactiveMode.getSavedThemeMode();
  runApp(MyApp(savedThemeMode: thememode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});
  final ThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return ReactiveThemer(
      savedThemeMode: savedThemeMode,
      builder:
          (reactiveMode) => MaterialApp(
            title: 'Fatec Ride',
            themeMode: reactiveMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: Brightness.light,
                seedColor: Colors.red,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: Brightness.dark,
                seedColor: Colors.orange,
              ),
            ),
            home: const AuthGate(),
          ),
    );
  }
}
*/