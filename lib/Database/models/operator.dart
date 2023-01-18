import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';

part 'operator.g.dart';

@HiveType(typeId: 5)
class Operator {
  @HiveField(0)
  late String serviceId;
  @HiveField(1)
  late String id;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late String code;
  @HiveField(4)
  late String logo;
  @HiveField(5)
  late String banner;
  @HiveField(6)
  late String bmp;
  @HiveField(7)
  late double minRechargeAmount;
  @HiveField(8)
  late double maxRechargeAmount;
  @HiveField(9)
  late int minLength;
  @HiveField(10)
  late int maxLength;
  @HiveField(11)
  late bool isDenomination;
  @HiveField(12)
  late String topUpFormat;
  @HiveField(13)
  late String rType;
  @HiveField(14)
  late String opType;
  @HiveField(15)
  late String topUp;
  @HiveField(16)
  late String pin;
  @HiveField(17)
  late String inst;
  @HiveField(18)
  late int dmCount;
  @HiveField(19)
  late int isFav;
  @HiveField(20)
  late String countryId;
  @HiveField(21)
  late String currencyId;

  @override
  String toString() {
    var data = {};
    data["countryid"] = countryId;
    data["operatorid"] = id;
    data["service_id"] = serviceId;
    return jsonEncode(data);
  }

  Operator({
    this.id = "",
    this.serviceId = "",
    this.name = "",
    this.code = "",
    this.logo = "",
    this.banner = "",
    this.bmp = "",
    this.minRechargeAmount = 0.0,
    this.maxRechargeAmount = 0.0,
    this.minLength = 0,
    this.maxLength = 0,
    this.isDenomination = false,
    this.topUpFormat = "",
    this.rType = "",
    this.opType = "",
    this.topUp = "",
    this.pin = "",
    this.inst = "",
    this.dmCount = 0,
    this.isFav = 0,
    this.countryId = "",
    this.currencyId = "",
  });
}

extension OperatorExtension on Operator {
  OperatorData get toOperatorData => OperatorData()
    ..serviceId = this.serviceId
    ..id = this.id
    ..name = this.name
    ..code = this.code
    ..logo = this.logo
    ..banner = this.banner
    ..bmp = this.bmp
    ..minRechargeAmount = this.minRechargeAmount
    ..maxRechargeAmount = this.maxRechargeAmount
    ..minLength = this.minLength
    ..maxLength = this.maxLength
    ..isDenomination = this.isDenomination
    ..topUpFormat = this.topUpFormat
    ..rType = this.rType
    ..opType = this.opType
    ..topUp = this.topUp
    ..pin = this.pin
    ..inst = this.inst
    ..dmCount = this.dmCount
    ..isFav = this.isFav
    ..countryId = this.countryId
    ..currencyId = this.currencyId;
}
