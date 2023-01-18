import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class UserRanksPlansModel extends BaseDataModel {
  List<PlansData> data = [];

  @override
  UserRanksPlansModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => PlansData.fromJson(e)).toList();
    return this;
  }
}

class PlansData {
  String id;
  String name;

  PlansData({
    this.id = "",
    this.name = "",
  });

  factory PlansData.fromJson(Map<String, dynamic> json) {
    return PlansData(
      id: toString(json["id"]),
      name: toString(json["name"]),
    );
  }
}
