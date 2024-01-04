import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePieChart extends StatelessWidget {
  const HomePieChart({super.key});

  // 파이 차트 두께
  static const radius = 9.0;

  // TODO : 데이터에 맞춰서 PieChartSectionData 만들어야함
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        // 파이 그래프 간의 거리
        sectionsSpace: 0,
        // 테두리 설정
        borderData: FlBorderData(
          show: false,
        ),
        centerSpaceRadius: 112,
        sections: [
          PieChartSectionData(
            showTitle: false,
            color: Color(0xFF2196F3),
            value: 40,
            radius: radius,
          ),
          PieChartSectionData(
            showTitle: false,
            color: Color(0xFFFFC300),
            value: 30,
            radius: radius,
          ),
          PieChartSectionData(
            showTitle: false,
            color: Color(0xFF6E1BFF),
            value: 15,
            radius: radius,
          ),
          PieChartSectionData(
            showTitle: false,
            color: Color(0xFF3BFF49),
            value: 15,
            radius: radius,
          ),


        ]
      )
    );
  }
}
