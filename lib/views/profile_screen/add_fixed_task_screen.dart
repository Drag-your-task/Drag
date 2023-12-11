import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import '../../utils/uil.dart';
import '../../viewmodels/task_viewmodel.dart';

class AddFixedTaskScreen extends StatefulWidget {
  const AddFixedTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddFixedTaskScreen> createState() => _AddFixedTaskScreenState();
}

class _AddFixedTaskScreenState extends State<AddFixedTaskScreen> {

  final TextEditingController _task_controller = TextEditingController();
  final TextEditingController _location_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();


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
    final taskViewModel = Provider.of<TaskViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text('Add fixed task \u{1F525}', style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
        actions: [
          TextButton(
              onPressed: (){
                if (_formKey.currentState!.validate()) {
                  taskViewModel.addFixedTask(_task_controller.text, _location_controller.text,selectedDay, formatDurationHHMM(startTime)+ ' ~ ' + formatDurationHHMM(endTime));
                  // 유효성 검사를 통과하면 다음 동작을 수행합니다.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully added! \u{1F525}')),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Add', style: TextStyle(
                color: AppColors.primary,
              ),)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 60,),
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
                  controller:_location_controller,
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
                      return 'Type the location';
                    }
                    return null;
                  },
                ),


            SizedBox(height: 30,),
                Text('Select the day \u{1F5D3}', style: TextStyle(fontWeight: FontWeight.bold),),
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
      ),
    );
  }
}
