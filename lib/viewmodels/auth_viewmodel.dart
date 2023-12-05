import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/cupertino.dart';

import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _service = AuthService();

  fire.User? _user;

  Future<fire.User?> signWithGoogle() async {
    try {
      final userCredential = await _service.signInWithGoogle();
      _user = userCredential?.user;
      notifyListeners();
      return _user;

    } catch (e) {
      print("Error signing in with Google: $e");
      rethrow;
    }
  }

  void signOutWithGoogle(){
    print(_user?.uid);
    _service.signOutWithGoogle();
  }

}