import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:myapp/features/rides/your_rides.dart';

const users = {'dribbble@gmail.com': '12345', 'hunter@gmail.com': 'hunter'};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Usuário não existe';
      }
      if (users[data.name] != data.password) {
        return 'Senha incorreta';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Usuário não existe';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/trademark.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const YourRidesScreen()),
        );
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(logoWidth: 100, primaryColor: Colors.red),
    );
  }
}
