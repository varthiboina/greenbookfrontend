import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthService();

  User? _user;

  User? get user {
    return _user;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      _user = null; // Clear the user state on logout
      print('Successfully logged out');
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        print('Login successful for user: ${_user!.email}');
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        print('Sign up successful for user: ${_user!.email}');
        return true;
      }
    } catch (e) {
      print('Sign up error: $e');
    }
    return false;
  }
}
