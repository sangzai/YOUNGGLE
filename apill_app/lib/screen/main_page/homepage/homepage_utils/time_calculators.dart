import 'package:get/get.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';

class TimeCalculators {
  final statisticCon = Get.put(StatisticCon());

  // 수면시간 반환
  Duration getTotalSleep(List<SelectDateData> sleepData) {
    if (sleepData.isEmpty) {
      // 리스트가 비어있을 경우 기본값 반환하거나 비어있는 경우 처리를 해주세요
      return Duration(hours: 0,minutes: 0);
    }

    // 첫 번째 행의 startTime
    DateTime startTime = sleepData.first.startTime;

    // 마지막 행의 endTime
    DateTime endTime = sleepData.last.endTime;

    // 시작 시간과 종료 시간 사이의 시간 차이 계산
    Duration difference = endTime.difference(startTime);

    return difference;
  }

  DateTime findSunday(DateTime date) {
    int daysUntilSunday = date.weekday - DateTime.sunday;
    return daysUntilSunday >= 0
        ? date.subtract(Duration(days: daysUntilSunday))
        : date.subtract(Duration(days: 7 + daysUntilSunday));
  }



}