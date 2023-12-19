import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mainproject_apill/screen/homepage/home_barchart.dart';
import 'package:mainproject_apill/screen/homepage/home_linechart.dart';
import 'package:mainproject_apill/screen/homepage/home_piechart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: SafeArea(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 220,
                          width: 220,
                          child: HomePieChart(),
                        ),
                  
                        // TODO : 파이차트 구현
                        Container(
                          height: 220,
                          width: 220,
                          child: Image.asset('assets/image/ClockBackGround2.png',
                              fit: BoxFit.fill,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                  
                        Column(
                          children: [
                            Text("수면시간",
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 18
                              ),),
                            // TODO : 수면시간 연동
                            Text("8시간 00분",
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 26
                              ),),
                            // TODO : 수면시간 연동
                            Text("23:00 - 7:00",
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 15
                              ),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  // TODO : 다음날보기
                }, icon: FaIcon(FontAwesomeIcons.chevronRight),
                  color: Colors.white.withOpacity(0.6),
                  iconSize: 40,
                ),

              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("수면분석",style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(238, 238, 238, 0.1)
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  // TODO 그래프 구현 2
                  child: Column(
                    children: [
                      Expanded(flex: 4,child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                        child: Container(color: Colors.transparent,child: HomeLineChart()),
                      )),
                      Expanded(flex: 1,child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(58, 4, 24, 4),
                              child: HomeBarChart(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(width: 10,height: 10,color: Color(0xFF5D6DBE),),
                                    SizedBox(width: 10,),
                                    Text('등누운자세'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(width: 10,height: 10,color: Color(0xFF7DB249),),
                                    SizedBox(width: 10,),
                                    Text('옆누운자세'),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                    ],
                  ),

                ),
              ),
            )
          ],)
      ),
    );


  }
}
