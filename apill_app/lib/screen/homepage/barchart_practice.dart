import 'package:flutter/material.dart';

class HorizontalBarChart extends StatelessWidget {
  const HorizontalBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> chartData = [
      {
        "units": 50,
        "color": Colors.black,
      },
      {
        "units": 10,
        "color": Colors.blueAccent,
      },
      {
        "units": 70,
        "color": Colors.green,
      },
      {
        "units": 100,
        "color": Colors.red,
      },
    ];
    double maxWidth = MediaQuery.of(context).size.width - 36;
    var totalUnitNum = 0;
    for (int i = 0; i < chartData.length; i++) {
      totalUnitNum = totalUnitNum + int.parse(chartData[i]["units"].toString());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ClipRRect(
        child: Row(
          children: [
            for (int i = 0; i < chartData.length; i++)
              i == chartData.length - 1
                  ? Expanded(
                child: SizedBox(
                  height: 16,
                  child: ColoredBox(
                    color: chartData[i]["color"],
                  ),
                ),
              )
                  : Row(
                children: [
                  SizedBox(
                    width: chartData[i]["units"] / totalUnitNum * maxWidth,
                    height: 16,
                    child: ColoredBox(
                      color: chartData[i]["color"],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
