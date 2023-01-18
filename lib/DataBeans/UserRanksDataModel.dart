import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class UserRanksModel extends BaseDataModel {
  List<RanksData> data = [];
  
  @override
  UserRanksModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => RanksData.fromJson(e)).toList();
    return this;
  }
}

class RanksData {
  String id;
  String name;

  RanksData({
    this.id = "",
    this.name = "",
  });

  factory RanksData.fromJson(Map<String, dynamic> json) {
    return RanksData(
      id: toString(json["id"]),
      name: toString(json["name"]),
    );
  }
}
