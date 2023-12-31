import 'package:drag/theme/colors.dart';
import 'package:drag/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
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
            headerStyle: HeaderStyle(
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: AppColors.primary),
                ),
              );
            })),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // 항목의 수를 설정합니다.
                  itemBuilder: (context, index) {

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: Colors.white,
                      elevation: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('09:30 ~ 11:15',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text('모바일 앱 개발', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),
                                RotatedBox(
                                  quarterTurns: 1, // 90도 회전
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(CupertinoIcons.ellipsis, color: AppColors.primary,),
                                    onPressed: () {
                                      // 버튼이 눌렸을 때 수행할 동작
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(alignment:Alignment.centerRight, child: Text('NTH ')),
                          ],
                        ),
                      ),
                    );

                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // 항목의 수를 설정합니다.
                  itemBuilder: (context, index) {
                    // 홀수 인덱스만 표시합니다.
                    return index % 2 != 0 ? ListTile(title: Text('오른쪽 항목 $index')) : Container();
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
