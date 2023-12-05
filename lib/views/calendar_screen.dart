import 'package:drag/models/task_model.dart';
import 'package:drag/theme/colors.dart';
import 'package:drag/viewmodels/task_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'edit_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week; // 기본으로 주 단위 표시
  //DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  Widget _buildCalendar(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          return isSameDay(taskViewModel.selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(taskViewModel.selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              taskViewModel.set_selectedDay(selectedDay);
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
          titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
          // 왼쪽 화살표 색상 변경
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
        }));
  }

  Widget fixed_card(BuildContext context, TaskModel task, int idx) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      elevation: 0.3,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: Image.asset(
                        (task.is_checked == true)
                            ? "assets/img/checked.png"
                            : "assets/img/notchecked.png",
                        width: 20,
                      ),
                      onTap: () {
                        taskViewModel.toggleCheck(task);
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task?.fixed_time.toString() ?? '',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          child: Text(
                            task?.task_name.toString() ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              decoration: (task.is_checked == true)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 87,
                        ),
                        Text(
                          task?.location.toString() ?? '',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  child: RotatedBox(
                    quarterTurns: 1, // 90도 회전
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    _showBottomSheet(context, task);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget draggable_card(BuildContext context, TaskModel task, int idx) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                Row(
                  children: [
                    InkWell(
                      child: Image.asset(
                        (task?.is_checked == true)
                            ? "assets/img/checked.png"
                            : "assets/img/notchecked.png",
                        width: 20,
                      ),
                      onTap: () {
                        taskViewModel.toggleCheck(task);
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            task?.task_name.toString() ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              decoration: (task.is_checked == true)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 87,
                        ),
                        Text(
                          '~ ' + formatDateTime(task!.end_date!).substring(0,11),
                          style: TextStyle(
                            fontSize: 10,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  child: RotatedBox(
                    quarterTurns: 1, // 90도 회전
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    _showBottomSheet(context, task);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, TaskModel task){
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (BuildContext bc){
          int? differenceInDays = task.end_date?.difference(task.start_date ?? DateTime.now()).inDays;
          return Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            height: MediaQuery.of(bc).size.height * 0.8,
            width: MediaQuery.of(bc).size.width,
            child: Column(

              children: [
                // SizedBox(height: 50,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          print('asdfasdfads');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditTaskScreen(task)),
                          );
                        },
                        child: Container(
                          // alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/2 - 100,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('\u{270D}'),
                              Text('Edit'),
                            ],
                          ),
                        )),
                    SizedBox(width: 20,),
                    ElevatedButton(
                        onPressed: (){

                        },
                        child: Container(
                          // alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/2 - 100,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('\u{1F5D1}'),
                              Text('Delete'),
                            ],
                          ),
                        )),
                  ],
                ),

                SizedBox(height: 30,),
                Text(task.task_name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),

                if(differenceInDays != null)
                  Text('D-'+ differenceInDays.toString(), style: TextStyle(fontSize: 100,color: AppColors.primary),),


                if(differenceInDays != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(formatDateTime(task.start_date!).substring(0,11),),
                      Text(' ~ '),
                      Text(formatDateTime(task.end_date!).substring(0,11)),
                    ],
                  ),

                if(task.is_fixed == true)
                  Column(
                    children: [
                      Text(task.fixed_time.toString()),
                      Text(task.location.toString()),
                    ],
                  ),

                SizedBox(height: 50,),
                Consumer<TaskViewModel>(

                  builder: (BuildContext context, TaskViewModel value, Widget? child) {
                  return InkWell(
                    child: Image.asset(
                      (task?.is_checked == true)
                          ? "assets/img/checked.png"
                          : "assets/img/notchecked.png",
                      width: 150,
                    ),
                    onTap: () {
                      print('asdf');
                      value.toggleCheck(task);
                    },
                  );},
                ),


              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
   // final taskViewModel = Provider.of<TaskViewModel>(context);

    return Column(
      children: [
        Container(color: Colors.white, child: _buildCalendar(context)),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Consumer<TaskViewModel>(
                    builder: (context, provider, child) {
                        return ListView.builder(
                            itemCount: provider.fixed_list.length,
                            // 항목의 수를 설정합니다.
                            itemBuilder: (context, index) {

                              return DragTarget<String>(
                                onAccept: (receivedTaskId) {
                                  bool isInFixedList =
                                  provider.fixed_list.contains(receivedTaskId);
                                  bool isInDraggableList = provider
                                      .draggable_list
                                      .contains(receivedTaskId);

                                  if (isInDraggableList) {
                                    provider.moveTaskToList(
                                        receivedTaskId, index, true);
                                  } else if (isInFixedList) {
                                    // 같은 드래그 가능한 리스트 내에서 위치 변경
                                    provider.reorderTask(
                                        receivedTaskId, index, true);
                                  }
                                },
                                builder: (context, candidateData,
                                    rejectedData) {
                                  int idx = provider.findTask(
                                      provider.fixed_list[index]);

                                  if (idx == -1) {
                                    // 유효하지 않은 인덱스일 경우 처리
                                    return SizedBox(); // 또는 다른 위젯 반환
                                  }

                                  TaskModel task = provider.tasks[idx];
                                  String taskId = provider.fixed_list[index];
                                  return LongPressDraggable<String>(
                                    data: taskId,
                                    feedback: provider.tasks[idx].is_fixed
                                        ? fixed_card(context, task, idx)
                                        : draggable_card(context, task, idx),
                                    // 드래그하는 동안 보여줄 위젯
                                    childWhenDragging: Opacity(
                                      opacity: 0.5,
                                      child: provider.tasks[idx].is_fixed
                                          ? fixed_card(context, task, idx)
                                          : draggable_card(context, task,
                                          idx), // 드래그할 때 원래 위치에 보여줄 위젯
                                    ),
                                    child: provider.tasks[idx].is_fixed
                                        ? fixed_card(context, task, idx)
                                        : draggable_card(context, task, idx),
                                  );
                                },
                              );
                            });

                }),
              ),
              Consumer<TaskViewModel>(
                  builder: (context, provider, child) {

                  return Container(
                    height: provider.draggable_list.length == 0 ? 0:150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      color: AppColors.primary,
                      //color: Colors.white,
                    ),
                    child: ListView.builder(
                        itemCount: provider.draggable_list.length,
                        // 항목의 수를 설정합니다.
                        itemBuilder: (context, index) {
                          return DragTarget<String>(
                            onAccept: (receivedTaskId) {
                              bool isInFixedList = provider.fixed_list
                                  .contains(receivedTaskId);
                              bool isInDraggableList = provider
                                  .draggable_list
                                  .contains(receivedTaskId);

                              if (isInDraggableList) {
                                // 같은 드래그 가능한 리스트 내에서 위치 변경
                                provider.reorderTask(
                                    receivedTaskId, index, false);
                              } else if (isInFixedList) {
                                // taskViewModel.moveTaskToList(
                                //     receivedTaskId, index, false);
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              int idx = provider
                                  .findTask(provider.draggable_list[index]);

                              if (idx == -1) {
                                // 유효하지 않은 인덱스일 경우 처리
                                return SizedBox(); // 또는 다른 위젯 반환
                              }

                              TaskModel task = provider.tasks[idx];
                              String taskId = provider.draggable_list[index];
                              return LongPressDraggable<String>(
                                data: taskId,
                                feedback: draggable_card(context, task, idx),
                                // 드래그하는 동안 보여줄 위젯
                                childWhenDragging: Opacity(
                                  opacity: 0.5,
                                  child: draggable_card(
                                      context, task,
                                      idx), // 드래그할 때 원래 위치에 보여줄 위젯
                                ),
                                child: draggable_card(context, task, idx),
                              );
                            },
                          );
                        }),
                  );

              })
            ],
          ),
        ),
      ],
    );
  }
}
