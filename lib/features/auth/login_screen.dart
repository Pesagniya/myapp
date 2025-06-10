import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:myapp/features/rides/your_rides.dart';
import 'package:myapp/features/auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/trademark.png'),
      onLogin: AuthService.authUser,
      onSignup: AuthService.signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const YourRidesScreen()),
        );
      },
      onRecoverPassword: AuthService.recoverPassword,
      theme: LoginTheme(logoWidth: 100, primaryColor: Colors.red),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:myapp/features/rides/your_rides.dart';
import 'package:myapp/features/auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/trademark.png'),
      onLogin: AuthService.authUser,
      onSignup: AuthService.signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const YourRidesScreen()),
        );
      },
      onRecoverPassword: AuthService.recoverPassword,
      theme: LoginTheme(logoWidth: 100, primaryColor: Colors.red),
    );
  }
}
*/
