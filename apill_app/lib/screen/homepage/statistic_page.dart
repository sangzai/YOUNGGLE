import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/homepage/statistic_controller.dart';
import 'package:mainproject_apill/screen/homepage/detail_statistic_page.dart';
import 'package:mainproject_apill/screen/homepage/statisitc_barchart.dart';
import 'package:mainproject_apill/screen/homepage/statistic_linechart.dart';
import 'package:mainproject_apill/screen/homepage/statistic_piechart.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final statisticCon = Get.put(StatisticCon());

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
        child: SafeArea(
          child: Column(
            children: [
              Obx(
                () => Visibility(
                  visible: statisticCon.appbarcheck.value,
                  child: AppBar(
                    // TODO : 대화하는 듯한 느낌이 들게 멘트 추가할 것
                    // title: Text("ApilL님 \n 오늘은 숙면을 위해 캐모마일티를 마셔보는건 어떻까요?",
                    //   style: Theme.of(context).textTheme.headlineLarge,
                    // ),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(left: 8,right: 20),
                      child: Text("ApilL님\n오늘은 숙면을 위해 캐모마일티를 마셔보는건 어떠신가요?",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          print(statisticCon.appbarcheck.value);
                          statisticCon.appbarcheck.value = !statisticCon.appbarcheck.value;
                        },
                        color: AppColors.appColorWhite60,
                      ),
                    ],
                  ),
                ),
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
                                ),
                              ),
                              SizedBox(height: 20),
                              Text("12/31 (일)",
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 17
                                ),
                              ),
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
                  IconButton(
                    onPressed: (){
                    // TODO : 날짜 고르기
                    },
                    icon: Icon(Icons.calendar_month_outlined),
                    color: Colors.white.withOpacity(0.6),
                    iconSize: 30,
                  ),
                ],
              ),
              Padding(
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
      
            ],)
        ),
      ),
    );


  }
}
