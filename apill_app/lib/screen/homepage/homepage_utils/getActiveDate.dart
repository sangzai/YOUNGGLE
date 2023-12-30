import 'package:mainproject_apill/utils/dbConnector.dart';

Future<List<DateTime>> getActiveDates() async {
  List<DateTime> dateList = [];
  String sql = '''SELECT distinct
  CASE WHEN HOUR(start_time) >= 18 THEN DATE_ADD(DATE(start_time), INTERVAL 1 DAY) ELSE DATE(start_time) END AS date
  FROM (select
			sleep_num,
			MIN(start_time) AS start_time
		from
			mibanddata
		group by
			sleep_num) AS grouptime;''';
  var result = await dbConnector(sql);

  if (result != null) {
    for (final row in result) {
      // print(row.assoc());
      dateList.add(DateTime.parse(row.assoc()['date']!));
    }
  }

  return dateList;
}