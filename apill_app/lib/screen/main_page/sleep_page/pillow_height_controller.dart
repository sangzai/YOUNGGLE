import 'package:get/get.dart';

class PillowHeight extends GetxController {

  // 현재 베개 높이
  RxDouble pillowHeight = 5.0.obs;

  // 옆누운 자세 높이 설정
  RxDouble lateralHeight = 5.0.obs;

  // 등누운 자세 높이 설정
  RxDouble dosalHeight = 5.0.obs;

  // 수면 자세 판단 여부
  // true : 등누운자세
  // false : 옆누운자세
  RxBool sleepPosition = false.obs;

}