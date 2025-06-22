import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/auth/login_screen.dart';
import 'package:myapp/core/widgets/bottom_bar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !(snapshot.data?.emailVerified ?? false)) {
            return const LoginScreen();
          }

          return const BottomNav();
        },
      ),
    );
  }
}
