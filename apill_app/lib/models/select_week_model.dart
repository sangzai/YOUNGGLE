// To parse this JSON data, do
//
//     final selectWeekData = selectWeekDataFromJson(jsonString);

import 'dart:convert';

List<SelectWeekSleepModel> selectWeekDataFromJson(String str) => List<SelectWeekSleepModel>.from(json.decode(str).map((x) => SelectWeekSleepModel.fromJson(x)));

String selectWeekDataToJson(List<SelectWeekSleepModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectWeekSleepModel {
  int sleepNum;
  int totalSleepTime;
  DateTime date;

  SelectWeekSleepModel({
    required this.sleepNum,
    required this.totalSleepTime,
    required this.date,
  });

  factory SelectWeekSleepModel.fromJson(Map<String, dynamic> json) => SelectWeekSleepModel(
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
