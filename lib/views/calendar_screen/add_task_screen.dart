import 'package:drag/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/uil.dart';
import '../../viewmodels/task_viewmodel.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  DateTimeRange? selectedDateRange;
  final TextEditingController _task_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _task_controller.dispose();
    super.dispose();
  }



  void _showDateRangePicker() async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary, // 선택한 항목의 배경 색상
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // 헤더 배경 색상
              onPrimary: Colors.white, // 헤더에 있는 텍스트 색상
              surface: AppColors.primary, // 달력 배경색
              onSurface: Colors.black, // 달력 텍스트 색상
            ),
            dialogBackgroundColor: Colors.white, // 다이얼로그 배경색
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (range != null) {
      setState(() {
        selectedDateRange = range;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new task \u{1F525}', style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
        actions: [
          TextButton(
              onPressed: (){
                if (_formKey.currentState!.validate() && selectedDateRange != null) {
                  taskViewModel.addTask(selectedDateRange!.start, selectedDateRange!.end, _task_controller.text);
                  // 유효성 검사를 통과하면 다음 동작을 수행합니다.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully added your task! \u{1F525}')),
                  );
                  Navigator.pop(context);
                }
                if(selectedDateRange == null){
                  // 유효성 검사를 통과하면 다음 동작을 수행합니다.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Select Date Range of your task')),
                  );
                }
              },
              child: Text('Add', style: TextStyle(
                color: AppColors.primary,
              ),)
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 50,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Type your Task and Emoji', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: _showDateRangePicker,
                  child: const Text('Select Date'),
                ),
                SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\u{1F525} Selected Date Range \u{1F525}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      selectedDateRange == null?
                          Text('not selected yet'):
                      Text('${formatDateTime(selectedDateRange!.start)} - ${formatDateTime(selectedDateRange!.end)}')
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
