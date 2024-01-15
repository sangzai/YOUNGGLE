import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/main_page/sleep_page/pillow_height_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';

class SleepPage extends StatefulWidget {
  SleepPage({Key? key}) : super(key: key);


  static const height = 5;

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  // TODO : 기능 흐름도
  final pillowHeightCon = Get.find<PillowHeightController>();

  final mqttHandler = Get.find<MqttHandler>();

  @override
  void initState() {
    super.initState();

    mqttHandler.pubCheckPillowWaitResponse();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            Column(
              children: [
                Text('현재 사용자의 자세는',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 25),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx((){
                      String nowPosture = pillowHeightCon.nowPosture.value == 'DP' ? '등누운자세' : '옆누운자세';

                      return Text('$nowPosture',
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            fontSize: 40,color: AppColors.appColorBlue),
                      );

                    }),

                    Text("입니다.",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),

            // 베개의 현재 높이
            SizedBox(
              height : 320.h,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                    Positioned(
                      top: 10,
                      child: Obx(
                            ()=> Text(
                          '${pillowHeightCon.pillowHeight.value.toInt()}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            fontSize: 80,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                      top: 0,
                      child: Text('현재높이',style: Theme.of(context).textTheme.headlineLarge)
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
                          IconButton(
                              onPressed: (){
                                final dorsal = pillowHeightCon.dosalHeight;
                                if (dorsal.value > 1) {
                                  dorsal.value -= 1;
                                  // changeHeight();
                                }
                              },
                              icon: Icon(Icons.remove,
                                size: 30,
                                color: AppColors.appColorWhite,
                              )
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
                                    min: 1, max: SleepPage.height.toDouble(), divisions: SleepPage.height-1,),
                                ),
                                Obx(() => Text(
                                  '${pillowHeightCon.dosalHeight.value.toInt()}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                              ],
                            ),
                          ),


                          // 높이 높이는 버튼
                          IconButton(
                              onPressed: (){
                                final dorsal = pillowHeightCon.dosalHeight;
                                if (dorsal.value < SleepPage.height.toDouble()) {
                                  dorsal.value += 1;
                                  // changeHeight();
                                }
                              },

                              icon: Icon(Icons.add,
                                size: 30,
                                color: AppColors.appColorWhite,
                              )
                          ),
                        ],
                      ),
                    ],
                  ),



            const SizedBox(height: 30),

            Column(
                children: [
                  Text("옆누운자세 높이",style: Theme.of(context).textTheme.headlineLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 높이 낮추는 버튼
                      IconButton(

                          onPressed: (){
                            final lateral = pillowHeightCon.lateralHeight;
                            if (lateral.value > 1){
                              lateral.value -= 1;
                              // changeHeight();
                            }
                          },

                          icon: Icon(Icons.remove,
                            size: 30,
                            color: AppColors.appColorWhite,

                          )
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
                                  min: 1, max: SleepPage.height.toDouble(), divisions: SleepPage.height-1),
                            ),
                            Obx(() => Text(
                              '${pillowHeightCon.lateralHeight.value.toInt()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            )),

                          ],
                        ),
                      ),


                      // 높이 높이는 버튼
                      IconButton(
                          onPressed: (){
                            final lateral = pillowHeightCon.lateralHeight;
                            if(lateral.value < SleepPage.height.toDouble()){
                              lateral.value += 1;
                              // changeHeight();
                            }
                          },

                          icon: const Icon(Icons.add,
                            size: 30,
                            color: AppColors.appColorWhite,
                          )
                      ),
                    ],
                  ),

                  SizedBox(height: 30,),

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
  }
 // 빌드 끝
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