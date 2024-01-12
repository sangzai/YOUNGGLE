import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/select_posture_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class HomeBarChart extends StatelessWidget {
  HomeBarChart({Key? key}) : super(key: key);
  final statisticCon = Get.find<StatisticCon>();

  @override
  Widget build(BuildContext context) {

    List<int> barChartData = getBarChartData(statisticCon.stackBarChartData);

    String firstSleepPosition = statisticCon.stackBarChartData[0][3];
    Color firstColor =
      firstSleepPosition == "DP" ? AppColors.appColorBlue : AppColors.appColorGreen;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(barChartData.length, (index) {
        // 'front' 또는 'side'에 따라 색상을 결정합니다.

        // 간략한 코드
        // Color barColor =
        //   index % 2 == 0 ? firstColor : firstColor
        //       == AppColors.appColorBlue70
        //         ? AppColors.appColorGreen70 : AppColors.appColorBlue70;


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

        return StackedBar(flex: barChartData[index], color: barColor);
      })

    );
  }

  List<int> getBarChartData(RxList<dynamic> stackBarChartData){
    List<int>barChartData = [];
    for (SelectPostureModel model in stackBarChartData) {
      barChartData.add(model.minutes);
      print(model.minutes);
    }
    return barChartData;
  }
}

class StackedBar extends StatelessWidget {
  final Color color;
  final int flex;

  const StackedBar({required this.color, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 28.0, // Adjust the height as needed
        color: color,
      ),
    );
  }
}