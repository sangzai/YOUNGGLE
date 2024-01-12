import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class UserController extends GetxController {

  final storage = FlutterSecureStorage();
  // 아이디값
  // TODO : 회원의 이름을 가져올 것
  RxString userName = "ApilL".obs;

  RxString userId = ''.obs;

  RxString userInfo = ''.obs;
}