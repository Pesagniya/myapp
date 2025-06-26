import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> authUser(LoginData data) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      final user = userCredential.user;
      if (user == null) {
        return 'Erro ao autenticar. Tente novamente.';
      }

      // Save user data to Firestore
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': data.name,
        'photoURL':
            'https://file.garden/aEmNcGK7YhOgwAiE/profile_photos/default_pp.png',
      });

      /* TODO: remove (fatecride not verified)
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        return 'Email não verificado. Verifique seu email para continuar.';
      }*/

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> signupUser(SignupData data) async {
    try {
      final email = data.name!;
      final password = data.password!;

      if (!email.endsWith('@fatec.sp.gov.br')) {
        return 'Use um email institucional da FATEC (@fatec.sp.gov.br)';
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to Firestore
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'photoURL':
            'https://file.garden/aEmNcGK7YhOgwAiE/profile_photos/default_pp.png',
      });

      await userCredential.user?.sendEmailVerification();
      await _auth.signOut(); // Prevent auto-login

      return 'Lembre-se de verificar seu email para ativar sua conta';
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  Future<String?> recoverPassword(String name) async {
    try {
      await _auth.sendPasswordResetEmail(email: name);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email já cadastrado';
      default:
        return 'Credenciais incorretas';
    }
  }
}
