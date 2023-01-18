import 'dart:convert';

import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class CommissionResponseDataModel extends BaseDataModel {
  List<CommissionOperatorData> operators = [];

  @override
  CommissionResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this.operators =
        list.map((e) => CommissionOperatorData.fromJson(e)).toList();
    return this;
  }
}

class CommissionOperatorData {
  String displayOrder;
  String operatorTitle;
  String operatorLogo;
  String pinDiscountType;
  String pinCommissionType;
  int pinCommission;
  List<CommissionDenominationData> denominations;

  CommissionOperatorData({
    this.displayOrder = "",
    this.operatorTitle = "",
    this.operatorLogo = "",
    this.pinDiscountType = "",
    this.pinCommissionType = "",
    this.pinCommission = 0,
    this.denominations = const [],
  });

  factory CommissionOperatorData.fromJson(Map<String, dynamic> json) {
    return CommissionOperatorData(
      displayOrder: toString(json["display_order"]),
      operatorTitle: toString(json["operator_title"]),
      operatorLogo: toString(json["operator_logo"]),
      pinDiscountType: toString(json["pin_discount_type"]),
      pinCommissionType: toString(json["pin_commission_type"]),
      pinCommission: toInt(json["pin_commission"]),
      denominations: toList(json["Denomination"])
          .map((e) => CommissionDenominationData.fromJson(e))
          .toList(),
    );
  }
}

class CommissionDenominationData {
  String id;
  String operatorId;
  String title;
  String denomination;
  double sellingPrice;
  double customerSellingPrice;
  String type;
  String commission;

  CommissionDenominationData({
    this.id = "",
    this.operatorId = "",
    this.title = "",
    this.denomination = "",
    this.sellingPrice = 0.0,
    this.customerSellingPrice = 0.0,
    this.type = "",
    this.commission = "",
  });

  factory CommissionDenominationData.fromJson(Map<String, dynamic> json) {
    return CommissionDenominationData(
      id: toString(json["id"]),
      operatorId: toString(json["operator_id"]),
      title: toString(json["title"]),
      denomination: toString(json["denomination"]),
      sellingPrice: toDouble(json["selling_price"]),
      customerSellingPrice: toDouble(json["customer_selling_price"]),
      type: toString(json["type"]),
      commission: toString(json["commission"]),
    );
  }
}
