import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class BarChartSample extends StatefulWidget {
  BarChartSample({super.key});
  final Color centerBarColor = AppColors.appColorBlue;
  final Color rightBarColor = AppColors.appColorGreen;
  final Color leftBarColor = AppColors.appColorWhite.darken(50);

  @override
  State<StatefulWidget> createState() => BarChartSampleState();
}

class BarChartSampleState extends State<BarChartSample> {

  final statisticCon = Get.find<StatisticCon>();

  final double width = 9;

  late List<BarChartGroupData> rawBarGroups;

  static const double maxY = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.containerBackColor
      ),
      height: 330,
      width: MediaQuery.of(context).size.width,

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              '주간 수면정보',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx((){
                List<BarChartGroupData> items = [];
                var sleep = statisticCon.selectedWeekSleepData;
                var posture = statisticCon.weekPostureTimeData;
                DateTime sunday = statisticCon.selectedDateSunday.value;

                for(int i = 0 ; i < 7; i++){
                  double totalSleep = 0.0;
                  double frontSleep = 0.0;
                  double sideSleep = 0.0;

                  var matchingSleepModel = sleep.where(
                          (sleepModel) => sleepModel.date == sunday.add(Duration(days: i))
                  ).firstOrNull;

                  if (matchingSleepModel != null) {
                    totalSleep = matchingSleepModel.totalSleepTime.toDouble();
                  }

                  var matchingFrontModel = posture.where(
                      (postureModel) => (postureModel.date == sunday.add(Duration(days: i))) && (postureModel.postureType == 'DP')
                  ).firstOrNull;

                  if (matchingFrontModel != null) {
                    frontSleep = matchingFrontModel.totalSleepTime.toDouble();
                  }

                  var matchingSideModel = posture.where(
                          (sideModel) => (sideModel.date == sunday.add(Duration(days: i))) && (sideModel.postureType == 'CP')
                  ).firstOrNull;

                  if (matchingSideModel != null) {
                    sideSleep = matchingSideModel.totalSleepTime.toDouble();
                  }

                  double maxSleep = [totalSleep, frontSleep, sideSleep].reduce((a, b) => a > b ? a : b);

                  if (maxSleep != 0.0) {
                    // Divide each value by the maximum value and multiply by 10
                    totalSleep = (totalSleep / maxSleep) * maxY;
                    frontSleep = (frontSleep / maxSleep) * maxY;
                    sideSleep = (sideSleep / maxSleep) * maxY;
                  }

                  items.add(makeGroupData(i,totalSleep,frontSleep,sideSleep));

                }
                  return BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(enabled: false),
                      maxY: maxY,

                      titlesData: FlTitlesData(
                        show: true,

                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 40,
                          ),
                        ),

                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: 1,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                      ),

                      borderData: FlBorderData(
                        show: false,
                      ),


                      barGroups: items,


                      gridData: const FlGridData(show: false),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                indicatorBox(AppColors.appColorWhite.darken(50),'수면시간'),
                indicatorBox(AppColors.appColorBlue,'등누운자세'),
                indicatorBox(AppColors.appColorGreen,'옆누운자세'),
              ],
            )


          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    var sleep = statisticCon.selectedWeekSleepData;
    double maxTotalSleep = sleep
        .map((sleepModel) => sleepModel.totalSleepTime.toDouble())
        .reduce((max, current) => max > current ? max : current);

    String maxSleep = '${maxTotalSleep ~/ 60}:${(maxTotalSleep % 60).toInt()}';
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );
    String text = '';
    // TODO :
    if (value == 0) {
      text = '0';
    } else if (value == maxY) {
      text = maxSleep;
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['일', '월', '화', '수', '목', '금', '토'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double totalSleep, double frontSleep, double sideSleep ) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: totalSleep,
          color: widget.leftBarColor,
          width: width,
          borderRadius: BorderRadius.zero,
        ),
        BarChartRodData(
          toY: frontSleep,
          color: widget.centerBarColor,
          width: width,
          borderRadius: BorderRadius.zero
        ),
        BarChartRodData(
          toY: sideSleep,
          color: widget.rightBarColor,
          width: width,
          borderRadius: BorderRadius.zero
        ),
      ],
    );
  }

  Widget indicatorBox(Color color, String text){
    return Row(
      children: [
        Container(width: 15, height: 15, color: color,),
        SizedBox(width: 10,),
        Text(text,
          style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 30.sp
          ),
        )
      ],
    );
  }


}