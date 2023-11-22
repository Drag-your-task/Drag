import 'package:drag/views/profile_screen.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'calender_screen.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  String _title = "Calender"; // 현재 선택된 탭의 title

  // 각 탭 인덱스에 따라 페이지를 반환합니다.
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return CalendarScreen(); // CalendarPage 위젯
      case 1:
        return ProfileScreen(); // ProfilePage 위젯
      default:
        return CalendarScreen(); // 기본 페이지
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = index == 0 ? "Calender" : "Profile";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _getPage(_selectedIndex), // 현재 선택된 탭의 페이지를 표시합니다.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB 클릭 이벤트
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(
              icon: Icons.calendar_today,
              text: 'Calendar',
              index: 0,
            ),
            SizedBox(width: 48), // FloatingActionButton의 공간을 비워두기 위함
            _buildTabItem(
              icon: Icons.person,
              text: 'Profile',
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    Color color = _selectedIndex == index ? AppColors.primary : Colors.grey; // AppColors를 사용하여 선택된 탭 색상 지정

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: color),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
