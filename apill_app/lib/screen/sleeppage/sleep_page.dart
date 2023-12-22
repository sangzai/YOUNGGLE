import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/sleeppage/autoheight_controller.dart';
import 'package:mainproject_apill/screen/sleeppage/snoring_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class SleepPage extends StatelessWidget {
  SleepPage({Key? key}) : super(key: key);

  SnoringCon snoringCon = Get.put(SnoringCon());
  AutoHeightCon autoHeightCon = Get.put(AutoHeightCon());

  static const double buttonheight = 60;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),

            // 베개의 현재 높이
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(180),
                color: AppColors.appColorBlue
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("베개높이",style: Theme.of(context).textTheme.headlineLarge),
                  // TODO : 베개 높이 값 받아오기
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Text('00',style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 90,
                    )),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            SizedBox(height: 30,),

            // 코골이 추적, 자동 높이 조절
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 코골이 추적 스위치
                  AspectRatio(
                    aspectRatio: 3/2,
                    child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.appColorBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('코골이 추적',style: Theme.of(context).textTheme.headlineLarge,),
                          Obx(() => Switch(
                                value: Get.find<SnoringCon>().snoringCheck.value,
                                onChanged: (value) {
                                Get.find<SnoringCon>().snoringCheck.value = value;
                              })
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 자동 높이 조절 스위치
                  AspectRatio(
                    aspectRatio: 3/2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.appColorBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('자동높이조절',style: Theme.of(context).textTheme.headlineLarge,),
                          Obx(() => Switch(
                                    value: Get.find<AutoHeightCon>().autoHeightCheck.value,
                                    onChanged: (value) {
                                      Get.find<AutoHeightCon>().autoHeightCheck.value = value;
                                    })
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            // 수면 버튼 높낮이 버튼 총 3개
            SizedBox(height: 60,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 높이 낮추는 버튼
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: (){
                      // TODO : 높이 낮추기
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder()
                      ),
                      child: Icon(Icons.remove,
                        size: 60,
                        color: AppColors.appColorWhite,
                      )
                  ),
                ),
                // 동작 버튼
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                      onPressed: (){
                        // TODO: 코골이 추적, 자동높이조절의 여부를 파악해서 수면 시작
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(90),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/image/OnlyMoon.png',width: 40,),
                          SizedBox(width: 10,),
                          Text('수면\nStart',
                            style: Theme.of(context).textTheme.headlineLarge,)
                  
                        ],
                      )
                  ),
                ),
                // 높이 높이는 버튼
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: (){
                        // TODO : 높이 올리기
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder()
                      ),
                      child: Icon(Icons.add,
                        size: 60,
                        color: AppColors.appColorWhite,
                      )
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  } // 빌드 끝
} // 클래스 끝
