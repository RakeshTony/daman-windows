import 'package:daman/Utils/app_extensions.dart';

class RemitaCustomFieldModel {
  String id;
  String columnName;
  String columnType;
  int columnLength;
  bool required;
  int dataLoadRuleId;
  String activeStatus;
  List<RemitaCustomFieldOptionModel> customFieldDropDown;

  RemitaCustomFieldModel({
    this.id = "",
    this.columnName = "",
    this.columnType = "",
    this.columnLength = 0,
    this.required = false,
    this.dataLoadRuleId = 0,
    this.activeStatus = "",
    this.customFieldDropDown = const [],
  });

  factory RemitaCustomFieldModel.fromJson(Map<dynamic, dynamic> json) {
    return RemitaCustomFieldModel(
      id: toString(json["id"]),
      columnName: toString(json["columnName"]),
      columnType: toString(json["columnType"]),
      columnLength: toInt(json["columnLength"]),
      required: toBoolean(json["required"]),
      dataLoadRuleId: toInt(json["dataLoadRuleId"]),
      activeStatus: toString(json["activeStatus"]),
      customFieldDropDown: toList(json["customFieldDropDown"])
          .map((e) => RemitaCustomFieldOptionModel.fromJson(e))
          .toList(),
    );
  }
}

class RemitaCustomFieldOptionModel {
  String id;
  String description;
  String itemPhoto;
  String itemName;
  bool fixedPrice;
  int unitPrice;
  String code;
  String accountId;

  RemitaCustomFieldOptionModel({
    this.id = "",
    this.description = "",
    this.itemPhoto = "",
    this.itemName = "",
    this.fixedPrice = false,
    this.unitPrice = 0,
    this.code = "",
    this.accountId = "",
  });

  factory RemitaCustomFieldOptionModel.fromJson(Map<dynamic, dynamic> json) {
    return RemitaCustomFieldOptionModel(
      id: toString(json["id"]),
      description: toString(json["description"]),
      itemPhoto: toString(json["itemphoto"]),
      itemName: toString(json["itemname"]),
      fixedPrice: toBoolean(json["fixedprice"]),
      unitPrice: toInt(json["unitprice"]),
      code: toString(json["code"]),
      accountId: toString(json["accountid"]),
    );
  }
}
