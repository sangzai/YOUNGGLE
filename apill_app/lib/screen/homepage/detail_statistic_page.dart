import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Text('수면통계',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20,),
            Text('수면시간', style: TextStyle(fontSize: 30),),
            Container(
              height: 30,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: Text('시간', style: TextStyle(fontSize: 20),),
            ),

            Container(
              height: 400,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: BarChart(
                BarChartData(
                    maxY: 10,
                    borderData: FlBorderData(
                        border: Border(
                            top: BorderSide.none,
                            right: BorderSide.none,
                            left: BorderSide(width: 1),
                            bottom: BorderSide(width: 1)
                        )
                    ),
                    groupsSpace: 10,
                    gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                    barTouchData: BarTouchData(enabled: true),

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,interval: 2,)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1,
                          getTitlesWidget: (double value, TitleMeta){
                            switch (value.toInt()) {
                              case 1:
                                return Text('일');
                              case 2:
                                return Text('월');
                              case 3:
                                return Text('화');
                              case 4:
                                return Text('수');
                              case 5:
                                return Text('목');
                              case 6:
                                return Text('금');
                              case 7:
                                return Text('토');
                              default:
                                return Text('');
                            }
                          }
                      )),
                    ),

                    barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 4, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero )]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 5, width: 15, color: Colors.amber, borderRadius: BorderRadius.zero),]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 6, width: 15, color: Colors.yellowAccent, borderRadius: BorderRadius.zero),]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(toY: 7, width: 15, color: Colors.red, borderRadius: BorderRadius.zero),]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(toY: 7, width: 15, color: Colors.greenAccent, borderRadius: BorderRadius.zero),]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(toY: 8, width: 15, color: Colors.grey, borderRadius: BorderRadius.zero),]),
                      BarChartGroupData(x: 7, barRods: [
                        BarChartRodData(toY: 9, width: 15, color: Colors.brown, borderRadius: BorderRadius.zero),]),
                    ]
                ),
              ),
            ),

            SizedBox(height: 50,),
            Text('수면자세시간', style: TextStyle(fontSize: 30),),
            Container(
              height: 40,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: Text(' 분', style: TextStyle(fontSize: 20),),
            ),
            Container(
              height: 400,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: BarChart(
                BarChartData(
                    borderData: FlBorderData(
                        border: Border(
                            top: BorderSide.none,
                            right: BorderSide.none,
                            left: BorderSide(width: 1),
                            bottom: BorderSide(width: 1)
                        )
                    ),
                    groupsSpace: 10,
                    gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                    barTouchData: BarTouchData(enabled: true),

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,interval: 5,)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1,
                          getTitlesWidget: (double value, TitleMeta){
                            switch (value.toInt()) {
                              case 1:
                                return Text('일');
                              case 2:
                                return Text('월');
                              case 3:
                                return Text('화');
                              case 4:
                                return Text('수');
                              case 5:
                                return Text('목');
                              case 6:
                                return Text('금');
                              case 7:
                                return Text('토');
                              default:
                                return Text('');
                            }
                          }
                      )),
                    ),

                    barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 5, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 3, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 9, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 7, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 4, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 10, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(toY: 6, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 12, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(toY: 13, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 6, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(toY: 17, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 5, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                      BarChartGroupData(x: 7, barRods: [
                        BarChartRodData(toY: 20, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),
                        BarChartRodData(toY: 5, width: 15, color: Colors.redAccent, borderRadius: BorderRadius.zero),
                      ]),
                    ]
                ),
              ),
            ),
            Container(
              height: 40,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50,),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text('옆누운 자세', style: TextStyle(fontSize: 20),),
                  SizedBox(width: 30,),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text('등누운자세', style: TextStyle(fontSize: 20),)
                ],
              ),
            ),

            SizedBox(height: 50,),
            Text('코골이시간', style: TextStyle(fontSize: 30),),
            Container(
              height: 40,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: Text(' 분', style: TextStyle(fontSize: 20),),
            ),
            Container(
              height: 400,
              width: 400,
              color: Colors.blueGrey.withOpacity(0.3),
              child: BarChart(
                BarChartData(
                    borderData: FlBorderData(
                        border: Border(
                            top: BorderSide.none,
                            right: BorderSide.none,
                            left: BorderSide(width: 1),
                            bottom: BorderSide(width: 1)
                        )
                    ),
                    groupsSpace: 10,
                    gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                    barTouchData: BarTouchData(enabled: true),

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,interval: 5,)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1,
                          getTitlesWidget: (double value, TitleMeta){
                            switch (value.toInt()) {
                              case 1:
                                return Text('일');
                              case 2:
                                return Text('월');
                              case 3:
                                return Text('화');
                              case 4:
                                return Text('수');
                              case 5:
                                return Text('목');
                              case 6:
                                return Text('금');
                              case 7:
                                return Text('토');
                              default:
                                return Text('');
                            }
                          }
                      )),
                    ),

                    barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 5, width: 15, color: Colors.red, borderRadius: BorderRadius.zero),

                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 9, width: 15, color: Colors.orange, borderRadius: BorderRadius.zero),

                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 4, width: 15, color: Colors.yellow, borderRadius: BorderRadius.zero),

                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(toY: 6, width: 15, color: Colors.green, borderRadius: BorderRadius.zero),

                      ]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(toY: 1, width: 15, color: Colors.blueAccent, borderRadius: BorderRadius.zero),

                      ]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(toY: 2, width: 15, color: Colors.grey, borderRadius: BorderRadius.zero),

                      ]),
                      BarChartGroupData(x: 7, barRods: [
                        BarChartRodData(toY: 6, width: 15, color: Colors.brown, borderRadius: BorderRadius.zero),

                      ]),
                    ]
                ),
              ),
            ),


          ],
        ),
      ),
    );

  }
}
