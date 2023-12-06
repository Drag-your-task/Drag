import 'package:drag/views/auth_screen/auth_screen.dart';
import 'package:drag/views/auth_screen/register_email_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _password_visible = false;

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }



  // @override
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);

    void _signIn() async {
      try {
        final status = await authViewModel.signInWithEmailPassword(email_controller.text, password_controller.text);
        if(status == false){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter a valid email address and password to log in.')),
          );
        }
        email_controller.clear();
        password_controller.clear();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }

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
                  SizedBox(height: 50,),

                  Text('Email', style: TextStyle(
                    fontSize: 15,
                  ),),
                  SizedBox(height: 5,),


                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
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


                        SizedBox(height: 15,),
                        Text('Password', style: TextStyle(
                          fontSize: 15,
                        ),),
                        SizedBox(height: 5,),
                        TextFormField(
                          obscureText: !_password_visible,
                          controller:password_controller,
                          cursorColor: AppColors.primary,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                // 아이콘을 토글 상태에 따라 변경
                                _password_visible ? CupertinoIcons.eye:CupertinoIcons.eye_slash,
                              ),
                              onPressed: () {
                                // 토글 상태 업데이트
                                setState(() {
                                  _password_visible = !_password_visible;
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
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Don't have an account? "),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterEmailScreen()));

                      }, child: Text('Register', style: TextStyle(color: AppColors.primary),)),
                    ],
                  ),

                  Divider(),
                  SizedBox(height: 10,),
                  OutlinedButton(
                      onPressed: (){
                        authViewModel.signWithGoogle();
                            //.then((user){
                        //                           print("google");
                        //                         }).catchError((error){
                        //                           print(error);
                        //                         });
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
                height: 50,
                child: ElevatedButton(
                    onPressed: (){

                      if (_formKey.currentState!.validate()) {
                        _signIn();

                      }

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

