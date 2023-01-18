import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class CableTvBrowsePlanDataModel extends BaseDataModel {
  late CableTvBrowsePlanData data;

  @override
  CableTvBrowsePlanDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = CableTvBrowsePlanData.fromJson(
        toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class CableTvBrowsePlanData {
  String customerName;
  String type;
  String smartCardNo;
  String message;
  List<BrowsePlanData> plans;

  CableTvBrowsePlanData({
    this.smartCardNo = "",
    this.type = "",
    this.customerName = "",
    this.message = "",
    required this.plans,
  });

  factory CableTvBrowsePlanData.fromJson(Map<String, dynamic> json) {
    return CableTvBrowsePlanData(
      smartCardNo: toString(json['smartCardNo']),
      customerName: toString(json['customerName']),
      message: toString(json['message']),
      type: toString(json['type']),
      plans: toList(json["product"])
          .map((e) => BrowsePlanData.fromJson(e))
          .toList(),
    );
  }
}

class BrowsePlanData {
  String name;
  String code;
  String month;
  double price;
  String period;

  BrowsePlanData({
    this.name = "",
    this.code = "",
    this.month = "",
    this.price = 0.0,
    this.period = "",
  });

  factory BrowsePlanData.fromJson(Map<String, dynamic> json) {
    return BrowsePlanData(
      name: toString(json['name']),
      code: toString(json['code']),
      month: toString(json['month']),
      price: toDouble(json['price']),
      period: toString(json['period']),
    );
  }
}