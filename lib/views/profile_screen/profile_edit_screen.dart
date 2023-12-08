import 'dart:io';

import 'package:drag/views/auth_screen/auth_screen.dart';
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
  EditPofileScreen(this.afterRegister, {super.key});
  bool afterRegister;

  @override
  State<EditPofileScreen> createState() => _EditPofileScreenState();
}

class _EditPofileScreenState extends State<EditPofileScreen> {
  XFile? _image;
  String profilePictureUrl = 'https://github.com/Drag-your-task/Drag/blob/main/assets/icons/grab_icon/grab_app_icon.png?raw=true';

  final TextEditingController _username_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _username_controller.text = authViewModel.getUser().name ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit your profile', style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
          ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    authViewModel.modifyUser(_image?.path ?? '', _username_controller.text);
                    Navigator.pop(context);

                    if(widget.afterRegister){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthScreen()));
                    }
                  }
                },
                child: Text('Add', style: TextStyle(
                  color: AppColors.primary,
                ),)
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
              padding:const EdgeInsets.all(20),
              child: Column(
                  children:<Widget>[

                    SizedBox(height:30),

                    imageProfile(),
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.camera_alt),
                    ),
                    SizedBox(height:30),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              autofocus: true,
                              controller:_username_controller,
                              cursorColor: AppColors.primary,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                //hintText: 'Type your task and emoji',
                              ),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Type your name';
                                }
                                return null;
                              },
                            ),

                          ],
                        )
                    ),
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
            CircleAvatar(
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
          ],
        )
    );
  }
}