import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email_controller = TextEditingController();

  final TextEditingController password_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  // @override
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Drag",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      ),
                      SizedBox(width: 10,),
                      Image.asset('assets/img/notchecked.png', width: 30,),
                      SizedBox(width: 10,),
                      Image.asset('assets/img/checked.png', width: 30,),
                    ],
                  ),
                  Text('Join and Manage your task by Dragging!', style: TextStyle(
                    color: Colors.black54,
                  ),),
                  SizedBox(height: 30,),
                  // Row(
                  //   children: [
                  //     Text("Don't have an account? "),
                  //     TextButton(
                  //         onPressed: (){},
                  //         child: Text('Register'),
                  //     )
                  //   ],
                  // ),

                  Text('Email', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                  SizedBox(height: 5,),


                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height:60,
                          child: TextFormField(
                            autofocus: true,
                            controller:email_controller,
                            cursorColor: AppColors.primary,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your email address';
                              }
                              return null;
                            },
                          ),
                        ),


                        SizedBox(height: 15,),
                        Text('Password', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                        SizedBox(height: 5,),
                        Container(
                          height:60,
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            controller:password_controller,
                            cursorColor: AppColors.primary,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // 아이콘을 토글 상태에 따라 변경
                                  _passwordVisible ? CupertinoIcons.eye:CupertinoIcons.eye_slash,
                                ),
                                onPressed: () {
                                  // 토글 상태 업데이트
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Don't have an account? "),
                      TextButton(onPressed: (){}, child: Text('Register', style: TextStyle(color: AppColors.primary),)),
                      // TextButton(onPressed: (){}, child: Text('Forgotten Password', style: TextStyle(color: AppColors.primary),)),
                    ],
                  ),

                  Divider(),
                  SizedBox(height: 10,),
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

              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: (){
                      authViewModel.signWithEmail();
                    },
                    child: Text('Login')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

