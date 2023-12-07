import 'package:drag/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home_screen.dart';


List<String> day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', "Sat", 'Sun'];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sized_box_width = ((MediaQuery.of(context).size.width -260)/6);
    print(MediaQuery.of(context).size.width);
    return SingleChildScrollView(
      child: Column(
      children: [
        SizedBox(height: 30,),
        Container(
          margin: EdgeInsets.all(20),
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                spreadRadius: 5, // 그림자의 확산 정도
                blurRadius: 7, // 그림자의 흐림 정도
                offset: Offset(0, 3), // 그림자의 위치 변경
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Word Cloud - 2023 Dec', style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.download_circle_fill, size: 20,)),
                  ],
                ),
                Divider(),


                //
              ],
            ),
          )
        ),

        Container(
          margin: EdgeInsets.all(20),
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                spreadRadius: 5, // 그림자의 확산 정도
                blurRadius: 7, // 그림자의 흐림 정도
                offset: Offset(0, 3), // 그림자의 위치 변경
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fixed Time', style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.pencil_circle_fill, size: 20,)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(int i=0; i<7; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(day[i],),
                          if(i!=6)
                            SizedBox(width: sized_box_width,),
                        ],
                      ),

                    //here


                  ],
                ),
              ],
            ),
          ),
        ),

      ],
    ),);
  }
}
