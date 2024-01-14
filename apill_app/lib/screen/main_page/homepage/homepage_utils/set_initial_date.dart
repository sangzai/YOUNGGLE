import 'package:get/get.dart';
import 'package:mainproject_apill/loading_controller.dart';
import 'package:mainproject_apill/models/active_date_model.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/get_select_month_datas.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/time_calculators.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/get_select_date_datas.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/get_select_week_datas.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
class SetInitialDate {

  final mqttHandler = Get.find<MqttHandler>();
  // MqttHandler mqttHandler

  final statisticCon = Get.find<StatisticCon>();

  // 오늘 날짜를 DB 데이터가 있는 마지막 날짜로 바꿔주기
  Future<void> initializeData() async {
    await mqttHandler.setUnsubscribe();
    // 로딩 켜
    IsLoadingController.to.isLoading = true;

    // DB에 있는 데이터를 받아오는 함수
    await getActiveDates();
    Future.delayed(Duration(seconds: 1));

    // 오늘 날짜를 활성화된 날짜의 마지막 날로 바꿔주기
    await setInitialSelectedDate();
    // selectedDate가 바뀌면 selectedDateSunday 변경
    await setInitialSunday();
    // 선택한 날짜의 데이터 받기
    await setInitialDateData();
    Future.delayed(Duration(seconds: 1));
    // 선택한 날짜의 일주일 데이터 받기
    await setInitialWeekData();
    Future.delayed(Duration(seconds: 1));

    await setInitialMonthData();
    Future.delayed(Duration(seconds: 1));

    // 로딩 화면 꺼
    IsLoadingController.to.isLoading = false;
    await mqttHandler.setSubscribe();
    await mqttHandler.pubCheckPillowWaitResponse();
    // mqttHandler.pubAppOn();
  }

  Future<void> getActiveDates() async {
    // sql 문 정의
    String sql = '''
      SELECT distinct
        CASE WHEN HOUR(start_time) >= 18 THEN DATE_ADD(DATE(start_time), INTERVAL 1 DAY) ELSE DATE(start_time) END AS date
      FROM (select
              sleep_num,
              MIN(start_time) AS start_time
            from
              mibanddata
            group by
              sleep_num) AS grouptime;
      ''';

    String response = await mqttHandler.pubSqlWaitResponse(sql);
    print('✨set_initial_date.dart 파일의 getActiveDates함수 완료');
    print("✨✨response : $response");

    // JSON 응답을 MemberModel 리스트로 변환
    List<ActiveDateModel> activeList = activeDateModelFromJson(response);
    // print('오류 확인');

    // 각 MemberModel에서 DateTime 객체를 추출하여 dateList로 만듦
    List<DateTime> dateList = activeList.map((member) => member.date).toList();

    statisticCon.activeDates.addAll(dateList);
  }

  // 내가 선택한 날짜 초기값을 활성화된 날짜 마지막날로
  Future<void> setInitialSelectedDate() async {
    statisticCon.selectedDate.value = statisticCon.activeDates.isNotEmpty ? statisticCon.activeDates.last : DateTime.now();
    print('✨set_initial_date.dart 파일의 setInitialSelectedDate 함수 완료');
  }

  // 내가 선택한 날짜의 일요일을 찾아서 초기값 설정
  Future<void> setInitialSunday() async {
    statisticCon.selectedDateSunday.value = TimeCalculators().findSunday(statisticCon.selectedDate.value);
    print('✨set_initial_date.dart 파일의 setInitialSunday 함수 완료');

  }

  // 초기 데이터 받아서 적용
  Future<void> setInitialDateData() async {
    // 하루치 데이터 받아오기
    statisticCon.selectedDateData = RxList<SelectDateData>.from(
        await getSelectDateData(statisticCon.selectedDate.value, mqttHandler)
    );
    print('✨set_initial_date.dart 파일의 getSelectDateData 함수 1');
    Future.delayed(Duration(seconds: 1));

    // 하루치 데이터 SleepNum으로 쪼개기
    statisticCon.splitSelectedDateData = RxList<List<SelectDateData>>.from(
        await splitDateData(statisticCon.selectedDateData)
    );
    print('✨set_initial_date.dart 파일의 splitDateData 함수 2');

    // 쪼갠 데이터 중 가장 수면시간이 긴 데이터의 인덱스를 구하기
    statisticCon.pieIndex.value = await findLongestSleep(
        statisticCon.splitSelectedDateData as List<List<SelectDateData>>
    );
    print('✨set_initial_date.dart 파일의 findLongestSleep 함수 3');

    // 가장 수면시간이 긴 데이터를 파이차트 안쪽 텍스트에 적용(총 수면시간)
    statisticCon.totalSleepInPieChart.value = pieChartTotalSleep(
        statisticCon.splitSelectedDateData[statisticCon.pieIndex.value]
    );
    print('✨set_initial_date.dart 파일의 pieChartTotalSleep 함수 4');

    // 가장 수면시간이 긴 데이터를 파이차트 안쪽 텍스트에 적용(수면 시작 시간 및 수면 종료 시간)
    statisticCon.startEndTimeInPieChart.value = pieChartTimeRange(
        statisticCon.splitSelectedDateData[statisticCon.pieIndex.value]
    );
    print('✨set_initial_date.dart 파일의 pieChartTimeRange 함수 5');


    // 파이차트 데이터넣기
    statisticCon.pieData.assignAll(
        getPieData(
            statisticCon.splitSelectedDateData as List<List<SelectDateData>>,
            statisticCon.selectedDate.value)
    );
    print('✨set_initial_date.dart 파일의 getPieData 함수 6');


    // 라인차트 데이터넣기
    statisticCon.lineData.assignAll(
        getLineData(statisticCon.splitSelectedDateData[statisticCon.pieIndex.value])
    );
    print('✨set_initial_date.dart 파일의 getLineData 함수 7');

    statisticCon.lineBottomTitle.assignAll(
        getLineBottomTitle(statisticCon.splitSelectedDateData[statisticCon.pieIndex.value])
    );
    print('✨set_initial_date.dart 파일의 getLineBottomTitle 함수 8');


    // 자세 차트 데이터
    Future.delayed(Duration(seconds: 1));
    // 자세 데이터 받기
    statisticCon.stackBarChartData.assignAll(
        await getBarChartData(
            statisticCon.splitSelectedDateData[statisticCon.pieIndex.value],
            mqttHandler)
    );
    // statisticCon.stackBarChartData
    print('✨set_initial_date.dart 파일의 getBarChartData 함수 9');
    Future.delayed(Duration(seconds: 1));


  }

  // 초기 데이터 받아서 주간 데이터 적용
  Future<void> setInitialWeekData() async {
    statisticCon.selectedWeekSleepData = RxList<SelectWeekSleepModel>.from(
        await getSelectWeekSleepTimeData(statisticCon.selectedDateSunday.value, mqttHandler)
    );
    print('✨set_initial_date.dart 파일의 setInitialWeekData 함수');


    statisticCon.weekPostureTimeData.assignAll(
        await getSelectWeekPostureData(statisticCon.selectedDateSunday.value, mqttHandler)
    );
    print('✨set_initial_date.dart 파일의 getSelectWeekPostureData 함수 완료');

  }

  // ✨월간 데이터 적용하기
  Future<void> setInitialMonthData() async {
    statisticCon.setMonthStartEndData.assignAll(getMonthStartEndList(statisticCon.selectedDate.value)) ;

    statisticCon.monthChartData.assignAll(
        await getSelectMonthData(
        statisticCon.setMonthStartEndData, mqttHandler)
    );

    print('✨월간 데이터 적용');
  }
}

