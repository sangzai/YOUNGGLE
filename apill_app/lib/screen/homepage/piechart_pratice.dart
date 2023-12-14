import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartPractice extends StatefulWidget {
  const PieChartPractice({super.key});

  @override
  State<StatefulWidget> createState() => PieChartPracticeState();
}

class PieChartPracticeState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
              PieChartData(
                // pieTouchData: PieTouchData(
                //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
                //     setState(() {
                //       if (!event.isInterestedForInteractions ||
                //           pieTouchResponse == null ||
                //           pieTouchResponse.touchedSection == null) {
                //         touchedIndex = -1;
                //         return;
                //       }
                //       touchedIndex = pieTouchResponse
                //           .touchedSection!.touchedSectionIndex;
                //     });
                //   },
                // ),
                borderData: FlBorderData(
                  show: false,
                ),
                // sectionsSpace: 0,
                centerSpaceRadius: 112,
                sections: showingSections(),
              ),
            );

  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 9.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            // borderSide: BorderSide(width: 10),
            color: Color(0xFF2196F3),
            value: 40,
            // title: '40%',
            radius: radius,
            // titleStyle: TextStyle(
            //   fontSize: fontSize,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   shadows: shadows,
            // ),
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: Color(0xFFFFC300),
            value: 30,
            // title: '30%',
            radius: radius,
            // titleStyle: TextStyle(
            //   fontSize: fontSize,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   shadows: shadows,
            // ),
          );
        case 2:
          return PieChartSectionData(
            showTitle: false,
            color: Color(0xFF6E1BFF),
            value: 15,
            // title: '15%',
            radius: radius,
            // titleStyle: TextStyle(
            //   fontSize: fontSize,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   shadows: shadows,
            // ),
          );
        case 3:
          return PieChartSectionData(
            showTitle: false,
            color: Color(0xFF3BFF49),
            value: 15,
            // title: '15%',
            radius: radius,
            // titleStyle: TextStyle(
            //   fontSize: fontSize,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   shadows: shadows,
            // ),
          );
        default:
          throw Error();
      }
    });
  }
}