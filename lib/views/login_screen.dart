import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Join the Drag app",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              ),
              Container(
                height: 400,
                color: Colors.black,
              ),
              OutlinedButton(
                  onPressed: (){
                    authViewModel.signWithGoogle().then((user){
                      print("google");
                    }).catchError((error){
                      print(error);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/img/google.png', // 'assets' 폴더에 구글 로고 이미지를 저장해야 합니다.
                          height: 24.0,
                          width: 24.0,
                        ),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}
