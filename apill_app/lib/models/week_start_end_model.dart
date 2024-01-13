// To parse this JSON data, do
//
//     final weekStartEndData = weekStartEndDataFromJson(jsonString);

import 'dart:convert';

List<WeekStartEndModel> weekStartEndDataFromJson(String str) => List<WeekStartEndModel>.from(json.decode(str).map((x) => WeekStartEndModel.fromJson(x)));

String weekStartEndDataToJson(List<WeekStartEndModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeekStartEndModel {
  DateTime startTime;
  DateTime endTime;
  DateTime date;

  WeekStartEndModel({
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  factory WeekStartEndModel.fromJson(Map<String, dynamic> json) => WeekStartEndModel(
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
