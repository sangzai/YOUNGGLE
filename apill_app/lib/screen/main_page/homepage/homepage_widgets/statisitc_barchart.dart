import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class HomeBarChart extends StatelessWidget {
  HomeBarChart({Key? key}) : super(key: key);
  final statisticCon = Get.find<StatisticCon>();

  @override
  Widget build(BuildContext context) {

    // TODO 임시 바차트용 데이터
    statisticCon.stackBarChartData = RxList<List<Object>>([
      [1, '2023-11-26 17:43:00', '2023-11-26 17:44:36', "front"],
      [1, '2023-11-26 17:44:36', '2023-11-26 18:06:44', "side"],
      [1, '2023-11-26 18:06:44', '2023-11-26 20:32:32', "front"],
      [1, '2023-11-26 20:32:32', '2023-11-26 20:48:37', "side"],
      [1, '2023-11-26 20:48:37', '2023-11-26 21:12:05', "front"],
      [1, '2023-11-26 21:12:05', '2023-11-26 21:40:41', "side"],
      [1, '2023-11-26 21:40:41', '2023-11-26 22:00:11', "front"],
      [1, '2023-11-26 22:00:11', '2023-11-26 22:05:36', "side"],
      [1, '2023-11-26 22:05:36', '2023-11-26 22:48:22', "front"],
      [1, '2023-11-26 22:48:22', '2023-11-27 00:25:00', "side"]
    ]);

    // print(statisticCon.stackBarChartData);

    List<int> barChartData = getBarChartData(statisticCon.stackBarChartData);

    String firstSleepPosition = statisticCon.stackBarChartData[0][3];
    // print(firstSleepPosition);
    Color firstColor =
      firstSleepPosition == "front" ? AppColors.appColorBlue : AppColors.appColorGreen;

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
      // [
      //   StackedBar(flex: 1, color: AppColors.appColorBlue),
      //   StackedBar(flex: 3, color: AppColors.appColorGreen),
      //   StackedBar(flex: 4, color: AppColors.appColorBlue),
      //   StackedBar(flex: 1, color: AppColors.appColorGreen),
      //   StackedBar(flex: 2, color: AppColors.appColorBlue),
      //   StackedBar(flex: 1, color: AppColors.appColorGreen),
      // ],
    );
  }

  List<int> getBarChartData(List<dynamic> stackBarChartData){
    List<int> barChartData = [];
    for (int i = 0; i < stackBarChartData.length ; i ++ ) {
      // 임시
      String startTimeStr = stackBarChartData[i][1];
      String endTimeStr = stackBarChartData[i][2];

      DateTime startTime = DateTime.parse(startTimeStr);
      DateTime endTime = DateTime.parse(endTimeStr);


      //진짜
      // DateTime startTime = stackBarChartData[i][1];
      // DateTime endTime = stackBarChartData[i][2];

      int minutes = endTime.difference(startTime).inMinutes.toInt();
      barChartData.add(minutes);
    }
    // print("바차트 데이터 $barChartData");
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