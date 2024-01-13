// To parse this JSON data, do
//
//     final weekMonthPostureModel = weekMonthPostureModelFromJson(jsonString);

import 'dart:convert';

List<WeekMonthPostureModel> weekMonthPostureModelFromJson(String str) => List<WeekMonthPostureModel>.from(json.decode(str).map((x) => WeekMonthPostureModel.fromJson(x)));


class WeekMonthPostureModel {
  String postureType;
  DateTime date;
  int totalSleepTime; // totalSleepTime을 int로 변경

  WeekMonthPostureModel({
    required this.postureType,
    required this.date,
    required this.totalSleepTime,
  });

  factory WeekMonthPostureModel.fromJson(Map<String, dynamic> json) => WeekMonthPostureModel(
    postureType: json["posture_type"],
    date: DateTime.parse(json["date"]),
    totalSleepTime: int.parse(json["total_sleep_time"]), // int로 파싱
  );

  Map<String, dynamic> toJson() => {
    "posture_type": postureType,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "total_sleep_time": totalSleepTime.toString(), // int를 문자열로 변환
  };
}
