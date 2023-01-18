import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class AutoDetectOperatorDataModel extends BaseDataModel {
  AutoDetectOperator? operator;

  @override
  AutoDetectOperatorDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    if (getStatus && result.containsKey(AppRequestKey.RESPONSE_DATA)) {
      var data = result[AppRequestKey.RESPONSE_DATA];
      this.operator = AutoDetectOperator.fromJson(data);
    }
    return this;
  }
}

class AutoDetectOperator {
  String operatorId;
  String circleCode;
  AutoDetectOperator({this.operatorId = "", this.circleCode = ""});
  factory AutoDetectOperator.fromJson(Map<String, dynamic> json) {
    return AutoDetectOperator(
      operatorId: toString(json['operator_id']),
      circleCode: toString(json['circle_code']),
    );
  }
}
