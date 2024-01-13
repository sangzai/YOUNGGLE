import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mainproject_apill/route.dart';
import 'package:mainproject_apill/screen/login_page/join_page.dart';
import 'package:mainproject_apill/screen/login_page/login_page.dart';
import 'package:mainproject_apill/screen/main_page/bottom_navi_page.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/tutorial_page.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';
import 'package:mainproject_apill/widgets/mytheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

          getPages: [
            GetPage(name: '/route', page: () => RoutePage(),),

            GetPage(name: '/login', page: () => LoginPage(),
                transition: Transition.fadeIn,
                transitionDuration: const Duration(seconds: 3)),
            GetPage(name: '/join', page: () => JoinPage(),
                transition: Transition.rightToLeft,
                transitionDuration: const Duration(seconds: 1)),

            GetPage(name: '/tutorial', page: () => TutorialPage(),),

            GetPage(name: '/navi', page: () => BottomNaviPage(selectedIndex: 0,),),

            GetPage(name: '/statistic', page: () => BottomNaviPage(selectedIndex: 0,),),
            GetPage(name: '/sleep', page: () => BottomNaviPage(selectedIndex: 1,),),
            GetPage(name: '/alarm', page: () => BottomNaviPage(selectedIndex: 2,),),
            GetPage(name: '/setting', page: () => BottomNaviPage(selectedIndex: 3,),),

          ],


          title: "ApilL",
          theme: myTheme,

          home: const BackGroundImageContainer(
              child: RoutePage()
          ),
        );
      },
    );
  }
}

// GetMaterialApp의 getPages 속성에 GetPage를 사용하여 페이지를 등록한다.
// Get.toNamed("/first");
// Get.toNamed()는 기본적으로 페이지 이동을 할 때 사용하는 메소드이다.
// Get.offNamed("/second");
// Get.offNamed()는 현재 페이지를 지우고 새로운 페이지로 이동할 때 사용하는 메소드이다.
// Get.offAllNamed("/");
// Get.offAllNamed()는 기존의 모든 페이지를 지우고 새로운 페이지로 이동할 때 사용하는 메소드이다.
// 홈으로 이동할 때 사용한다.