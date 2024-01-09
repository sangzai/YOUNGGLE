import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_controllers/statistic_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/time_calculators.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class TodaySummary extends StatelessWidget {
  TodaySummary({super.key});
  final statisticCon = Get.find<StatisticCon>();
  final userCon = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    int positionChangeCount = statisticCon.stackBarChartData.length - 1 ;
    String totalTodaySleepTime = getTotalTodaySleepTime(statisticCon.splitSelectedDateData);
    print(totalTodaySleepTime);

    return Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.containerBackColor
        ),
        width: MediaQuery.of(context).size.width,
        // TODO 그래프 구현 2
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${userCon.userName.value}님의 일간 수면 정보',
                style: Theme.of(context).textTheme.headlineLarge,),
              Text('수면시간 : $totalTodaySleepTime',
                style: Theme.of(context).textTheme.headlineMedium,),
              Text('뒤척임 횟수 : $positionChangeCount회',
                style: Theme.of(context).textTheme.headlineMedium,),
              Text('옆누운자세 : ',style: Theme.of(context).textTheme.headlineMedium,),
              Text('등누운자세 : ',style: Theme.of(context).textTheme.headlineMedium,),
              // Text('코골이 시간 : ',style: Theme.of(context).textTheme.headlineMedium,),
            ] // Column children
          ),
        ),

    );
  } // 빌드 끝

  Future<int> findLongestSleep(List<List<SelectDateData>> splitSelectedDateData) async {
    int maxIndex = -1;
    Duration maxSleepDuration = Duration();

    for (int i = 0; i < splitSelectedDateData.length; i++) {
      List<SelectDateData> sleepData = splitSelectedDateData[i];
      Duration totalSleepDuration = TimeCalculators().getTotalSleep(sleepData);

      if (totalSleepDuration > maxSleepDuration) {
        maxSleepDuration = totalSleepDuration;
        maxIndex = i;
      }
    }

    return maxIndex;
  }

  String getTotalTodaySleepTime (List splitSelectedDateData) {
    String totalTodaySleepTime = '';
    Duration maxSleepDuration = Duration();
    for (int i = 0; i < splitSelectedDateData.length; i++) {
      List<SelectDateData> sleepData = splitSelectedDateData[i];
      Duration totalSleepDuration = TimeCalculators().getTotalSleep(sleepData);
      maxSleepDuration += totalSleepDuration;
    }

    totalTodaySleepTime = '${maxSleepDuration.inHours.toString()}시간 ${maxSleepDuration.inMinutes % 60}분';

    return totalTodaySleepTime;
  }

  String getFrontPositionSleepTime(List stackBarChartData){
    String frontPositionSleepTime = '';
    Duration maxSleepDuration = Duration();

    for (int i = 0; i < stackBarChartData.length; i++) {
      List<SelectDateData> sleepData = stackBarChartData[i];
      Duration totalSleepDuration = TimeCalculators().getTotalSleep(sleepData);

      if (totalSleepDuration > maxSleepDuration) {
        maxSleepDuration += totalSleepDuration;
      }
    }

    return frontPositionSleepTime;
  }


} // 클래스 끝
