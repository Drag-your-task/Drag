import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:drag/theme/colors.dart';
import 'package:drag/viewmodels/task_viewmodel.dart';
import 'package:drag/viewmodels/auth_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';
import 'profile_edit_screen.dart';
import 'add_fixed_task_screen.dart';
import 'package:image_picker/image_picker.dart';


class EditPofileScreen extends StatefulWidget {
  const EditPofileScreen({super.key});

  @override
  State<EditPofileScreen> createState() => _EditPofileScreenState();
}

class _EditPofileScreenState extends State<EditPofileScreen> {
  XFile? _image;
  String profilePictureUrl = 'https://github.com/Drag-your-task/Drag/blob/main/assets/icons/grab_icon/grab_app_icon.png?raw=true';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('이미지가 선택되지 않았습니다.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit your profile', style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
          ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
              padding:const EdgeInsets.all(10),
              child: Column(
                  children:<Widget>[

                    SizedBox(height:30),

                    imageProfile(),
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.camera_alt),
                    ),
                    SizedBox(height:50),
                  ]
              )
          ),
        )
    );
  }

  Widget imageProfile(){
    return Center(
        child:Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> EditPofileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 50,
                child: FutureBuilder(
                  future: Provider.of<AuthViewModel>(context)
                      .getUserProfilePictureUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Image.asset('assets/icons/progress_icon.gif'); // or any loading indicator
                    } else if (snapshot.hasError) {
                      return Text("Error loading profile picture");
                    } else {
                      if(snapshot.hasData){
                        profilePictureUrl = snapshot.data!;
                      }
                      return Container(
                        //padding: EdgeInsets.all(4), // 테두리와 이미지 사이의 여백
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary, // 테두리 색상
                            width: 3, // 테두리 두께
                          ),
                        ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 50,
                            backgroundImage: _image == null
                                ? NetworkImage(profilePictureUrl!)
                                : FileImage(File(_image!.path)) as ImageProvider<Object>,
                          ),

                      );
                    }
                  },
                ),
              ),
            ),
          ],
        )
    );
  }
}