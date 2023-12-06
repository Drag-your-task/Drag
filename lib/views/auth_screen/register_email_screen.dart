import 'package:drag/views/auth_screen/auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({Key? key}) : super(key: key);

  @override
  State<RegisterEmailScreen> createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {

  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  final TextEditingController confirm_password_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _password_visible = false;
  bool _confirm_password_visible = false;

  late AuthViewModel authViewModel;


  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    confirm_password_controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initState에서 Provider를 사용하여 AuthViewModel 인스턴스를 가져옴
    Future.microtask(() =>
    authViewModel = Provider.of<AuthViewModel>(context, listen: false)
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email', style: TextStyle(
                        fontSize: 15,
                      ),),
                      SizedBox(height: 5,),
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
                        // onChanged: (value) {
                        //   checkEmail(value);
                        // },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email address';
                          }

                          //email valid 한지 체크 추가로 해야함...
                          //일단 보류
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
                          else if(value.length < 6){
                            return 'Password should be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 15,),
                      Text('Confirm Password', style: TextStyle(
                        fontSize: 15,
                      ),),
                      SizedBox(height: 5,),
                      TextFormField(
                        obscureText: !_confirm_password_visible,
                        controller: confirm_password_controller,
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // 아이콘을 토글 상태에 따라 변경
                              _confirm_password_visible ? CupertinoIcons.eye:CupertinoIcons.eye_slash,
                            ),
                            onPressed: () {
                              // 토글 상태 업데이트
                              setState(() {
                                _confirm_password_visible = !_confirm_password_visible;
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
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter confirm password';
                          }
                          else if(value != password_controller.text){
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                    ],
                  )
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                    onPressed: (){

                      if (_formKey.currentState!.validate()) {
                        authViewModel.registerWithEmail(email_controller.text, password_controller.text);

                        email_controller.clear();
                        password_controller.clear();
                        confirm_password_controller.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully registered! \u{1F525}')),
                        );

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthScreen()));
                      }

                    },
                    child: Text('Register'),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
