// To parse this JSON data, do
//
//     final selectDateData = selectDateDataFromJson(jsonString);

import 'dart:convert';

List<SelectDateData> selectDateDataFromJson(String str) => List<SelectDateData>.from(json.decode(str).map((x) => SelectDateData.fromJson(x)));

String selectDateDataToJson(List<SelectDateData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectDateData {
  int sequenceNumber;
  int sleepNum;
  DateTime startTime;
  DateTime endTime;
  int sleepDepth;

  SelectDateData({
    required this.sequenceNumber,
    required this.sleepNum,
    required this.startTime,
    required this.endTime,
    required this.sleepDepth,
  });

  factory SelectDateData.fromJson(Map<String, dynamic> json) => SelectDateData(
    sequenceNumber: json["sequence_number"],
    sleepNum: json["sleep_num"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    sleepDepth: json["sleep_depth"],
  );

  Map<String, dynamic> toJson() => {
    "sequence_number": sequenceNumber,
    "sleep_num": sleepNum,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "sleep_depth": sleepDepth,
  };
}
