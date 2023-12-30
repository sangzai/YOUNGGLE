import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/utils/dbConnector.dart';

Future<List<SelectDateData>> getSelectDates(selectedDate) async {
  List<SelectDateData> selectDatedataList = [];

  // 선택한 날짜 전날의 오후 6시
  DateTime startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1, 18, 0, 0);

  // 선택한 날짜의 오후 6시
  DateTime endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 18, 0, 0);

  String sql = '''
  SELECT
    sleep_num,
    MIN(start_time) AS min_start_time,
    MAX(end_time) AS max_end_time,
    TIMESTAMPDIFF(MINUTE, MIN(start_time), MAX(end_time)) AS total_sleep_time
  FROM
    mibanddata
  GROUP BY
    sleep_num
  HAVING
    min_start_time >= :start AND min_start_time < :end;
  ''';

  var result = await dbConnector(sql, {
   'start' : startDate,
    'end' : endDate
  });

  if (result != null) {
    for (final row in result) {
      // print((row.assoc()));
      SelectDateData selectData = SelectDateData(
          sleepNum: int.parse(row.assoc()['sleep_num']!),
          minStartTime: DateTime.parse(row.assoc()['min_start_time']!),
          maxEndTime: DateTime.parse(row.assoc()['max_end_time']!),
          totalSleepTime: int.parse(row.assoc()['total_sleep_time']!)
      );
      selectDatedataList.add(selectData);

    }
  }

  return selectDatedataList;
}