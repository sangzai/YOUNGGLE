import 'package:mainproject_apill/models/selecMonthModel.dart';
import 'package:mainproject_apill/utils/dbConnector.dart';

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

  var result = await dbConnector(sql, {
    'startdate' : startDate,
    'enddate' : endDate
  });

  if (result != null) {
    for (final row in result) {
      // print((row.assoc()));
      SelectMonthData selectData = SelectMonthData(
        sleepNum: int.parse(row.assoc()['sleep_num']!),
        totalSleepTime: int.parse(row.assoc()['total_sleep_time']!),
        Date: DateTime.parse(row.assoc()['date']!),
      );
      selectMonthDataList.add(selectData);

    }
  }

  return selectMonthDataList;
}