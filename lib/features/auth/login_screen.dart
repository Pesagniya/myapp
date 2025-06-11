import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:myapp/core/widgets/bottom_bar.dart';
import 'package:myapp/features/auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return FlutterLogin(
      logo: const AssetImage('assets/images/trademark.png'),
      onLogin: authService.authUser,
      onSignup: authService.signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Material3BottomNav()),
        );
      },
      onRecoverPassword: authService.recoverPassword,
      theme: LoginTheme(logoWidth: 100, primaryColor: Colors.red),
    );
  }
}
