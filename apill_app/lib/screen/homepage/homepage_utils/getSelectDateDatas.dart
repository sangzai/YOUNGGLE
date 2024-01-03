import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/utils/dbConnector.dart';

Future<List<SelectDateData>> getSelectDateData(DateTime selectedDate) async {
  List<SelectDateData> selectDateDataList = [];

  String sql = '''
  SELECT
    *
  FROM
      mibanddata
  WHERE
      sleep_num IN (
          SELECT
              sleep_num
          FROM
              mibanddata
          GROUP BY
              sleep_num
          HAVING
              CASE WHEN HOUR(MIN(start_time)) >= 18 
                   THEN DATE_ADD(DATE(MIN(start_time)), INTERVAL 1 DAY) 
                   ELSE DATE(MIN(start_time)) 
              END = :selectedDate
      );
  ''';

  var result = await dbConnector(sql, {
   'selectedDate' : selectedDate
  });

  if (result != null) {
    for (final row in result) {
      // print((row.assoc()));
      SelectDateData selectData = SelectDateData(
          sleepNum: int.parse(row.assoc()['sleep_num']!),
          startTime: DateTime.parse(row.assoc()['start_time']!),
          endTime: DateTime.parse(row.assoc()['end_time']!),
          sleepDepth: int.parse(row.assoc()['sleep_depth']!)
      );
      selectDateDataList.add(selectData);

    }
  }
  print("겟 셀렉트 데이트 데이터 : ${selectDateDataList}");

  return selectDateDataList;
}