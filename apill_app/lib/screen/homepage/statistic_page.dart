import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/homepage/getSelectDate.dart';
import 'package:mainproject_apill/screen/homepage/statistic_controller.dart';
import 'package:mainproject_apill/screen/homepage/detail_statistic_page.dart';
import 'package:mainproject_apill/screen/homepage/statisitc_barchart.dart';
import 'package:mainproject_apill/screen/homepage/statistic_linechart.dart';
import 'package:mainproject_apill/screen/homepage/statistic_piechart.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/utils/dateFormat.dart';
import 'package:mainproject_apill/screen/homepage/getActiveDate.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
                () => AnimatedBuilder(
                    animation: statisticCon.animationController!,
                    builder: (context, child) {
                      return SizedBox(
                        height: statisticCon.heightAnimation?.value,
                        // height: getTextHeight(statisticCon.goodSleep.value, Theme.of(context).textTheme.headlineLarge!, 3),
                        child: Visibility(
                          visible: statisticCon.appbarCheck.value,
                          child: AppBar(
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.only(left: 8,right: 20),
                              child: Opacity(
                                opacity: statisticCon.opacityAnimation?.value ?? 1.0,
                                child: Text(
                                  // TODO : 대화하는 듯한 느낌이 들게 멘트 추가할 것
                                  "${statisticCon.goodSleep.value}",
                                  style: Theme.of(context).textTheme.headlineLarge,

                                ),
                              ),
                            ),

                            actions: [
                              Opacity(
                                opacity: statisticCon.opacityAnimation?.value ?? 1.0,

                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    statisticCon.startAnimation();
                                    // statisticCon.appbarCheck.value = !statisticCon.appbarCheck.value;
                                  },
                                  color: AppColors.appColorWhite60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },

                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    // TODO : 전날보기
                  }, icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    color: Colors.white.withOpacity(0.6),
                    iconSize: 40,
                  ),
                  Obx(
                    () => Expanded(
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
                                Text("${DateFormatUtil().formattedDate(statisticCon.selectedDate.value)}",
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
                  // ✨ 달력 아이콘
                  IconButton(
                    onPressed: () async {
                    // TODO : DB의 데이터를 받아서 데이터 있는 날짜만 활성화

                      // 달력을 클릭하면 DB에 있는 날짜만 활성화
                      List<DateTime> activeDate = await getActiveDates();

                      final selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                        locale: const Locale('ko', 'KR'),
                        helpText: "",
                        useRootNavigator: false,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        selectableDayPredicate: (date) {
                          return activeDate.contains(date);
                        }
                      );

                      getSelectDates(selectedDate);

                      // print("내가 찍은 날짜 : ${selectedDate}");
                      if (selectedDate != null) {
                        statisticCon.selectedDate.value = selectedDate;
                      }


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


  } // 빌드 끝



} // 클래스 끝
