import 'package:get/get.dart';

class UserController extends GetxController with GetSingleTickerProviderStateMixin {
  // 아이디값
  // TODO : 회원의 이름을 가져올 것
  RxString userName = "ApilL".obs;
}