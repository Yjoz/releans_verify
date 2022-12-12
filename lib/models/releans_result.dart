import 'dart:convert';
import 'dart:developer';

ReleansResult releansResultFromJson(String str) =>
    ReleansResult.fromJson(json.decode(str));

String releansResultToJson(ReleansResult data) => json.encode(data.toJson());

class ReleansResult {
  ReleansResult({
    this.name,
    this.message,
    this.code,
    this.status,
  });

  String? name;
  String? message;
  int? code;
  int? status;

  factory ReleansResult.fromJson(Map<String, dynamic> json) => ReleansResult(
        name: json["name"] == null ? null : json["name"],
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
      };

  //check request status code is in success range
  bool isSuccess() {
    if (status != null) {
      if (status! >= 200 && status! <= 300) {
        log("status is in success range");
        return true;
      }
    }
    return false;
  }
}
