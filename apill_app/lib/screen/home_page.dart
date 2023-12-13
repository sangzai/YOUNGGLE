import 'dart:html';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TODO : 받아온 날짜 연동
              Text("12월 31일 일요일",
                  style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                onPressed: (){
                  // TODO : 날짜 가져오기 구현
                },
                icon: FaIcon(FontAwesomeIcons.calendarCheck,
                  color: Colors.white.withOpacity(0.6),
                  size: 30,)
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){
                // TODO : 전날보기
              }, icon: FaIcon(FontAwesomeIcons.chevronLeft),
                color: Colors.white.withOpacity(0.6),
                iconSize: 40,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  // TODO : 파이차트 구현
                  PieChart(
                    PieChartData(
                      sections: [],

                      centerSpaceRadius: 2.0,
                      centerSpaceColor: Colors.transparent,
                    )
                  ),
                  Container(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/image/ClockBackGround2.png',
                        fit: BoxFit.fill,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Column(
                    children: [
                      Text("수면시간",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 20
                        ),),
                      // TODO : 수면시간 연동
                      Text("8시간 00분",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 28
                        ),),
                      // TODO : 수면시간 연동
                      Text("23:00 - 7:00",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 18
                        ),),
                    ],
                  )
                ],
              ),
              IconButton(onPressed: (){
                // TODO : 다음날보기
              }, icon: FaIcon(FontAwesomeIcons.chevronRight),
                color: Colors.white.withOpacity(0.6),
                iconSize: 40,
              ),

            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.5),thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("수면분석",style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ],
      )
    );


  }
}
