import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class StateDataModel extends BaseDataModel {
  List<StateData> data = [];
  
  @override
  StateDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => StateData.fromJson(e)).toList();
    return this;
  }
}

class StateData {
  String id;
  String title;

  StateData({
    this.id = "",
    this.title = "",
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: toString(json["id"]),
      title: toString(json["title"]),
    );
  }
}
