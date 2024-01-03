import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mainproject_apill/LoadingController.dart';
import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/screen/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/timeCalculators.dart';
import 'package:mainproject_apill/utils/dbConnector.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/getSelectDateDatas.dart';
import 'package:mainproject_apill/screen/homepage/homepage_utils/getSelectWeekDatas.dart';

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

  Future<void> setInitialSelectedDate() async {
    statisticCon.selectedDate.value = statisticCon.activeDates.isNotEmpty ? statisticCon.activeDates.last : DateTime.now();
  }

  Future<void> setInitialSunday() async {
    statisticCon.selectedDateSunday.value = TimeCalculators().findSunday(statisticCon.selectedDate.value);
  }

  Future<void> setInitialDateData() async {
    statisticCon.selectedDateData = await getSelectDateData(statisticCon.selectedDate.value);
    statisticCon.totalSleepInPieChart.value = TimeCalculators().getDateTotalSleep(statisticCon.selectedDateData);
  }

  Future<void> setInitialWeekData() async {
    statisticCon.selectedWeekData = await getSelectWeekData(statisticCon.selectedDateSunday.value);
  }





}

