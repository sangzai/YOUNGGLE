import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';

Future<List<SelectWeekData>> getSelectWeekData(DateTime selectedDate, MqttHandler mqttHandler) async {
  // 매개변수로 일요일을 받아옴

  DateTime startDate = selectedDate;
  DateTime endDate = selectedDate.add(Duration(days: 6));

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
  // print("✨get_select_week_datas.dart의 getSelectWeekData : $response");

  List<SelectWeekData> selectData = selectWeekDataFromJson(response);


  return selectData;
}