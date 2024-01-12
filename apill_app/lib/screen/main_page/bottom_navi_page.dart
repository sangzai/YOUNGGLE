import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/loading_controller.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_page.dart';
import 'package:mainproject_apill/screen/main_page/homepage/statistic_page.dart';
import 'package:mainproject_apill/screen/main_page/setting_page/setting_page.dart';

import 'package:mainproject_apill/screen/main_page/sleep_page/sleep_page.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class BottomNaviPage extends StatefulWidget {
  const BottomNaviPage({
    Key? key,
    required this.selectedIndex
  }) : super(key: key);

  final int selectedIndex;

  @override
  State<BottomNaviPage> createState() => _BottomNaviPageState();
}

class _BottomNaviPageState extends State<BottomNaviPage> {
  // 바텀 네비게이션 바 인덱스
  int _selectedIndex = 0;
  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    // TODO: 디버깅용 스토리지 관리
    storage.deleteAll();

  }

  // 보여줄 화면 리스트
  final List<Widget> _navIndex = [
    HomePage(),
    SleepPage(),
    AlarmPage(),
    SettingPage(),
  ];

  // 네비게이션 클릭시 인덱스 변경 해주는 함수
  // 페이지 렌더링을 위해 setState 사용
  void _onNavTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Scaffold(
        // Scaffold 의 배경화면을 투명하게
        backgroundColor: Colors.transparent,
        // 네비게이션 리스트에 있는 화면의 요소를 가지고 온다
        body: Stack(
            children: [
              _navIndex.elementAt(_selectedIndex),
      
              Obx(//isLoading(obs)가 변경되면 다시 그림.
                    () => Offstage(
                      offstage: !IsLoadingController.to.isLoading, // isLoading이 false면 감춰~
                      child: Stack(children: <Widget>[
                        Opacity(//뿌옇게~
                          opacity: 0.5,//0.5만큼~
                          child: ModalBarrier(dismissible: false, color: Colors.black),//클릭 못하게~
                        ),
                        Center(
                          child: SpinKitFadingCube(
                            color: AppColors.appColorBlue,
                          )
                        ),
                      ]),
                    ),
              ),
            ],
          ),

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
                unselectedItemColor: AppColors.appColorWhite50,
                currentIndex: _selectedIndex,
                onTap: _onNavTapped,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                items: [
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.chartLine,
                        size: _selectedIndex == 0 ? 35 : 30),
                      label: '•'
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/image/WhiteMoonLogo.png',
                        width: _selectedIndex == 1 ? 47 : 43,
                        opacity: _selectedIndex == 1 ? AlwaysStoppedAnimation(1) : AlwaysStoppedAnimation(0.5)),
                      label: '•'
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.clock,
                        size: _selectedIndex == 2 ? 38 : 35),
                      label: '•'
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.gear,
                        size: _selectedIndex == 3 ? 38 : 35),
                      label: '•'
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
