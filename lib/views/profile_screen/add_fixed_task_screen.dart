import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class AddFixedTaskScreen extends StatefulWidget {
  const AddFixedTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddFixedTaskScreen> createState() => _AddFixedTaskScreenState();
}

class _AddFixedTaskScreenState extends State<AddFixedTaskScreen> {

  final TextEditingController _task_controller = TextEditingController();
  final TextEditingController _location_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String? selectedDay = 'Mon';

  @override
  void dispose() {
    _task_controller.dispose();
    _location_controller.dispose();
    super.dispose();
  }

  Duration startTime = Duration(hours: 0, minutes: 0);
  Duration endTime = Duration(hours: 0, minutes: 0);

  void _showCupertinoTimerPicker(bool isStart) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              initialTimerDuration: isStart? startTime: endTime,
              onTimerDurationChanged: (Duration newDuration) {
                setState(() {
                  if(isStart){
                    startTime = newDuration;
                  }
                  else{
                    endTime = newDuration;
                  }
                });
              },
            ),
          );
        });
  }

  String formatDurationHHMM(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    return "$twoDigitHours:$twoDigitMinutes";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: (){

              },
              child: Text('Add', style: TextStyle(
                color: AppColors.primary,
              ),)
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Type your Task and Emoji', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              TextFormField(
                autofocus: true,
                controller:_task_controller,
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
                    return 'Type your task and emoji';
                  }
                  return null;
                },
              ),


              SizedBox(height: 30,),
              Text('Type the Location \u{1F4CD}', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              TextFormField(
                autofocus: true,
                controller:_task_controller,
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
                    return 'Type your task and emoji';
                  }
                  return null;
                },
              ),


          SizedBox(height: 30,),
              Text('Select the day \u{1F525}', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0, // 간격 조정
              children: weekdays.map((day) {
                return OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: selectedDay == day ? 2: 1.0,
                      color: selectedDay == day ? AppColors.primary : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    (day == 'Fri' || day == 'Sat' || day == 'Sun') ? '\u{1F525} ' + day  : day,
                    style: TextStyle(
                      color: selectedDay == day ? AppColors.primary : Colors.black,
                      fontWeight: selectedDay == day?  FontWeight.bold: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
              SizedBox(height: 30,),
              Text('Selected Time', style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(formatDurationHHMM(startTime)+ ' ~ ' + formatDurationHHMM(endTime)),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    _showCupertinoTimerPicker(true);
                  }, child: Text('Start time')),
                  SizedBox(width: 20,),
                  ElevatedButton(onPressed: (){
                    _showCupertinoTimerPicker(false);
                  }, child: Text('End time')),
                ],
              ),





            ],
          ),
        ),
      ),
    );
  }
}
