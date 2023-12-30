import 'package:mainproject_apill/utils/dbConnector.dart';

Future<List<DateTime>> getSelectDates(selectedDate) async {
  List<DateTime> dateList = [];

  // 선택한 날짜 전날의 오후 6시
  DateTime startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1, 18, 0, 0);

  // 선택한 날짜의 오후 6시
  DateTime endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 18, 0, 0);

  String loginsql = '''
    SELECT *
    FROM mibandtotal
    WHERE start_time >= :start AND start_time < :end
  ''';

  var result = await dbConnector(loginsql, {
   'start' : startDate,
    'end' : endDate
  });

  if (result != null) {
    for (final row in result) {
      // 여기에서 dateList에 값을 추가하거나 원하는 처리를 수행하세요.
      // 예시: dateList.add(row['start_time']);
      print(row.assoc());
    }
  }

  return dateList;
}