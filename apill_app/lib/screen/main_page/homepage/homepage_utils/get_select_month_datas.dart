import 'package:mainproject_apill/models/month_sleep_model.dart';
import 'package:mainproject_apill/models/week_month_posture_model.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';

// 주차 확인 하는 함수

List<DateTime> getMonthStartEndList (DateTime selectedDate) {
  List<DateTime> result = [];
  //선택한 연도
  int selectedDateYear = selectedDate.year;
  //선택한 달
  int selectedDateMonth = selectedDate.month;
  //달력의 1일
  DateTime firstDayOfMonth = DateTime(selectedDateYear, selectedDateMonth, 1);
  //달력의 1일의 요일
  int selectedFirstDateWeekday = firstDayOfMonth.weekday;
  //달력의 마지막 날
  DateTime lastDayOfMonth = DateTime(selectedDateYear, selectedDateMonth + 1, 0);
  //달력의 마지막 날의 요일
  int selectedLastDateWeekday = lastDayOfMonth.weekday;

  DateTime lastSaturdayDate;
  DateTime firstSundayDate;

  // 만약 요일이 목요일에서 토요일 사이에 있다면 이번주 일요일을 찾고
  // 아니라면 저번주 일요일을 찾는다
  if (selectedFirstDateWeekday>3 && selectedFirstDateWeekday<7){
    firstSundayDate = firstDayOfMonth.add(Duration(days: 7 - selectedFirstDateWeekday));
    result.add(firstSundayDate);
  } else {
    firstSundayDate = firstDayOfMonth.subtract(Duration(days : selectedFirstDateWeekday));
    result.add(firstSundayDate);
  }

  if ( selectedLastDateWeekday>2 && selectedLastDateWeekday<7){
    lastSaturdayDate = lastDayOfMonth.add(Duration(days: 6 - selectedLastDateWeekday));
    result.add(lastSaturdayDate);
  } else {
    lastSaturdayDate = lastDayOfMonth.subtract(Duration(days : selectedLastDateWeekday));
    result.add(lastSaturdayDate);
  }

  return result;

}




Future<List> getSelectMonthData(
    List<DateTime> setMonthStartEndData,
    MqttHandler mqttHandler) async {

  // 검색 시작 날짜
  DateTime startDate = setMonthStartEndData[0];
  print("✨✨✨startDate : $startDate");
  // 검색 끝 날짜
  DateTime endDate = setMonthStartEndData[1];
  print("✨✨✨endDate : $endDate");
  int Datelength = startDate.difference(endDate).inDays + 1;
  print("✨✨✨endDate : $endDate");
  String sql1 = '''
        SELECT
      MiN(start_time) AS start_time,
      MAX(end_time) AS end_time,
      CASE WHEN HOUR(MIN(start_time)) >= 18 THEN DATE_ADD(DATE(MIN(start_time)), INTERVAL 1 DAY) ELSE DATE(MIN(start_time)) END AS date
    FROM
      mibanddata
    GROUP BY
      sleep_num
    HAVING
      CASE WHEN HOUR(MIN(start_time)) >= 18 
         THEN DATE_ADD(DATE(MIN(start_time)), INTERVAL 1 DAY) 
         ELSE DATE(MIN(start_time)) 
      END
        Between "$startDate" and "$endDate";
  ''';


  String response1 = await mqttHandler.pubSqlWaitResponse(sql1);
  print('✨✨월 함수 sql1 실행 완료 : ✨$response1');
  await Future.delayed(Duration(seconds: 1));
  // 한달치 수면시작 수면 끝 날짜 데이터가 들어있음
  List<MonthSleepModel>monthSleepList =  monthSleepModelFromJson(response1);


  // 자세 검색을 위해 날짜에 시간이 포함된 시작 시간
  DateTime startTime = monthSleepList.first.startTime;
  // 자세 검색을 위해 날짜에 시간이 포함된 끝 시간
  DateTime endTime = monthSleepList.last.endTime;

  String sql2 = """
          SELECT
             CASE WHEN posture = 'DP' THEN 'DP' ELSE 'CP' END AS posture_type,
             DATE(start_time) AS date,
             SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS total_sleep_time
          FROM
             posture_history
          WHERE
             DATE(start_time) BETWEEN "$startTime" AND "$endTime"
          GROUP BY
             posture_type, date;
          """;

  String response2 = await mqttHandler.pubSqlWaitResponse(sql2);
  print('✨✨월 함수 sql2 실행 완료 : ✨$response2');
  await Future.delayed(Duration(seconds: 1));
  // 자세와 날짜와 수면시간(분) 들어있음
  List<WeekMonthPostureModel> monthPostureList = weekMonthPostureModelFromJson(response2);

  var totalList = [];

  double sumA = 0.0;
  double sumDP = 0.0;
  double sumCP = 0.0;

  int countA = 0;
  int countDP = 0;
  int countCP = 0;

  for (int i = 0; i < Datelength ; i++){
    MonthSleepModel? findElementA = monthSleepList.where(
            (element) => element.date == startDate.add(Duration(days: i))
    ).firstOrNull;
    if (findElementA != null ) {
      sumA += findElementA.startTime.difference(
          findElementA.endTime).inMinutes.toDouble();
      countA ++;
    }

    WeekMonthPostureModel? findElementDP = monthPostureList.where(
            (element) => (element.date == startDate.add(Duration(days: i)))
                && element.postureType == 'DP'
    ).firstOrNull;
    if (findElementDP != null ) {
      sumDP += findElementDP.totalSleepTime.toDouble();
      countDP ++;
    }

    WeekMonthPostureModel? findElementCP = monthPostureList.where(
            (element) => (element.date == startDate.add(Duration(days: i)))
                && element.postureType == 'CP'
    ).firstOrNull;
    if (findElementCP != null ) {
      sumCP += findElementCP.totalSleepTime.toDouble();
      countCP ++;
    }

    if ( (i + 1) % 7 == 0 ){
      totalList.add([sumA/countA,sumDP/countDP,sumCP/countCP]);
      sumA = 0.0;
      sumDP = 0.0;
      sumCP = 0.0;

      countA = 0;
      countDP = 0;
      countCP = 0;
    }

  }//for끝

  return totalList;
}