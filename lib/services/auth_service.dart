import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserModel?> fetchUser(String uid) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return UserModel(
        uid: data['uid'],
        name: data['user_name'] ?? '',
        email: data['email'],
        imageUrl: data['imageUrl'] ?? '',
      );
    } else {
      return null;
    }

  }

  Future<void> signOutWithGoogle() async {
    GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
    on FirebaseException catch (e){
      print(e.message!);
    }
    catch(e){
      print(e);
    }
    return false;
  }

  Future<void> registerUser(UserCredential credential) async {
    if (credential.user != null) {
      await FirebaseFirestore.instance.collection('user').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'user_name': credential.user!.displayName,
        'email': credential.user!.email,
        'imageUrl': credential.user!.photoURL,
      });
    }
  }

  void registerWithEmailPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        registerUser(credential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // 사용자에게 이메일이 이미 사용 중임을 알림
        print('The email address is already in use by another account.');
        // 여기서 UI 업데이트나 사용자 피드백을 제공할 수 있음
      } else {
        // 다른 FirebaseAuth 오류 처리
        print(e.message);
      }
    }
  }


  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<String?> isEmailAlreadyInUse(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print('auth service visit');
    if (!isValidEmail(email)) {
      print('invalid');
      return 'Invalid email format';
    }

    try {
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      // 로그 출력
      print('Sign in methods for $email: $signInMethods');
      return null;
    } on FirebaseAuthException catch (e) {
      // 에러 로그 출력
      print('Failed to fetch sign in methods for $email: ${e.message}');
      return 'Failed';
    }
  }


}