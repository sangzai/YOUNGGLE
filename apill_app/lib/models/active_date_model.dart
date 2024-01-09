// To parse this JSON data, do
//
//     final activeDateModel = activeDateModelFromJson(jsonString);

import 'dart:convert';

List<ActiveDateModel> activeDateModelFromJson(String str) => List<ActiveDateModel>.from(json.decode(str).map((x) => ActiveDateModel.fromJson(x)));

String activeDateModelToJson(List<ActiveDateModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActiveDateModel {
  DateTime date;

  ActiveDateModel({
    required this.date,
  });

  factory ActiveDateModel.fromJson(Map<String, dynamic> json) => ActiveDateModel(
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
