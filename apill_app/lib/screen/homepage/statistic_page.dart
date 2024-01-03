import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/LoadingController.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/getSelectDateDatas.dart';
import 'package:mainproject_apill/screen/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/getSelectWeekDatas.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/setInitialDate.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_piechart.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_today_body_chart.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_today_summary.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/utils/dateFormat.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/timeCalculators.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final statisticCon = Get.put(StatisticCon());

  final userCon = Get.put(UserController());

  final loading = Get.put(IsLoadingController());

  @override
  void initState() {
    super.initState();
    // 여기서 함수 호출
    // TODO: 날짜 초기화 함수 나중에 위치 바꿔줘야함
    setInitialDate().initializeData();
  }

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
                  IconButton(onPressed: () async {
                    IsLoadingController.to.isLoading = true;

                    int currentIndex = statisticCon.activeDates.indexOf(statisticCon.selectedDate.value);
                    if (currentIndex > 0) {
                      // 현재 선택된 날짜가 리스트의 첫 번째 요소가 아닌 경우
                      await checkDateTime(statisticCon.activeDates[currentIndex - 1]);
                      statisticCon.selectedDate.value = statisticCon.activeDates[currentIndex - 1];
                    }

                    IsLoadingController.to.isLoading = false;

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
                                Text("${statisticCon.totalSleepInPieChart.value}",
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 22
                                  ),),
                                // TODO : 수면시간 연동
                                Text("23:00 - 7:00",
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 12
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text("${DateFormatUtil().formattedDate(statisticCon.selectedDate.value)}",
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                      fontSize: 14
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () async {
                    IsLoadingController.to.isLoading = true;

                    int currentIndex = statisticCon.activeDates.indexOf(statisticCon.selectedDate.value);
                    if (currentIndex < statisticCon.activeDates.length - 1) {
                      // 현재 선택된 날짜가 리스트의 마지막 요소가 아닌 경우
                      await checkDateTime(statisticCon.activeDates[currentIndex + 1]);
                      statisticCon.selectedDate.value = statisticCon.activeDates[currentIndex + 1];
                    }

                    IsLoadingController.to.isLoading = false;

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

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
      helpText: "",
      useRootNavigator: false,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: (date) {
        return statisticCon.activeDates.contains(date);
      },
    );

    IsLoadingController.to.isLoading = true;

    statisticCon.selectedDateData = await getSelectDateData(selectedDate!);
    for (var data in statisticCon.selectedDateData) {
      print('sleepNum: ${data.sleepNum}, startTime: ${data.startTime}, endTime: ${data.endTime}, sleepDepth: ${data.sleepDepth}');
    }

    // print("내가 찍은 날짜 : ${selectedDate}");
    // 선택한 날짜를 변수에 대입
    statisticCon.selectedDate.value = selectedDate;

    IsLoadingController.to.isLoading = false;

  }


  Future<void> checkDateTime(DateTime selectedDate) async {
    // 선택한 날짜의 데이터 받기
    statisticCon.selectedDateData = await getSelectDateData(selectedDate);
    // 만약 선택한 날짜의 주일이 다르면
    if( TimeCalculators().findSunday(selectedDate) != statisticCon.selectedDateSunday.value ){
      // 선택한 날짜의 일주일 데이터 받기
      statisticCon.selectedWeekData = await getSelectWeekData(selectedDate);
      statisticCon.selectedDateSunday.value = TimeCalculators().findSunday(selectedDate);
    }
    // TODO : 만약 월이 달라진다면 데이터 받기

  }

} // 클래스 끝
