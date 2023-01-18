import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';

part 'currencies.g.dart';

@HiveType(typeId: 2)
class Currency extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String code;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late String sign;
  @HiveField(4)
  late String position;
  @HiveField(5)
  late double buyingRate;
  @HiveField(6)
  late double sellingRate;
  @HiveField(7)
  late bool defaultStatus;
  @HiveField(8)
  late bool status;
  @HiveField(9)
  late String created;
  @HiveField(10)
  late String modified;
  @override
  String toString() {
    var data = {};
    data["id"] = id;
    data["sign"] = sign;
    return jsonEncode(data);
  }
}

extension CurrencyExtension on Currency {
  CurrencyData get toCurrencyData => CurrencyData()
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
