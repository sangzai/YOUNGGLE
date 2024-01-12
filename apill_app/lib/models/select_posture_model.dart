// To parse this JSON data, do
//
//     final selectPostureModel = selectPostureModelFromJson(jsonString);

import 'dart:convert';

List<SelectPostureModel> selectPostureModelFromJson(String str) => List<SelectPostureModel>.from(json.decode(str).map((x) => SelectPostureModel.fromJson(x)));

String selectPostureModelToJson(List<SelectPostureModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectPostureModel {
  String posture;
  int minutes;

  SelectPostureModel({
    required this.posture,
    required this.minutes,
  });

  factory SelectPostureModel.fromJson(Map<String, dynamic> json) => SelectPostureModel(
    posture: json["posture"],
    minutes: json["minutes"],
  );

  Map<String, dynamic> toJson() => {
    "posture": posture,
    "minutes": minutes,
  };
}
