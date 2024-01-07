import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/utils/db_connector.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/time_calculators.dart';

// DB 통신해서 데이터 받아오는 함수
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

  return selectDateDataList;
}

// 하루치 데이터를 sleep num으로 쪼개서 반화해주는 함수
Future<List<List<SelectDateData>>> splitDateData(List<SelectDateData> dataList) async {
  Map<int, List<SelectDateData>> categorizedMap = {};

  // 데이터를 순회하면서 SleepNum을 기준으로 그룹화합니다.
  for (var data in dataList) {
    if (!categorizedMap.containsKey(data.sleepNum)) {
      categorizedMap[data.sleepNum] = [];
    }
    categorizedMap[data.sleepNum]!.add(data);
  }

  // Map의 값들을 리스트로 변환합니다.
  List<List<SelectDateData>> categorizedList = categorizedMap.values.toList();

  return categorizedList;
}

// 파이차트 안에 수면시작 시간과 수면 끝 시간 구해주는 함수
String pieChartTimeRange(List<SelectDateData> dataList) {
  if (dataList.isEmpty) {
    // 리스트가 비어있을 경우 기본값 반환하거나 비어있는 경우 처리를 해주세요
    return '데이터 없음';
  }

  // 첫 번째 행의 startTime 추출
  String startTime = '${dataList.first.startTime.hour.toString().padLeft(2, '0')}:${dataList.first.startTime.minute.toString().padLeft(2, '0')}';

  // 마지막 행의 endTime 추출
  String endTime = '${dataList.last.endTime.hour.toString().padLeft(2, '0')}:${dataList.last.endTime.minute.toString().padLeft(2, '0')}';

  // 'hh:mm - hh:mm' 형식의 시간 범위 문자열 반환
  return '$startTime - $endTime';
}

// 파이차트 안에 들어갈 수면 시간
String pieChartTotalSleep(List<SelectDateData> sleepData) {
  if (sleepData.isEmpty) {
    // 리스트가 비어있을 경우 기본값 반환하거나 비어있는 경우 처리를 해주세요
    return "데이터 없음";
  }

  Duration dif = TimeCalculators().getTotalSleep(sleepData);

  // String formattedTime = '${dif.inHours.toString().padLeft(2, '0')}시간 ${dif.inMinutes % 60}분';
  String formattedTime = '${dif.inHours.toString()}시간 ${dif.inMinutes % 60}분';

  return formattedTime;

}

// 가장 수면시간이 긴 데이터의 인덱스 찾기
Future<int> findLongestSleep(List<List<SelectDateData>> splitSelectedDateData) async {
  int maxIndex = -1;
  Duration maxSleepDuration = Duration();

  for (int i = 0; i < splitSelectedDateData.length; i++) {
    List<SelectDateData> sleepData = splitSelectedDateData[i];
    Duration totalSleepDuration = TimeCalculators().getTotalSleep(sleepData);

    if (totalSleepDuration > maxSleepDuration) {
      maxSleepDuration = totalSleepDuration;
      maxIndex = i;
    }
  }

  return maxIndex;
}

String formattedDate(DateTime? date) {
  if (date == null) {
    return '';
  }

  // Format the date using intl package
  final dateFormat = DateFormat('MM/dd (E)','ko_KR');
  return dateFormat.format(date);
}

// sleepnum으로 쪼개진 데이터들을 sleepnum과 수면 시작시간 수면 종료시간을 묶은 뒤 24시간을 채워주는 함수
List<dynamic> getPieData(List<List<SelectDateData>> todayData, DateTime today) {
  List<dynamic> daySleep = [];
  List<dynamic> PieChartData = [];

  // todayData를 순회하면서 daySleep 리스트에 수면 데이터 추가
  for (var data in todayData) {
    daySleep.add([data.first.sleepNum, data.first.startTime, data.last.endTime]);
  }

  // 어제 6시와 오늘 6시를 나타내는 DateTime 객체 생성
  DateTime yesterday6PM = DateTime(today.year, today.month, today.day - 1, 18, 0);
  DateTime today6PM = DateTime(today.year, today.month, today.day, 18, 0);

  // print("get_select_date_datas의 getSplitDataSleepTime에서 출력중");
  // print("오늘 날짜 $today");
  // print("어제 오후 6시 :$yesterday6PM, 오늘 오후 6시 $today6PM");

  // 시간 간격을 확인하고 PieChartData에 항목 추가

  // 끝 시간을 어제 오후 6시로 초기화
  DateTime endTime = yesterday6PM;

  // daySleep의 행 하나를 가져온다
  for (var sleepEntry in daySleep) {

    // 시작시간을 행의 시작시간에서 가져온다
    DateTime startTime = sleepEntry[1];

    // 만약 어제 오후 6시가 시작시간 이전이라면
    // 전 행의 끝 시간이 이번 행의 시작시전 이전이라면
    if (endTime.isBefore(startTime)) {

      // 파이 차트에 sleepNum을 -1로 하여 어제 오후 6시 부터 행의 시작시간까지 추가
      PieChartData.add([-1, endTime, startTime]);
    }

    // 행을 추가
    PieChartData.add(sleepEntry);

    // endTime을 행의 끝시간으로 정한다
    endTime = sleepEntry[2];
  }

  // 마지막 행의 끝 시간이 오늘 오후 6시 이전이라면
  if (endTime.isBefore(today6PM)) {
    // 데이터를 추가한다
    PieChartData.add([-1, endTime, today6PM]);
  }

  if (PieChartData.last[2].isAfter(today6PM)) {
    PieChartData.last[2] = today6PM;
  }

  // 출력 및 반환
  // print(PieChartData);

  return PieChartData;
}

List<FlSpot> getLineData(List<SelectDateData> lineData) {
  List<FlSpot> spots = [];
  double SizeX = 0;

  if (lineData.isNotEmpty) {
    DateTime start = lineData[0].startTime;
    double preY = 0;
    SizeX = lineData.last.startTime.difference(start).inMinutes.toDouble();

    for (var i = 0; i < lineData.length; i++) {
      double x = (lineData[i].startTime.difference(start).inMinutes.toDouble() / SizeX * 23) +1 ;
      double y = lineData[i].sleepDepth.toDouble();

      if (i != 0) {
        spots.add(FlSpot(x, preY));
      }

      spots.add(FlSpot(x, y));
      preY = y;
    }
  }
  // print(spots.length.toDouble());
  // print(SizeX);
  print("겟 셀렉트 데이트 데이터스");
  print(spots);

  return spots;
}

List<String> getLineBottomTitle(List<SelectDateData> lineData){
  DateTime startTitleTime = lineData.first.startTime;
  DateTime endTitleTime = lineData.last.endTime;

  List<String> timeList = [];

  // 00:00 형식으로 시간을 포맷팅하여 리스트에 추가
  timeList.add(DateFormat.Hm().format(startTitleTime));
  timeList.add(DateFormat.Hm().format(endTitleTime));

  print(timeList);
  return timeList;
}