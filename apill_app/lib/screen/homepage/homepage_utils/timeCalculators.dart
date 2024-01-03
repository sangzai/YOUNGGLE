import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/screen/homepage/homepage_controllers/statistic_controller.dart';

class TimeCalculators {
  final statisticCon = Get.put(StatisticCon());

  // 하루 수면 시간
  String getDateTotalSleep(List<SelectDateData> sleepData) {
    // Create a map to store the start and end times for each sleepNum
    Map<int, List<DateTime>> sleepTimes = {};

    // Iterate through the sleepData and populate the map
    for (var data in sleepData) {
      if (!sleepTimes.containsKey(data.sleepNum)) {
        sleepTimes[data.sleepNum] = [data.startTime, data.endTime];
      } else {
        sleepTimes[data.sleepNum]![1] = data.endTime;
      }
    }

    // Calculate the total sleep time
    Duration totalSleepTime = Duration();

    sleepTimes.forEach((sleepNum, times) {
      totalSleepTime += times[1].difference(times[0]);
    });

    String formattedTime = DateFormat('HH시간 mm분').format(DateTime(0, 1, 1, totalSleepTime.inHours, totalSleepTime.inMinutes));

    return formattedTime;
  }

  DateTime findSunday(DateTime date) {
    int daysUntilSunday = date.weekday - DateTime.sunday;
    return daysUntilSunday >= 0
        ? date.subtract(Duration(days: daysUntilSunday))
        : date.subtract(Duration(days: 7 + daysUntilSunday));
  }



}