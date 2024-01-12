import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/loading_controller.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/get_select_date_datas.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/get_select_week_datas.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/set_initial_date.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_widgets/statistic_piechart.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_widgets/statistic_today_body_chart.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_widgets/statistic_today_summary.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/time_calculators.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mqtt_client/mqtt_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mqttHandler = Get.find<MqttHandler>();

  final statisticCon = Get.find<StatisticCon>();

  final userCon = Get.find<UserController>();

  final loading = Get.put(IsLoadingController());

  @override
  void initState() {
    super.initState();
    SetInitialDate().initializeData();
    // 여기서 함수 호출
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
                      return Visibility(
                        visible: statisticCon.appbarCheck.value,
                        child: SizedBox(
                          height: statisticCon.heightAnimation!.value,
                          child: AppBar(
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.only(left: 8,right: 20),
                              child: Opacity(
                                opacity: statisticCon.opacityAnimation?.value ?? 1.0,
                                child: SingleChildScrollView(
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

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () async {
                    // 로딩 화면 띄우기
                    IsLoadingController.to.isLoading = true;

                    // selectedDate의 현재 인덱스 확인
                    int currentIndex = statisticCon.activeDates.indexOf(statisticCon.selectedDate.value);

                    // 현재 선택된 날짜가 리스트의 첫 번째 요소가 아닌 경우
                    if (currentIndex > 0) {
                      // selectedDate의 날짜를 변경
                      statisticCon.selectedDate.value = statisticCon.activeDates[currentIndex - 1];

                      // 다음 날짜의 데이터를 가져오고
                      await checkDateTime(statisticCon.activeDates[currentIndex - 1], mqttHandler);
                    }

                    IsLoadingController.to.isLoading = false;

                  }, icon: const FaIcon(FontAwesomeIcons.chevronLeft),
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
                            const SizedBox(
                              height: 220,
                              width: 220,
                              child: HomePieChart(),
                            ),

                            // TODO : 파이차트 구현
                            SizedBox(
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
                                Text(statisticCon.totalSleepInPieChart.value,
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 22
                                  ),),
                                // TODO : 수면시간 연동
                                Text(statisticCon.startEndTimeInPieChart.value,
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 12
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(formattedDate(statisticCon.selectedDate.value),
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
                    // 로딩 화면 띄우기
                    IsLoadingController.to.isLoading = true;

                    // selectedDate의 현재 인덱스 확인
                    int currentIndex = statisticCon.activeDates.indexOf(statisticCon.selectedDate.value);

                    // 현재 선택된 날짜가 리스트의 마지막 요소가 아닌 경우

                    if (currentIndex < statisticCon.activeDates.length - 1) {
                      // selectedDate의 날짜를 변경
                      statisticCon.selectedDate.value = statisticCon.activeDates[currentIndex + 1];

                      // 다음 날짜의 데이터를 가져오고
                      await checkDateTime(statisticCon.activeDates[currentIndex + 1], mqttHandler);
                    }

                    // 다 끝나면 로딩 화면 끄기
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
                child: TodaySummary(),
              ),

            ],)
        ),
      ),
    );


  } // 빌드 끝

  Future<void> get_statistic_data(BuildContext context) async {

    // 날짜를 선택
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

    // IsLoadingController.to.isLoading = true;

    // statisticCon.selectedDateData = RxList<SelectDateData>.from(await getSelectDateData(selectedDate!));
    // for (var data in statisticCon.selectedDateData) {
    //   print('sleepNum: ${data.sleepNum}, startTime: ${data.startTime}, endTime: ${data.endTime}, sleepDepth: ${data.sleepDepth}');
    // }

    // 선택한 날짜가 현재 날짜와 다르다면 변수에 대입하고 데이터 체크
    if(selectedDate != null) {
      statisticCon.selectedDate.value = selectedDate;
      await checkDateTime(selectedDate, mqttHandler);
    }


    // IsLoadingController.to.isLoading = false;

  }


  Future<void> checkDateTime(DateTime selectedDate, MqttHandler mqttHandler) async {
    mqttHandler.client.unsubscribe('Apill/App/powercheck/return');
    mqttHandler.data.value = '';

    // 선택한 날짜의 데이터 받기
    statisticCon.selectedDateData = RxList<SelectDateData>.from(await getSelectDateData(selectedDate, mqttHandler));
    Future.delayed(Duration(seconds: 1));

    // 바뀐 날짜에 맞게 파이차트 그래프 수정
    // 하루치 데이터 SleepNum으로 쪼개기
    statisticCon.splitSelectedDateData = RxList<List<SelectDateData>>.from(await splitDateData(statisticCon.selectedDateData));

    // 쪼갠 데이터 중 가장 수면시간이 긴 데이터의 인덱스를 구하기
    statisticCon.pieIndex.value = await findLongestSleep(statisticCon.splitSelectedDateData as List<List<SelectDateData>>);
    // 가장 수면시간이 긴 데이터를 파이차트에 적용(총 수면시간)
    statisticCon.totalSleepInPieChart.value = pieChartTotalSleep(statisticCon.splitSelectedDateData[statisticCon.pieIndex.value]);
    // 가장 수면시간이 긴 데이터를 파이차트에 적용(수면 시작 시간 및 수면 종료 시간)
    statisticCon.startEndTimeInPieChart.value = pieChartTimeRange(statisticCon.splitSelectedDateData[statisticCon.pieIndex.value]);

    // 파이차트 데이터 넣기
    statisticCon.pieData.assignAll(getPieData(statisticCon.splitSelectedDateData as List<List<SelectDateData>>, statisticCon.selectedDate.value));

    // 라인차트 데이터넣기
    statisticCon.lineData.assignAll(getLineData(statisticCon.splitSelectedDateData[statisticCon.pieIndex.value]));
    statisticCon.lineBottomTitle.assignAll(getLineBottomTitle(statisticCon.splitSelectedDateData[statisticCon.pieIndex.value]));

    Future.delayed(Duration(seconds: 1));
    // 자세 데이터 받기
    statisticCon.stackBarChartData.assignAll(
        await getBarChartData(
            statisticCon.splitSelectedDateData[statisticCon.pieIndex.value],
            mqttHandler)
    );
    print("나의 간절함 ");
    Future.delayed(Duration(seconds: 1));

    // 만약 선택한 날짜의 주일이 다르면
    if( TimeCalculators().findSunday(selectedDate) != statisticCon.selectedDateSunday.value ){
      // 선택한 날짜의 일주일 데이터 받기
      statisticCon.selectedWeekData = RxList<SelectWeekData>.from(
          await getSelectWeekData(TimeCalculators().findSunday(selectedDate), mqttHandler)
      );
      Future.delayed(Duration(seconds: 1));

      statisticCon.selectedDateSunday.value = TimeCalculators().findSunday(selectedDate);
    }

    // TODO : 만약 월이 달라진다면 데이터 받기



    mqttHandler.client.subscribe('Apill/App/powercheck/return',MqttQos.atMostOnce);
  }

} // 클래스 끝
