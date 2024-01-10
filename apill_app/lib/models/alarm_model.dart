// To parse this JSON data, do
//
//     final alarmModel = alarmModelFromJson(jsonString);

import 'dart:convert';

List<AlarmModel> alarmModelFromJson(String str) => List<AlarmModel>.from(json.decode(str).map((x) => AlarmModel.fromJson(x)));

String alarmModelToJson(List<AlarmModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlarmModel {
  int id;
  String time;
  int isOn;
  int isSelected;

  AlarmModel({
    required this.id,
    required this.time,
    required this.isOn,
    required this.isSelected,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
    id: json["id"],
    time: json["time"],
    isOn: json["isOn"],
    isSelected: json["isSelected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "isOn": isOn,
    "isSelected": isSelected,
  };
}
