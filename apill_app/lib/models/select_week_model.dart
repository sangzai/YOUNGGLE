// To parse this JSON data, do
//
//     final selectWeekData = selectWeekDataFromJson(jsonString);

import 'dart:convert';

List<SelectWeekData> selectWeekDataFromJson(String str) => List<SelectWeekData>.from(json.decode(str).map((x) => SelectWeekData.fromJson(x)));

String selectWeekDataToJson(List<SelectWeekData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectWeekData {
  int sleepNum;
  int totalSleepTime;
  DateTime date;

  SelectWeekData({
    required this.sleepNum,
    required this.totalSleepTime,
    required this.date,
  });

  factory SelectWeekData.fromJson(Map<String, dynamic> json) => SelectWeekData(
    sleepNum: json["sleep_num"],
    totalSleepTime: json["total_sleep_time"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "sleep_num": sleepNum,
    "total_sleep_time": totalSleepTime,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
