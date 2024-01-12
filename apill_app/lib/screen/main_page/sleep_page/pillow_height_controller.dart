import 'package:get/get.dart';

class PillowHeightController extends GetxController {

  // 현재 베개 높이
  RxDouble pillowHeight = 2.0.obs;

  // 옆누운 자세 높이 설정 : CP
  RxDouble lateralHeight = 2.0.obs;

  // 등누운 자세 높이 설정 : DP
  RxDouble dosalHeight = 2.0.obs;

  // 현재 자세 일단 받을 용
  RxString nowPosture = 'DP'.obs;


  // 수면 자세 판단 여부
  // true : 등누운자세
  // false : 옆누운자세
  // RxBool sleepPosition = false.obs;

}