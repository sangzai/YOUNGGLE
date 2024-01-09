import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final storage = FlutterSecureStorage();

  final userCon = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          child: Text('로그아웃'),
          onPressed: () async {
            await storage.deleteAll();
          }
        )
      );

  }
}
