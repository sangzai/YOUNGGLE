import 'package:mainproject_apill/utils/dbConnector.dart';

Future<List<DateTime>> getSelectDates(selectedDate) async {
  List<DateTime> dateList = [];

  // 선택한 날짜 전날의 오후 6시
  DateTime startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1, 18, 0, 0);

  // 선택한 날짜의 오후 6시
  DateTime endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 18, 0, 0);

  // String sql = '''
  //   SELECT *
  //   FROM mibandtotal
  //   WHERE start_time >= :start AND start_time < :end
  // ''';

  String sql = '''
  SELECT mtotal.start_time as instart mtotal.end_time as inend, intotal, minterval.*
  FROM mibandtotal mtotal
  JOIN mibandinterval minterval ON minterval.start_time >= mtotal.start_time AND minterval.end_time <= mtotal.end_time
  WHERE mtotal.start_time >= :start AND mtotal.end_time <= :end
  ''';

  var result = await dbConnector(sql, {
   'start' : startDate,
    'end' : endDate
  });

  if (result != null) {
    for (final row in result) {
      print((row.assoc()));
      // print("수면시작시간 : ${row.assoc()['start_time']},"
      //     " 수면종료시간 : ${row.assoc()['end_time']}");


    }
  }

  return dateList;
}