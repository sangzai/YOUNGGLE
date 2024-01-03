import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/screen/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class HomeLineChart extends StatefulWidget {
  const HomeLineChart({super.key});

  @override
  State<HomeLineChart> createState() => _HomeLineChartState();
}

class _HomeLineChartState extends State<HomeLineChart> {
  final statisticCon = Get.put(StatisticCon());

  @override
  Widget build(BuildContext context) {

    List<SelectDateData> chartdata = statisticCon.selectedDateData;

    



    return LineChart(
      LineChartData(
        // 선 클릭시 설정
        lineTouchData: lineTouchData,
        // 차트 내부 격자선 데이터 설정
        gridData: gridData,
        // 차트 바깥 축에 대한 정보 설정
        titlesData: titlesData1,

        borderData: FlBorderData(show: false),
        // TODO : 차트 전체 길이 조정
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 9,
        minY: 3,

      ),

    );
  }
// 빌더 끝
  LineTouchData get lineTouchData => LineTouchData(
    // 터치시 나오는 수직 라인 지우기
    getTouchLineEnd: (barData, spotIndex) => 0,
    getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
      return spotIndexes.map((spotIndex) {
        return TouchedSpotIndicatorData(
          FlLine(),
          // 터치시 띄웠을때 점 설정
          FlDotData(
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: Colors.white.withOpacity(0.5),
                strokeWidth: 0,
              );
            },
          ),
        );
      }).toList();
    },

    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
    ),
  );

  FlGridData get gridData => FlGridData(
    show: true,
    drawHorizontalLine: true,
    drawVerticalLine: false,
    horizontalInterval: 1,
    // TODO : 라인차트 수평선 간격 정하기
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  // TODO : 좌측 차트 축 간격 설정
  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    // 제목간 간격
    interval: 1,
    // 제목과 차트 간격
    reservedSize: 32,
  );

  // TODO : 좌측 차트에 나오는 정보
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 4:
        text = '깊은\n수면';
        break;
      case 5:
        text = '얕은\n수면';
        break;
      case 7:
        text = ' 램\n수면';
        break;
      case 8:
        text = '기상';
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,

  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: false,
    color: AppColors.appColorWhite,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    // TODO : 데이터 넣기
    spots: const [
    FlSpot(1, 1),
    FlSpot(3, 1.5),
    FlSpot(5, 1.4),
    FlSpot(7, 3.4),
    FlSpot(10, 2),
    FlSpot(12, 2.2),
    FlSpot(13, 1.8),
    ],
  );
}// 클래스 끝
