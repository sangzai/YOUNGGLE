import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/set_initial_date.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {

  final mqttHandler = Get.put(MqttHandler());

  final userCon = Get.put(UserController());

  final statisticCon = Get.put(StatisticCon());

  static final storage = FlutterSecureStorage();
  String? userId = '';
  String? tutorial = '';
  String? userName = '';

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });





  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    try {
      userName = await storage.read(key: 'userName');
      userId = await storage.read(key: 'userId');
      tutorial = await storage.read(key: '$userId tutorial');
    } catch (e) {
      print('Error reading data: $e');
    }
    print(userId);
    print(tutorial);

    await mqttHandler.connect();

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userId != null) {
      userCon.userId.value = userId!;
      userCon.userName.value = userName!;
    } else {
      print('로그인이 필요합니다');
      await Get.offAllNamed('/login');
    }

    // 만약 튜토리얼을 봤다면
    if ( tutorial == 'true' ) {

      // 날짜 및 그래프 초기화
      await SetInitialDate().initializeData();
      // 메인 화면으로 보내기
      await Get.offAllNamed('/navi');

    } else {
      // 안봤으면 튜토리얼로 보내기
      await Get.offAllNamed('/tutorial');
    }

  }


  @override
  Widget build(BuildContext context) {
    return const BackGroundImageContainer(
      child: Center(
        child: SpinKitFadingCube(
        color: AppColors.appColorBlue,
        )
      )
    );
  }
}
