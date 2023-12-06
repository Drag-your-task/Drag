import 'package:firebase_auth/firebase_auth.dart' as fire;

import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? _user;

  void signWithGoogle() async {
    try {
      final userCredential = await _service.signInWithGoogle();
      if(userCredential.user != null){
        _user = await _service.fetchUser(userCredential.user!.uid);

        if(_user == null){
          //새로 가입한 것이기 때문에 등록하고
          _service.registerUser(userCredential);
          _user = await _service.fetchUser(userCredential.user!.uid);
        }
        else{
          notifyListeners();
        }
      }


    } catch (e) {
      print("Error signing in with Google: $e");
      rethrow;
    }
  }

  void signOutWithGoogle(){
    //print(_user?.uid);
    _service.signOutWithGoogle();
  }

  void registerWithEmail(String email, String password){
    _service.registerWithEmailPassword(email,password);
  }



  Future<String?> isEmailAlreadyInUse(String email){
    return _service.isEmailAlreadyInUse(email);
  }

  Future<bool> signInWithEmailPassword(String email, String password){
    return _service.signInWithEmailPassword(email, password);
  }

}