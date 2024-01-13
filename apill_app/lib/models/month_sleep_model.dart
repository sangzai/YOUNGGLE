// To parse this JSON data, do
//
//     final monthSleepModel = monthSleepModelFromJson(jsonString);

import 'dart:convert';

List<MonthSleepModel> monthSleepModelFromJson(String str) => List<MonthSleepModel>.from(json.decode(str).map((x) => MonthSleepModel.fromJson(x)));

String monthSleepModelToJson(List<MonthSleepModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MonthSleepModel {
  DateTime startTime;
  DateTime endTime;
  DateTime date;

  MonthSleepModel({
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  factory MonthSleepModel.fromJson(Map<String, dynamic> json) => MonthSleepModel(
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
