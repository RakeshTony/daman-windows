abstract class BaseDataModel {
  String? message;
  bool? status;
  int? statusCode;
  int get getStatusCode => statusCode ?? 0;
  bool get getStatus => status ?? false;
  String get getMessage => message ?? "";
  BaseDataModel parseData(Map<String,dynamic> result);
}
