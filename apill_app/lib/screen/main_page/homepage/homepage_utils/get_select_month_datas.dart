import 'package:mainproject_apill/models/select_month_model.dart';

Future<List<SelectMonthData>> getSelectMonthData(DateTime selectedDate) async {
  // 매개변수로 일요일을 받아옴

  List<SelectMonthData> selectMonthDataList = [];
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
    Between :startdate and :enddate;
      );
  ''';

  return selectMonthDataList;
}