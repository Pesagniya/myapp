import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/bottom_bar.dart';
import 'features/auth/login_screen.dart';
import 'package:reactive_theme/reactive_theme.dart';

void main() async {
  //Get the saved thememode here
  final thememode = await ReactiveMode.getSavedThemeMode();
  // then pass it to the MyApp()
  runApp(MyApp(savedThemeMode: thememode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final ThemeMode? savedThemeMode;

  final isLoggedIn = true;
  /* change this */

  @override
  Widget build(BuildContext context) {
    return ReactiveThemer(
      // loads the saved thememode.
      // If null then ThemeMode.system is used
      savedThemeMode: savedThemeMode,
      builder:
          (reactiveMode) => MaterialApp(
            themeMode: reactiveMode,
            title: 'Fatec Ride',
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
            home: isLoggedIn ? const Material3BottomNav() : const LoginScreen(),
          ),
    );
  }
}
