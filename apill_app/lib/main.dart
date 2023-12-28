import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mainproject_apill/screen/loginpage/login_page.dart';
import 'package:mainproject_apill/screen/my_app_page.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';
import 'package:mainproject_apill/widgets/mytheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase 초기화
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    // Get방식으로 route 진행 해주기 위해서는
    // MaterialApp >> GetMaterialApp으로 수정

    // ScreenUtilInit : 반응형 구현을 위한 라이브러리
    // 예시 SIZE의 화면 기준으로 구현
    // width: 50.w,
    // height: 200.h
    // fontsize: 15.sp
    return ScreenUtilInit(
      designSize: const Size(1100,2400),
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            Locale('ko'),
            Locale('en'),
          ],


          title: "ApilL",
          theme: myTheme,
          home: const BackGroundImageContainer(
              child: LoginPage()
          ),
        );
      },
    );
  }
}