
import 'dart:convert';

CvwithaudtionId cvwithaudtionIdFromJson(String str) => CvwithaudtionId.fromJson(json.decode(str));

String cvwithaudtionIdToJson(CvwithaudtionId data) => json.encode(data.toJson());

class CvwithaudtionId {
  CvwithaudtionId({
    required this.id,
    required this.cvname,
  });

  String id;
  String cvname;

  factory CvwithaudtionId.fromJson(Map<String, dynamic> json) => CvwithaudtionId(
    id: json["id"],
    cvname: json["cvname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cvname": cvname,
  };
}
