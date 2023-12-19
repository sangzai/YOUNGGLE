import 'package:flutter/material.dart';
import 'package:mainproject_apill/screen/loginpage/join_page.dart';
import 'package:mainproject_apill/screen/loginpage/login_page.dart';
import 'package:mainproject_apill/screen/my_app_page.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

// assets/image/background.png

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get방식으로 route 진행 해주기 위해서는
    // MaterialApp >> GetMaterialApp으로 수정
    return GetMaterialApp(
      title: "ApilL",
      theme: ThemeData(
        fontFamily: "Pretendard",
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 26,
              fontWeight: FontWeight.w500),
          headlineMedium: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 22),
          bodyMedium: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
        // 클릭 되있는 색
        highlightColor: Colors.green,
        // 클릭 했을때 번지는 색
        splashColor: Colors.blue,
        // applyElevationOverlayColor: true,
        cardTheme: CardTheme(
          color: Colors.red,

        ),

      ),
      home: BackGroundImageContainer(
          child: LoginPage()
      ),
    );
  }
}