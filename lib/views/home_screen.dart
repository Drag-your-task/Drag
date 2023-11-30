import 'package:drag/views/profile_screen.dart';
import 'package:drag/views/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget{

  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  //String _title = "Calendar"; // 현재 선택된 탭의 title

  // 각 탭 인덱스에 따라 페이지를 반환합니다.
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return CalendarScreen(); // CalendarPage 위젯
      case 1:
        return TwoListViewDragDrop(); // ProfilePage 위젯
      default:
        return CalendarScreen(); // 기본 페이지
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // _title = index == 0 ? "Calendar" : "Profile";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          leading: Image.asset("assets/icons/grab_icon/grab_app_icon.png", height: 10,),
          actions: [
            IconButton(
              onPressed: () {  },
              icon: Icon(CupertinoIcons.bell, size: 20,),
            ),
            IconButton(
              onPressed: () {  },
              icon: Icon(CupertinoIcons.ellipsis_circle, size: 20,),
            ),
          ],
        ),
      ),
      body: Container(
          color: _selectedIndex == 1 ? Colors.white:Colors.grey[100],
          child: _getPage(_selectedIndex),

      ), // 현재 선택된 탭의 페이지를 표시합니다.
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
              icon: CupertinoIcons.calendar,
              text: 'calendar',
              index: 0,
            ),
            SizedBox(width: 48), // FloatingActionButton의 공간을 비워두기 위함
            _buildTabItem(
              icon: CupertinoIcons.person,
              text: 'profile',
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
    Color color = _selectedIndex == index ? AppColors.primary : Colors.black; // AppColors를 사용하여 선택된 탭 색상 지정

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: color,size:20),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
