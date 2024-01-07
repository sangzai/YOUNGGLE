import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/main_page/sleep_page/pillow_height_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class SleepPage extends StatelessWidget {
  SleepPage({Key? key}) : super(key: key);


  // TODO : 기능 흐름도
  // 베개 허브와 통신으로 사용자의 자세를 받아옴
  // 사용자의 자세에 따라서 sleepPosiotion의 상태를 true, false로 변경
  // 사용자의 자세에 따라서 그 자세의 설정값을 베개 허브에 보내줌
  // 설정을 보내주고 베개의 현재 높이를 통신으로 받아서 현재 높이에 보여줌


  // 베개 설정용 컨트롤러
  final pillowHeightCon = Get.put(PillowHeight());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150),

            // 베개의 현재 높이
            SizedBox(
              height : 160,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Obx(() {
                    final displayHeight = pillowHeightCon.sleepPosition.value
                        ? pillowHeightCon.dosalHeight.value.toInt()
                        : pillowHeightCon.lateralHeight.value.toInt();

                    return Positioned(
                      top: 10,
                      child: Text(
                        '$displayHeight',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 100,
                        ),
                      ),
                    );
                  }),
                  Positioned(
                      top: 0,
                      child: Text('현재높이',style: Theme.of(context).textTheme.bodyLarge)
                  ),
                  // // TODO : 나중에 지워야할 스위치
                  // Positioned(
                  //   bottom: 0,
                  //   child: Obx(() => Switch(
                  //       value: pillowHeightCon.sleepPosition.value,
                  //       onChanged: (value) {
                  //         pillowHeightCon.sleepPosition.value = value;
                  //       },
                  //   )
                  //   ),
                  // )

                ],
              ),
            ),

            const SizedBox(height: 60,),

            Obx(
                () {
                  return Visibility(
                    visible: pillowHeightCon.sleepPosition.value,
                    child: Column(
                      children: [
                        Text("등누운자세 높이",style: Theme.of(context).textTheme.headlineLarge),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 높이 낮추는 버튼
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: (){
                                    final dorsal = pillowHeightCon.dosalHeight;
                                    dorsal.value > 1 ? dorsal.value -= 1 : null;
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
                              child: Obx(
                                    () => Slider(
                                  value: pillowHeightCon.dosalHeight.value,
                                  onChanged: (value) {
                                    pillowHeightCon.dosalHeight.value = value;

                                  },
                                  min: 1, max: 10, divisions: 9,),
                              ),
                            ),


                            // 높이 높이는 버튼
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: (){
                                    final dorsal = pillowHeightCon.dosalHeight;
                                    dorsal.value < 10 ? dorsal.value += 1 : null;
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
                  );
                },
            ),

            Obx(
                ()=> Visibility(
                  visible: !pillowHeightCon.sleepPosition.value,
                  child: Column(
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
                                lateral.value > 1 ? lateral.value -= 1 : null;
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
                          child: Obx(
                                () => Slider(
                                value: pillowHeightCon.lateralHeight.value,
                                onChanged: (value) {
                                  pillowHeightCon.lateralHeight.value = value;

                                },
                                min: 1, max: 10, divisions: 9),
                          ),
                        ),


                        // 높이 높이는 버튼
                        Expanded(
                          child: ElevatedButton(
                              onPressed: (){
                                final lateral = pillowHeightCon.lateralHeight;
                                lateral.value < 10 ? lateral.value += 1 : null;
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
                ),
            )

          ],
        ),
      ),
    );
  } // 빌드 끝
} // 클래스 끝
