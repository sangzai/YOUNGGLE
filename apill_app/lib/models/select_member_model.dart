// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

List<MemberModel> memberModelFromJson(String str) => List<MemberModel>.from(json.decode(str).map((x) => MemberModel.fromJson(x)));

String memberModelToJson(List<MemberModel> data) => jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));

class MemberModel {
  String memberId;
  DateTime memberJoindate;
  String memberPw;
  String memberName;
  DateTime memberBirth;
  int memberWeight;
  int memberHeight;
  String memberGender;
  int memberAge;

  MemberModel({
    required this.memberId,
    required this.memberJoindate,
    required this.memberPw,
    required this.memberName,
    required this.memberBirth,
    required this.memberWeight,
    required this.memberHeight,
    required this.memberGender,
    required this.memberAge,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
    memberId: json["member_id"],
    memberJoindate: DateTime.parse(json["member_joindate"]),
    memberPw: json["member_pw"],
    memberName: json["member_name"],
    memberBirth: DateTime.parse(json["member_birth"]),
    memberWeight: json["member_weight"],
    memberHeight: json["member_height"],
    memberGender: json["member_gender"],
    memberAge: json["member_age"],
  );

  Map<String, dynamic> toJson() => {
    "member_id": memberId,
    "member_joindate": memberJoindate.toIso8601String(),
    "member_pw": memberPw,
    "member_name": memberName,
    "member_birth": "${memberBirth.year.toString().padLeft(4, '0')}-${memberBirth.month.toString().padLeft(2, '0')}-${memberBirth.day.toString().padLeft(2, '0')}",
    "member_weight": memberWeight,
    "member_height": memberHeight,
    "member_gender": memberGender,
    "member_age": memberAge,
  };
}
