import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/main_page/sleep_page/pillow_height_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';

class SleepPage extends StatelessWidget {
  SleepPage({Key? key}) : super(key: key);


  // TODO : 기능 흐름도
  // 베개 허브와 통신으로 사용자의 자세를 받아옴
  // 사용자의 자세에 따라서 sleepPosiotion의 상태를 true, false로 변경
  // 사용자의 자세에 따라서 그 자세의 설정값을 베개 허브에 보내줌
  // 설정을 보내주고 베개의 현재 높이를 통신으로 받아서 현재 높이에 보여줌


  // 베개 설정용 컨트롤러
  final pillowHeightCon = Get.find<PillowHeightController>();

  final mqttHandler = Get.find<MqttHandler>();

  static const height = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 120),

            // 베개의 현재 높이
            SizedBox(
              height : 160,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Obx(() {
                    return Positioned(
                      top: 10,
                      child: Text(
                        '${pillowHeightCon.pillowHeight.value.toInt()}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 80,
                        ),
                      ),
                    );
                  }),
                  Positioned(
                      top: 0,
                      child: Text('현재높이',style: Theme.of(context).textTheme.bodyLarge)
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40,),

            Column(
                    children: [
                      Text("등누운자세 높이",
                          style: Theme.of(context).textTheme.headlineLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 높이 낮추는 버튼
                          Expanded(
                            child: ElevatedButton(
                                onPressed: (){
                                  final dorsal = pillowHeightCon.dosalHeight;
                                  if (dorsal.value > 1) {
                                    dorsal.value -= 1;
                                    // changeHeight();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()
                                ),
                                child: Icon(Icons.remove,
                                  size: 30,
                                  color: AppColors.appColorWhite,
                                )
                            ),
                          ),

                          // 슬라이더
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Obx(
                                      () => Slider(
                                    value: pillowHeightCon.dosalHeight.value,
                                    onChanged: (value) {
                                      pillowHeightCon.dosalHeight.value = value;
                                      // changeHeight();
                                    },
                                    min: 1, max: height.toDouble(), divisions: height-1,),
                                ),
                                Obx(() => Text(
                                  '${pillowHeightCon.dosalHeight.value.toInt()}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                              ],
                            ),
                          ),


                          // 높이 높이는 버튼
                          Expanded(
                            child: ElevatedButton(
                                onPressed: (){
                                  final dorsal = pillowHeightCon.dosalHeight;
                                  if (dorsal.value < height.toDouble()) {
                                    dorsal.value += 1;
                                    // changeHeight();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()
                                ),
                                child: Icon(Icons.add,
                                  size: 30,
                                  color: AppColors.appColorWhite,
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),



            const SizedBox(height: 50),

            Column(
                children: [
                  Text("옆누운자세 높이",style: Theme.of(context).textTheme.headlineLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 높이 낮추는 버튼
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){
                              final lateral = pillowHeightCon.lateralHeight;
                              if (lateral.value > 1){
                                lateral.value -= 1;
                                // changeHeight();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder()
                            ),
                            child: Icon(Icons.remove,
                              size: 30,
                              color: AppColors.appColorWhite,
                            )
                        ),
                      ),

                      // 슬라이더
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Obx(
                                  () => Slider(
                                  value: pillowHeightCon.lateralHeight.value,
                                  onChanged: (value) {
                                    pillowHeightCon.lateralHeight.value = value;
                                    // changeHeight();
                                  },
                                  min: 1, max: height.toDouble(), divisions: height-1),
                            ),
                            Obx(() => Text(
                              '${pillowHeightCon.lateralHeight.value.toInt()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            )),

                          ],
                        ),
                      ),


                      // 높이 높이는 버튼
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){
                              final lateral = pillowHeightCon.lateralHeight;
                              if(lateral.value < height.toDouble()){
                                lateral.value += 1;
                                // changeHeight();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder()
                            ),
                            child: const Icon(Icons.add,
                              size: 30,
                              color: AppColors.appColorWhite,
                            )
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40,),
                  
                  SizedBox(
                    height: 150.h,
                    width: 350.w,
                    child: ElevatedButton(
                      onPressed: (){
                        changeHeight();
                      },
                      child: Text('높이설정', style: Theme.of(context).textTheme.headlineMedium,)
                    ),
                  )

                ],),

          ],
        ),
      ),
    );
  } // 빌드 끝

  void changeHeight() async {
    print("✨높이 변경");
    try {
      String response = await mqttHandler.pubHeightWaitResponse(
          pillowHeightCon.dosalHeight.toInt(),
          pillowHeightCon.lateralHeight.toInt()
      );
      print('✨$response');
    } catch (error) {
      print('✨height Error: $error');
    }
  }
}// 클래스 끝