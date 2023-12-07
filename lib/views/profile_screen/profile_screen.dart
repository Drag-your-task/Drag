import 'package:drag/theme/colors.dart';
import 'package:drag/viewmodels/task_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';
import 'add_fixed_task_screen.dart';


List<String> day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', "Sat", 'Sun'];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double sized_box_width = ((MediaQuery.of(context).size.width -270)/6);
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
                spreadRadius: 2, // 그림자의 확산 정도
                blurRadius: 7, // 그림자의 흐림 정도
                offset: Offset(0, 2), // 그림자의 위치 변경
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
          //height: 500,
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
                spreadRadius: 2, // 그림자의 확산 정도
                blurRadius: 7, // 그림자의 흐림 정도
                offset: Offset(0, 2), // 그림자의 위치 변경
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
                    Text('Fixed Tasks', style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddFixedTaskScreen()));

                    }, icon: Icon(CupertinoIcons.add_circled_solid, size: 20,)),
                  ],
                ),
                Divider(),


                  Consumer<TaskViewModel>(
                    builder: (BuildContext context, TaskViewModel taskViewModel, Widget? child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for(int i=0; i<7; i++)
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(day[i],),
                                      SizedBox(height: 10,),
                                      for(int j=0; j<taskViewModel.fixed_timetable[i].length; j++)
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(5),
                                              height: 70,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: AppColors.secondary,
                                                borderRadius: BorderRadius.circular(6.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3), // 그림자 색상 및 투명도
                                                    spreadRadius: 0.5, // 그림자의 확산 정도
                                                    blurRadius: 3, // 그림자의 흐림 정도
                                                    offset: Offset(0, 0.5), // 그림자의 위치 변경
                                                  ),
                                                ],
                                              ),

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(taskViewModel.fixed_timetable[i][j].fixed_time!, style: TextStyle(fontSize: 9,color: AppColors.primary, fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 5,),
                                                      Container(
                                                        width: 90,
                                                          alignment: Alignment.center,
                                                          child: Text(taskViewModel.fixed_timetable[i][j].task_name, maxLines: 2, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),)
                                                      ),
                                                    ],
                                                  ),
                                                  Text(taskViewModel.fixed_timetable[i][j].location!, style: TextStyle(fontSize: 8,),),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },

                  )
              ],
            ),
          ),
        ),

      ],
    ),);
  }
}


