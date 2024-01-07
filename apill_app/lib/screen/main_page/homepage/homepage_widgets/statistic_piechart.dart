import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
class HomePieChart extends StatefulWidget {
  const HomePieChart({super.key});

  static const radius = 9.0;

  @override
  State<HomePieChart> createState() => _HomePieChartState();
}

class _HomePieChartState extends State<HomePieChart> {
  final statisticCon = Get.put(StatisticCon());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
            // statisticCon.pieTouchIndex.value
            // statisticCon.pieIndex.value
        List<dynamic> data = statisticCon.pieData;

        List<PieChartSectionData> sections = [];

        for (var i = 0; i < data.length; i++) {
          int value = data[i][0];
          DateTime startTime = data[i][1];
          DateTime endTime = data[i][2];

          int timeDifferenceInMinutes = endTime.difference(startTime).inMinutes;

          // sleepNum에 따라 색 변화
          Color color = (value == -1) ? AppColors.appColorWhite80 : AppColors.appColorBlue80;

          sections.add(
            PieChartSectionData(
              showTitle: false,
              color: color,
              value: timeDifferenceInMinutes.toDouble(),
              radius: HomePieChart.radius,
            ),
          );
        }



        return PieChart(
          swapAnimationDuration: Duration(seconds: 1),
          PieChartData(
            pieTouchData: PieTouchData(
              enabled: true,
              touchCallback: (FlTouchEvent, pieTouchResponse) {
                print("터치 발생중");
              },
            ),

            startDegreeOffset: 180,
            // 파이 그래프 간의 거리
            sectionsSpace: 0,
            // 테두리 설정
            borderData: FlBorderData(
              show: false,
            ),
            centerSpaceRadius: 112,
            sections: sections,
          ),
        );
      },
    );
  }



}