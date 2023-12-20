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
            // 현재 높이
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
                  Text("베개높이",style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 30
                  )),
                  // TODO : 베개 높이 값 받아오기
                  Text('00단계',style: Theme.of(context).textTheme.headlineLarge),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: (){},
                    icon: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: AppColors.appColorBlue,
                      ),
                      child: Icon(Icons.remove,
                        size: 80,
                        color: AppColors.appColorWhite,
                      ),
                    )
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColorBlue,
                    shape: CircleBorder(),
                  ),
                    onPressed: (){},
                    child: Icon(Icons.add,color: Colors.white,size: 80,)
                ),
                IconButton(

                  onPressed: (){},
                  icon: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: AppColors.appColorBlue,
                    ),
                    child: Icon(Icons.add,
                      size: 80,
                      color: AppColors.appColorWhite,
                    ),
                  )
                ),
              ],
            )

          ],
        ),
      ),
    );
  } // 빌드 끝
} // 클래스 끝
