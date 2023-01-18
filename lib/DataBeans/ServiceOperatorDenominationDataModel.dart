import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/denomination.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/service.dart';

import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class ServiceOperatorDenominationDataModel extends BaseDataModel {
  List<ServiceOperatorModel> _data = [];

  @override
  ServiceOperatorDenominationDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this._data = list.map((e) => ServiceOperatorModel.fromJson(e)).toList();
    return this;
  }

  List<ServiceData> getServices() {
    return _data.map((e) => e.service).toList();
  }

  List<OperatorData> getOperators() {
    List<OperatorData> operators = [];
    _data.forEach((element) {
      operators.addAll(element.operator);
    });
    return operators;
  }

  List<DenominationData> getDenominations() {
    List<DenominationData> denominations = [];
    _data.forEach((element) {
      element.operator.forEach((element) {
        denominations.addAll(element.denominations);
      });
    });
    return denominations;
  }
}

class ServiceOperatorModel {
  ServiceData service;
  List<OperatorData> operator;

  ServiceOperatorModel({required this.service, required this.operator});

  factory ServiceOperatorModel.fromJson(Map<dynamic, dynamic> json) {
    var service = ServiceData.fromJson(json['Service']);
    return ServiceOperatorModel(
      service: ServiceData.fromJson(json['Service']),
      operator: toList(json['Operator'])
          .map((e) => OperatorData.fromJson(e, service.id))
          .toList(),
    );
  }
}

class ServiceData {
  String id;
  String title;
  String type;
  bool comingSoon;
  String slug;
  String icon;

  ServiceData({
    this.id = "",
    this.title = "",
    this.slug = "",
    this.type = "",
    this.comingSoon = false,
    this.icon = "",
  });

  factory ServiceData.fromJson(Map<dynamic, dynamic> json) {
    return ServiceData(
      id: toString(json["id"]),
      title: toString(json["title"]),
      slug: toString(json["slug"]),
      type: toString(json["type"]),
      comingSoon: toBoolean(json["coming_soon"]),
      icon: toString(json["icon"]),
    );
  }
}

extension ServiceDataExtension on ServiceData {
  Service get toService => Service()
    ..id = this.id
    ..title = this.title
    ..slug = this.slug
    ..type = this.type
    ..comingSoon = this.comingSoon
    ..icon = this.icon;
}

class OperatorData {
  String serviceId;
  String id;
  String name;
  String code;
  String logo;
  String banner;
  String bmp;
  double minRechargeAmount;
  double maxRechargeAmount;
  int minLength;
  int maxLength;
  bool isDenomination;
  String topUpFormat;
  String rType;
  String opType;
  String topUp;
  String pin;
  String inst;
  int dmCount;
  int isFav;
  String countryId;
  String currencyId;
  List<DenominationData> denominations;

  OperatorData({
    this.serviceId = "",
    this.id = "",
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
    this.denominations = const [],
  });

  factory OperatorData.fromJson(Map<dynamic, dynamic> json, String serviceId) {
    return OperatorData(
      serviceId: serviceId,
      id: toString(json["OPWEBID"]),
      name: toString(json["OPNAME"]),
      code: toString(json["OPCODE"]),
      logo: toString(json["LOGO"]),
      banner: toString(json["BANNER"]),
      bmp: toString(json["BMP"]),
      minRechargeAmount: toDouble(json["MIN_RECHARGE_AMOUNT"]),
      maxRechargeAmount: toDouble(json["MAX_RECHARGE_AMOUNT"]),
      minLength: toInt(json["MIN_LENGTH"]),
      maxLength: toInt(json["MAX_LENGTH"]),
      isDenomination: toBoolean(json["IS_DENOMINATION"]),
      topUpFormat: toString(json["TOPUP_FORMAT"]),
      rType: toString(json["RTYPE"]),
      opType: toString(json["OPTYPE"]),
      topUp: toString(json["TOPUP"]),
      pin: toString(json["PIN"]),
      inst: toString(json["INST"]),
      dmCount: toInt(json["DMCOUNT"]),
      isFav: toInt(json["IS_FAV"]),
      countryId: toString(json["COUNTRY_ID"]),
      currencyId: toString(json["CURRENCY_ID"]),
      denominations: toList(json["Denomination"])
          .map((e) => DenominationData.fromJson(
              e, serviceId, toString(json["OPWEBID"])))
          .toList(),
    );
  }
}

extension OperatorDataExtension on OperatorData {
  Operator get toOperator => Operator()
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

class DenominationData {
  String id;
  String serviceId;
  String operatorId;
  String title;
  bool type;
  double denomination;
  String denominationSign;
  double sellingPrice;
  String logo;
  String printFormat;
  String categoryId;
  String categoryTitle;
  String categoryIcon;
  String currencyId;
  String currencySign;
  double conversionPrice;

  DenominationData({
    this.id = "",
    this.serviceId = "",
    this.operatorId = "",
    this.title = "",
    this.type = false,
    this.denomination = 0.0,
    this.denominationSign = "",
    this.sellingPrice = 0.0,
    this.logo = "",
    this.printFormat = "",
    this.categoryId = "",
    this.categoryTitle = "",
    this.categoryIcon = "",
    this.currencyId = "",
    this.currencySign = "",
    this.conversionPrice = 0.0,
  });

  factory DenominationData.fromJson(
      Map<dynamic, dynamic> json, String serviceId, String operatorId) {
    return DenominationData(
      serviceId: serviceId,
      operatorId: operatorId,
      id: toString(json["denomination_id"]),
      title: toString(json["denomination_title"]),
      type: toBoolean(json["type"]),
      denomination: toDouble(json["denomination"]),
      denominationSign: toString(json["Denomination"]),
      sellingPrice: toDouble(json["selling_price"]),
      logo: toString(json["logo"]),
      printFormat: toString(json["print_format"]),
      categoryId: toString(json["denomination_category_id"]),
      categoryTitle: toString(json["denomination_category_title"]),
      categoryIcon: toString(json["denomination_category_title"]),
      currencyId: toString(json["currency_id"]),
      currencySign: toString(json["currency_sign"]),
      conversionPrice: toDouble(json["conversion_price"]),
    );
  }
}

extension DenominationDataExtension on DenominationData {
  Denomination get toDenomination => Denomination()
    ..serviceId = this.serviceId
    ..operatorId = this.operatorId
    ..id = this.id
    ..title = this.title
    ..type = this.type
    ..denomination = this.denomination
    ..denominationSign = this.denominationSign
    ..sellingPrice = this.sellingPrice
    ..logo = this.logo
    ..printFormat = this.printFormat
    ..categoryId = this.categoryId
    ..categoryTitle = this.categoryTitle
    ..categoryIcon = this.categoryIcon
    ..currencyId = this.currencyId
    ..currencySign = this.currencySign
    ..conversionPrice = this.conversionPrice;
}
