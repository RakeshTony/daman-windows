import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/currencies.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class CurrencyDataModel extends BaseDataModel {
  List<CurrencyData> currencies = [];

  @override
  CurrencyDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this.currencies = list.map((e) => CurrencyData.fromJson(e)).toList();
    return this;
  }
}

class CurrencyData {
  String id;
  String code;
  String name;
  String sign;
  String position;
  double buyingRate;
  double sellingRate;
  bool defaultStatus;
  bool status;
  String created;
  String modified;

  CurrencyData({
    this.id = "",
    this.code = "",
    this.name = "",
    this.sign = "",
    this.position = "",
    this.buyingRate = 0.0,
    this.sellingRate = 0.0,
    this.defaultStatus = false,
    this.status = false,
    this.created = "",
    this.modified = "",
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      id: toString(json["id"]),
      code: toString(json["code"]),
      name: toString(json["name"]),
      sign: toString(json["sign"]),
      position: toString(json["position"]),
      buyingRate: toDouble(json["buying_rate"]),
      sellingRate: toDouble(json["selling_rate"]),
      defaultStatus: toBoolean(json["default_status"]),
      status: toBoolean(json["status"]),
      created: toString(json["created"]),
      modified: toString(json["modified"]),
    );
  }
}

extension CurrencyDataExtension on CurrencyData {
  Currency get toCurrency => Currency()
    ..id = this.id
    ..code = this.code
    ..name = this.name
    ..sign = this.sign
    ..position = this.position
    ..buyingRate = this.buyingRate
    ..sellingRate = this.sellingRate
    ..defaultStatus = this.defaultStatus
    ..status = this.status
    ..created = this.created
    ..modified = this.modified;
}
