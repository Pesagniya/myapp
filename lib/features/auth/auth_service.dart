import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String?> authUser(LoginData data) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      final user = userCredential.user;
      if (user == null) {
        return 'Erro ao autenticar. Tente novamente.';
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        return 'Email não verificado. Verifique seu email para continuar.';
      }

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<String?> signupUser(SignupData data) async {
    try {
      final email = data.name!;
      final password = data.password!;

      if (!email.endsWith('@fatec.sp.gov.br')) {
        return 'Use um email institucional da FATEC (@fatec.sp.gov.br)';
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();
      await _auth.signOut(); // Prevent auto-login

      return 'Lembre-se de verificar seu email para ativar sua conta';
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  static Future<String?> recoverPassword(String name) async {
    try {
      await _auth.sendPasswordResetEmail(email: name);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  static String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email já cadastrado';
      default:
        return 'Credenciais incorretas';
    }
  }
}
