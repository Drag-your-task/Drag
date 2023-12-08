import 'package:firebase_auth/firebase_auth.dart' as fire;

import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? _user;

  UserModel getUser (){
    return _user!;
  }

  void signWithGoogle() async {
    try {
      final userCredential = await _service.signInWithGoogle();
      if(userCredential.user != null){
        _user = await _service.fetchUser();

        if(_user == null){
          //새로 가입한 것이기 때문에 등록하고
          _service.registerUser(userCredential);
          _user = await _service.fetchUser();
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

  Future<void> registerWithEmail(String email, String password) async {

    _user = await _service.registerWithEmailPassword(email,password);
    notifyListeners();
    print(_user);
  }



  Future<String?> isEmailAlreadyInUse(String email){
    return _service.isEmailAlreadyInUse(email);
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    bool status = await _service.signInWithEmailPassword(email, password);
    _user = await _service.fetchUser();
    notifyListeners();
    print(_user?.imageUrl ?? 'no uid');
    print(_user);
    return status;
  }

  Future<String?> getUserProfilePictureUrl() async{
    try{
      //User? user = _auth.currentUser;
      // if(_user == null){
      //   String? profilePictureUrl = await FirebaseFirestore.instance
      //       .collection('user')
      //       .doc(_auth.currentUser!.uid)
      //       .get()
      //       .then((documentSnapshot) => documentSnapshot.data()?['imageUrl']);
      //   return profilePictureUrl;
      // }
      // else{
      //   return _user!.imageUrl;
      // }
      return _user!.imageUrl;
    } catch(e){
      print("Error getting profile picture URL: $e");
      return null;
    }
  }

  Future<void> modifyUser(String imageUrl, String name) async {
    print(imageUrl);
    await _service.modifyUser(imageUrl,name, _user!);
    _user = await _service.fetchUser();
    print(_user?.name);
    notifyListeners();
  }

}