import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/screen/setting_page/setting_information.dart';
import 'package:mainproject_apill/screen/setting_page/setting_profile.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key,});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // final String id; Todo: 이름 받아오기
  final userCon = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.all(10),
            child: Text('설정', style: Theme.of(context).textTheme.headlineLarge,),
          ),
          Center( // Todo : Text('${id} 님') 이름 받아와야 함.
            child: Text('${userCon.userName} 님', style: Theme.of(context).textTheme.titleLarge,),
          ),
          SizedBox(height: 150,),
          Container(
              height: 510,
              width: 420,
              decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),)
              ),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Profile()));
                      print('출력!');
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 50,
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('프로필', style: Theme.of(context).textTheme.titleLarge,),
                          Icon(Icons.keyboard_arrow_right, color: AppColors.appColorWhite90,),
                        ],
                      ),
                    ),
                  ),

                  Container(height: 3, width: 370, color: Colors.white,),

                  GestureDetector(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (_)=>Connect()));
                      print('출력!!');
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 50,
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ApilL연결', style: Theme.of(context).textTheme.titleLarge,),
                          Icon(Icons.keyboard_arrow_right, color: AppColors.appColorWhite90,),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 3, width: 370, color: AppColors.appColorWhite90,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>information()));
                      print('출력!!!');
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 50,
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ApilL정보', style: Theme.of(context).textTheme.titleLarge,),
                          Icon(Icons.keyboard_arrow_right, color: AppColors.appColorWhite90,),
                        ],
                      ),
                    ),
                  ),


                  Container(height: 3, width: 370, color: AppColors.appColorWhite90,),
                ],
              )
          )
        ],
      ),
    );

  }
}
