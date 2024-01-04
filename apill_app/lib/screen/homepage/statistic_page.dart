import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/getSelectDate.dart';
import 'package:mainproject_apill/screen/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_piechart.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_today_body_chart.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_today_summary.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/utils/dateFormat.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/getActiveDate.dart';


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final statisticCon = Get.put(StatisticCon());
  final userCon = Get.put(UserController());

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
                        height: statisticCon.heightAnimation!.value,
                        child: Visibility(
                          visible: statisticCon.appbarCheck.value,
                          child: AppBar(
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.only(left: 8,right: 20),
                              child: Opacity(
                                opacity: statisticCon.opacityAnimation?.value ?? 1.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${userCon.userName}님',
                                      style: Theme.of(context).textTheme.headlineLarge,),
                                    Text(
                                      // TODO : 대화하는 듯한 느낌이 들게 멘트 추가할 것
                                      "${statisticCon.goodSleep.value}",
                                      style: Theme.of(context).textTheme.headlineLarge,
                                    ),
                                  ],
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
                                    // print(getTextHeight(statisticCon.goodSleep.value, myTheme.textTheme.headlineLarge!, ScreenUtil().screenWidth));
                                    // print(statisticCon.heightAnimation!.value);
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
                      await get_statistic_data(context);
                    },
                    icon: Icon(Icons.calendar_month_outlined),
                    color: Colors.white.withOpacity(0.6),
                    iconSize: 30,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 4),
                // 따로 만들어서 뺌
                child: TodayCharts(data: statisticCon.selectedDateData)
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 4),
                // 따로 만들어서 뺌
                child: TodaySummarys(userName: userCon.userName.value, data: statisticCon.selectedDateData),)

            ],)
        ),
      ),
    );


  } // 빌드 끝

  Future<void> get_statistic_data(BuildContext context) async {
    // TODO: DB의 데이터를 받아서 데이터 있는 날짜만 활성화

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
      },
    );

    statisticCon.selectedDateData = await getSelectDates(selectedDate!);
    for (var data in statisticCon.selectedDateData) {
      print('sleepNum: ${data.sleepNum}, startTime: ${data.startTime}, endTime: ${data.endTime}, sleepDepth: ${data.sleepDepth}');
    }

    // print("내가 찍은 날짜 : ${selectedDate}");
    if (selectedDate != null) {
      statisticCon.selectedDate.value = selectedDate;
    }
  }


} // 클래스 끝
