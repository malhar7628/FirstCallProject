import 'dart:convert';

UserInfoDocumentData userInfoDocumentDataFromJson(String str) =>
    UserInfoDocumentData.fromJson(json.decode(str));

String userInfoDocumentDataToJson(UserInfoDocumentData data) => json.encode(data.toJson());

class UserInfoDocumentData {
  UserInfoDocumentData({
    this.id,
    this.cv,
    this.image1,
    this.image2,
  });

  String? id;
  String? cv;
  String? image1;
  String? image2;

  factory UserInfoDocumentData.fromJson(Map<String, dynamic> json) => UserInfoDocumentData(
    id: json["id"],
    cv: json["cv"],
    image1: json["image1"],
    image2: json["image2"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cv":cv,
    "image1": image1,
    "image2": image2,
  };

}
