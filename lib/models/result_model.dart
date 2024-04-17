class Result {
  final bool isSuccess;
  final String code;
  final String message;
  final Map<String, dynamic> result;
  Result.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        isSuccess = json["isSuccess"],
        message = json["message"],
        result = json["result"];
}
