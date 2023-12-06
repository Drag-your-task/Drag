import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen(); // 사용자가 로그인하지 않았을 때 로그인 화면으로 이동
          }
          print(user);
          return HomeScreen(); // 사용자가 로그인했을 때 홈 화면으로 이동
        }
        return Scaffold(
          body: Center(
            child:  Image.asset("assets/icons/progress_icon.gif"),// 연결 상태를 기다리는 동안 로딩 표시
          ),
        );
      },
    );
  }
}
