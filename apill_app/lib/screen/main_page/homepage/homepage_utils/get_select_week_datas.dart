import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/models/week_month_posture_model.dart';
import 'package:mainproject_apill/models/week_start_end_model.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';

Future<List<SelectWeekSleepModel>> getSelectWeekSleepTimeData(DateTime Sunday, MqttHandler mqttHandler) async {
  // 매개변수로 일요일을 받아옴

  DateTime startDate = Sunday;
  DateTime endDate = Sunday.add(Duration(days: 6));

  String sql = '''
    SELECT
      sleep_num,
      TIMESTAMPDIFF(MINUTE, MIN(start_time), MAX(end_time)) AS total_sleep_time,
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

  String response = await mqttHandler.pubSqlWaitResponse(sql);
  print("✨get_select_week_datas.dart의 getSelectWeekData : $response");

  List<SelectWeekSleepModel> selectData = selectWeekDataFromJson(response);


  return selectData;
}

Future<List<WeekMonthPostureModel>> getSelectWeekPostureData(
    DateTime sunday, MqttHandler mqttHandler) async {
  // 매개변수로 일요일을 받아옴

  DateTime startDate = sunday;
  DateTime endDate = sunday.add(Duration(days: 6));

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
  print("✨get_select_week_datas.dart의 getSelectWeekPostureData1 : $response1");

  List<WeekStartEndModel> selectWeekData = weekStartEndDataFromJson(response1);

  DateTime selectStartTime = selectWeekData.first.startTime;
  DateTime selectEndTime = selectWeekData.last.endTime;

  String sql2 = '''
    SELECT
         CASE WHEN posture = 'DP' THEN 'DP' ELSE 'CP' END AS posture_type,
         DATE(start_time) AS date,
         SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS total_sleep_time
    FROM
         posture_history
    WHERE
         DATE(start_time) BETWEEN "$selectStartTime" AND "$selectEndTime"
    GROUP BY
         posture_type, date;
    ''';

  String response2 = await mqttHandler.pubSqlWaitResponse(sql2);
  print("✨get_select_week_datas.dart의 getSelectWeekPostureData2 : $response2");
  List<WeekMonthPostureModel> weekChartData =  weekMonthPostureModelFromJson(response2);

  return weekChartData;
}

