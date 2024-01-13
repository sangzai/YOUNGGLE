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

    return Obx((){
      int positionChangeCount = statisticCon.stackBarChartData.length - 1 ;
      String totalTodaySleepTime = getTotalTodaySleepTime(statisticCon.splitSelectedDateData);
      // statisticCon.stackBarChartData

      String frontTime = getFrontPositionSleepTime(statisticCon.stackBarChartData);
      String SideTime = getSidePositionSleepTime(statisticCon.stackBarChartData);

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
                Text('${userCon.userName.value}님의 수면 정보',
                  style: Theme.of(context).textTheme.headlineLarge,),
                Text('총 수면시간 : $totalTodaySleepTime',
                  style: Theme.of(context).textTheme.headlineMedium,),
                Text('뒤척임 횟수 : $positionChangeCount회',
                  style: Theme.of(context).textTheme.headlineMedium,),
                Text('등누운자세 : $frontTime',style: Theme.of(context).textTheme.headlineMedium,),
                Text('옆누운자세 : $SideTime',style: Theme.of(context).textTheme.headlineMedium,),
                // Text('코골이 시간 : ',style: Theme.of(context).textTheme.headlineMedium,),
              ] // Column children
          ),
        ),

      );
    });

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
    num sleepTimeInt = 0;

    for (int i = 0; i < stackBarChartData.length; i++) {
      if (stackBarChartData[i].posture == 'DP'){
        sleepTimeInt += stackBarChartData[i].minutes;
      }
    }

    int hours = sleepTimeInt ~/ 60;  // '~/'는 나누기 연산 후 소수점 이하를 버립니다.
    int minutes = sleepTimeInt % 60 as int;

    frontPositionSleepTime = '$hours시간 $minutes분';

    return frontPositionSleepTime;
  }

  String getSidePositionSleepTime(List stackBarChartData){
    String SidePositionSleepTime = '';
    num sleepTimeInt = 0;

    for (int i = 0; i < stackBarChartData.length; i++) {
      if (stackBarChartData[i].posture == 'CP'){
        sleepTimeInt += stackBarChartData[i].minutes;
      }
    }

    int hours = sleepTimeInt ~/ 60;  // '~/'는 나누기 연산 후 소수점 이하를 버립니다.
    int minutes = sleepTimeInt % 60 as int;

    SidePositionSleepTime = '$hours시간 $minutes분';

    return SidePositionSleepTime;
  }



} // 클래스 끝
