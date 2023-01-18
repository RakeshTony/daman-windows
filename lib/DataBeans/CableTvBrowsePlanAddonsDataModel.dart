import 'dart:collection';
import 'dart:convert';

import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class CableTvBrowsePlanAddonsDataModel extends BaseDataModel {
  List<BrowsePlanAddonData> addons = [];

  @override
  CableTvBrowsePlanAddonsDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.addons = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => BrowsePlanAddonData.fromJson(e))
        .toList();
    return this;
  }
}

class BrowsePlanAddonData {
  String name;
  String code;
  String month;
  double price;
  String period;

  BrowsePlanAddonData({
    this.name = "",
    this.code = "",
    this.month = "",
    this.price = 0.0,
    this.period = "",
  });

  factory BrowsePlanAddonData.fromJson(Map<String, dynamic> json) {
    return BrowsePlanAddonData(
      name: toString(json['name']),
      code: toString(json['code']),
      month: toString(json['month']),
      price: toDouble(json['price']),
      period: toString(json['period']),
    );
  }

  String toJson() {
    var data = HashMap();
    data["name"] = name;
    data["code"] = code;
    data["month"] = month;
    data["price"] = price;
    data["period"] = period;
    return jsonEncode(data);
  }
  HashMap<String,dynamic> toHashMap() {
    HashMap<String,dynamic> data = HashMap();
    data["name"] = name;
    data["code"] = code;
    data["month"] = month;
    data["price"] = price;
    data["period"] = period;
    return data;
  }

}
