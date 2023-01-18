import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class DistrictDataModel extends BaseDataModel {
  List<DistrictData> data = [];
  
  @override
  DistrictDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => DistrictData.fromJson(e)).toList();
    return this;
  }
}

class DistrictData {
  String id;
  String title;

  DistrictData({
    this.id = "",
    this.title = "",
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) {
    return DistrictData(
      id: toString(json["id"]),
      title: toString(json["title"]),
    );
  }
}
