import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/select_posture_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class HomeBarChart extends StatefulWidget {
  HomeBarChart({Key? key}) : super(key: key);

  @override
  State<HomeBarChart> createState() => _HomeBarChartState();
}

class _HomeBarChartState extends State<HomeBarChart> {
  final statisticCon = Get.find<StatisticCon>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
        () {

          List<double> barChartData = getBarChartData(statisticCon.stackBarChartData);
          print("✨✨barChartData : $barChartData");
          String firstSleepPosition = statisticCon.stackBarChartData[0].posture;
          Color firstColor =
          firstSleepPosition == "DP" ? AppColors.appColorBlue : AppColors.appColorGreen;


          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(barChartData.length, (index) {
                // 좀 더 알기 쉬운 코드
                Color barColor;
                if (index % 2 == 0) {
                  // 짝수 번째 인덱스
                  barColor = firstColor;
                } else {
                  // 홀수 번째 인덱스
                  barColor = (firstColor == AppColors.appColorBlue)
                      ? AppColors.appColorGreen
                      : AppColors.appColorBlue;
                }

                return Expanded(
                  child: TweenAnimationBuilder(
                    duration: Duration(seconds: 3),
                    tween: Tween<double>(begin: 0.0, end: barChartData[index]),
                    builder: (BuildContext context, double value, Widget? child) {
                      return StackedBar(
                          width: value, color: barColor);
                    }
                  ),
                );
              })

          );
        }
    );
  }

  List<double> getBarChartData(stackBarChartData){
    List<double>barChartData = [];
    int totalLength = stackBarChartData.fold(0, (sum, model) => sum + model.minutes);
    for (SelectPostureModel model in stackBarChartData) {
      barChartData.add(model.minutes/totalLength);
    }
    print("✨✨바 차트 데이터 변환 : $barChartData");
    return barChartData;
  }
}

class StackedBar extends StatelessWidget {
  final Color color;
  final double width;

  const StackedBar({required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 28.0, // Adjust the height as needed
      color: color,
    );
  }
}