import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mainproject_apill/loading_controller.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/screen/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/time_calculators.dart';
import 'package:mainproject_apill/utils/db_connector.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/get_select_date_datas.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/get_select_week_datas.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_piechart.dart';
class setInitialDate {

  final statisticCon = Get.put(StatisticCon());

  // 오늘 날짜를 DB 데이터가 있는 마지막 날짜로 바꿔주기
  Future<void> initializeData() async {
    IsLoadingController.to.isLoading = true;
    // DB에 있는 데이터를 받아오는 함수
    await getActiveDates();
    // 오늘 날짜를 활성화된 날짜의 마지막 날로 바꿔주기
    await setInitialSelectedDate();
    // selectedDate가 바뀌면 selectedDateSunday 변경
    await setInitialSunday();

    // 선택한 날짜의 데이터 받기
    await setInitialDateData();



    // 선택한 날짜의 일주일 데이터 받기
    await setInitialWeekData();
    // TODO : 선택한 날짜의 월간 데이터 받기


    IsLoadingController.to.isLoading = false;

  }

  Future<void> getActiveDates() async {
    List<DateTime> dateList = [];
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
    var result = await dbConnector(sql);

    if (result != null) {
      for (final row in result) {
        // print(row.assoc());
        dateList.add(DateTime.parse(row.assoc()['date']!));

      }
      statisticCon.activeDates.addAll(dateList);
    }
  }

  // 내가 선택한 날짜 초기값을 활성화된 날짜 마지막날로
  Future<void> setInitialSelectedDate() async {
    statisticCon.selectedDate.value = statisticCon.activeDates.isNotEmpty ? statisticCon.activeDates.last : DateTime.now();
  }

  // 내가 선택한 날짜의 일요일을 찾아서 초기값 설정
  Future<void> setInitialSunday() async {
    statisticCon.selectedDateSunday.value = TimeCalculators().findSunday(statisticCon.selectedDate.value);
  }

  // 초기 데이터 받아서 적용
  Future<void> setInitialDateData() async {
    // 하루치 데이터 받아오기
    statisticCon.selectedDateData = RxList<SelectDateData>.from(await getSelectDateData(statisticCon.selectedDate.value));
    // 하루치 데이터 SleepNum으로 쪼개기
    statisticCon.splitselectedDateData = RxList<List<SelectDateData>>.from(await splitDateData(statisticCon.selectedDateData));
    // 쪼갠 데이터 중 가장 수면시간이 긴 데이터의 인덱스를 구하기
    statisticCon.pieIndex.value = await findLongestSleep(statisticCon.splitselectedDateData as List<List<SelectDateData>>);
    // 가장 수면시간이 긴 데이터를 파이차트 안쪽 텍스트에 적용(총 수면시간)
    statisticCon.totalSleepInPieChart.value = pieChartTotalSleep(statisticCon.splitselectedDateData[statisticCon.pieIndex.value]);
    // 가장 수면시간이 긴 데이터를 파이차트 안쪽 텍스트에 적용(수면 시작 시간 및 수면 종료 시간)
    statisticCon.startEndTimeInPieChart.value = pieChartTimeRange(statisticCon.splitselectedDateData[statisticCon.pieIndex.value]);

    // 파이차트 테스트
    statisticCon.pieData.assignAll(getSplitDataSleepTime(statisticCon.splitselectedDateData as List<List<SelectDateData>>, statisticCon.selectedDate.value));


  }

  // 초기 데이터 받아서 주간 데이터 적용
  Future<void> setInitialWeekData() async {
    statisticCon.selectedWeekData = RxList<SelectWeekData>.from(await getSelectWeekData(statisticCon.selectedDateSunday.value));
  }





}

