import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mainproject_apill/screen/alarm_page.dart';
import 'package:mainproject_apill/screen/homepage/home_page.dart';
import 'package:mainproject_apill/screen/setting_page.dart';
import 'package:mainproject_apill/screen/sleep_page.dart';
import 'package:mainproject_apill/screen/statistic_page.dart';

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  // 바텀 네비게이션 바 인덱스
  int _selectedIndex = 0;

  // 보여줄 화면 리스트
  final List<Widget> _navIndex = [
    HomePage(),
    StatisticPage(),
    SleepPage(),
    AlarmPage(),
    SettingPage(),
  ];

  // 네비게이션 클릭시 인덱스 변경 해주는 함수
  // 페이지 렌더링을 위해 setState 사용
  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold 의 배경화면을 투명하게
      backgroundColor: Colors.transparent,
      // 네비게이션 리스트에 있는 화면의 요소를 가지고 온다
      body: _navIndex.elementAt(_selectedIndex),
      //
      bottomNavigationBar: SizedBox(
        height: 65,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent
          ),
          child: BottomNavigationBar(
              iconSize: 30,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.5),
              currentIndex: _selectedIndex,
              onTap: _onNavTapped,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: [
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.house,
                      size: _selectedIndex == 0 ? 35 : 30),
                    label: '•'
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.chartLine,
                      size: _selectedIndex == 1 ? 35 : 30),
                    label: '•'
                ),
                BottomNavigationBarItem(
                    icon: Image.asset('assets/image/MoonBG.png',
                        width: _selectedIndex == 2 ? 65 : 60),
                    label: '•'
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.clock,
                      size: _selectedIndex == 3 ? 35 : 30),
                    label: '•'
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.gear,
                      size: _selectedIndex == 4 ? 35 : 30),
                    label: '•'
                ),
              ]),
        ),
      ),
    );
  }
}