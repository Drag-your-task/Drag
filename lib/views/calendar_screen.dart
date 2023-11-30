import 'package:drag/models/task_model.dart';
import 'package:drag/theme/colors.dart';
import 'package:drag/viewmodels/task_viewmodel.dart';
import 'package:drag/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week; // 기본으로 주 단위 표시
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  Widget _buildCalendar(){
    return TableCalendar(

        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // 사용자가 달력 형식을 변경할 때 setState 호출
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        // calendarStyle: CalendarStyle(
        //   // Use `CalendarStyle` to determine the look of the calendar
        //   outsideDaysVisible: false,
        //   weekendTextStyle: TextStyle().copyWith(color: Colors.red),
        //   holidayTextStyle: TextStyle().copyWith(color: Colors.red),
        // ),
        headerStyle: const HeaderStyle(
          // Customize the header
          formatButtonVisible: true,
          formatButtonTextStyle: TextStyle(color: Colors.black, fontSize: 13),
          titleTextStyle: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black), // 왼쪽 화살표 색상 변경
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          //formatButtonVisible: false,
          //formatButtonDecoration:
          //titleCentered: true,
        ),
        // daysOfWeekStyle: DaysOfWeekStyle(
        // // Customize days of the week
        // weekendStyle: TextStyle().copyWith(color: Colors.red),
        // ),
        calendarBuilders: CalendarBuilders(
          // Customize individual days
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              );
            }, todayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: AppColors.primary),
                ),
              );
            }
        ));
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return Column(
      children: [
        Container(color:Colors.white, child: _buildCalendar()),
        SizedBox(height: 10,),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: taskViewModel.fixed_list.length,
                  itemBuilder: (context, index) {
                    TaskModel? task = taskViewModel.findTask(taskViewModel.fixed_list[index]);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular (10.0),
                      ),
                      color: Colors.white,
                      elevation: 0.3,
                      margin: EdgeInsets.fromLTRB(10, 5, 6, 5),
                      //elevation: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task?.fixed_time.toString() ?? '',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(task?.task_name.toString() ?? '', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    Text(task?.location.toString() ?? '',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: RotatedBox(
                                    quarterTurns: 1, // 90도 회전
                                    child: Icon(CupertinoIcons.ellipsis, color: AppColors.primary,),
                                  ),
                                  onTap: (){

                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: taskViewModel.draggable_list.length, // 항목의 수를 설정합니다.
                  itemBuilder: (context, index) {
                    TaskModel? task = taskViewModel.findTask(taskViewModel.draggable_list[index]);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular (10.0),
                      ),
                      margin: EdgeInsets.fromLTRB(6, 5, 10, 5),
                      //color: AppColors.secondary,
                      color: Colors.white,
                      elevation: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset((task?.is_checked == true)? "assets/img/notchecked.png": "assets/img/checked.png", width: 20,),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(

                                      child: Text(task?.task_name.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width/2 - 86,
                                    ),
                                    Text('~ '+ formatDateTime(task!.end_date!), style: TextStyle(
                                      fontSize: 10,
                                      //fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),
                                InkWell(
                                  child: RotatedBox(
                                    quarterTurns: 1, // 90도 회전
                                    child: Icon(CupertinoIcons.ellipsis, color: AppColors.primary,),
                                  ),
                                  onTap: (){

                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )




      ],
    );
  }
}
