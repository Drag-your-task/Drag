import 'package:drag/theme/colors.dart';
import 'package:drag/viewmodels/auth_viewmodel.dart';
import 'package:drag/views/auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  Widget setting_list(BuildContext context, String text){
    return InkWell(
      child: Column(
        children: [
          Row(
            children: [
              Text('\u{1F525} '+text, style: TextStyle(
                fontSize: 17,
                // fontWeight: FontWeight.bold,
              ),),
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingListWidget(title: text)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              setting_list(context, 'Account'),//
              setting_list(context, 'Ask to Developer'),//개발자한테 문의 메일보내기
              setting_list(context, 'Information'),//오픈소스, 개인정보 정책, 이용약관, 저작권 등

              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('Version'),
                Text('1.0.0'),
              ],
              ),

              SizedBox(height: 20,),
              InkWell(
                child: Text('Logout', style: TextStyle(
                    color: AppColors.primary
                ),),
                onTap: (){
                  authViewModel.signOutWithGoogle();
                  //Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


class SettingListWidget extends StatelessWidget {
  SettingListWidget({required this.title, Key? key}) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}


