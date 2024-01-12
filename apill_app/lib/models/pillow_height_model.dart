// To parse this JSON data, do
//
//     final pillowHeight = pillowHeightFromJson(jsonString);

import 'dart:convert';

PillowHeight pillowHeightFromJson(String str) => PillowHeight.fromJson(json.decode(str));

String pillowHeightToJson(PillowHeight data) => json.encode(data.toJson());

class PillowHeight {
  String nowposture;
  int nowlevel;
  int dplevel;
  int cplevel;

  PillowHeight({
    required this.nowposture,
    required this.nowlevel,
    required this.dplevel,
    required this.cplevel,
  });

  factory PillowHeight.fromJson(Map<String, dynamic> json) => PillowHeight(
    nowposture: json["nowposture"],
    nowlevel: json["nowlevel"],
    dplevel: json["dplevel"],
    cplevel: json["cplevel"],
  );

  Map<String, dynamic> toJson() => {
    "nowposture": nowposture,
    "nowlevel": nowlevel,
    "dplevel": dplevel,
    "cplevel": cplevel,
  };
}
