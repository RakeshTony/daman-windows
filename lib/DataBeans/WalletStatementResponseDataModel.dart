import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class WalletStatementResponseDataModel extends BaseDataModel {
  List<WalletStatementDataModel> statements = [];

  @override
  WalletStatementResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.statements = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => WalletStatementDataModel.fromJson(e))
        .toList();
    return this;
  }
}

class WalletStatementDataModel {
  String operator;
  String operatorLogo;
  String orderNumber;
  String orderQuantity;
  String user;
  String transaction;
  String type;
  String consider;
  double amount;
  double openBal;
  double closeBal;
  String created;
  String narration;

  WalletStatementDataModel({
    this.operator = "",
    this.operatorLogo = "",
    this.orderNumber = "",
    this.orderQuantity = "",
    this.user = "",
    this.transaction = "",
    this.type = "",
    this.consider = "",
    this.amount = 0.0,
    this.openBal = 0.0,
    this.closeBal = 0.0,
    this.created = "",
    this.narration = "",
  });

  factory WalletStatementDataModel.fromJson(Map<String, dynamic> json) {
    return WalletStatementDataModel(
      operator: toString(json["OPERATOR"]),
      operatorLogo: toString(json["OPERATOR_LOGO"]),
      orderNumber: toString(json["ORDER_NUMBER"]),
      orderQuantity: toString(json["ORDER_QUANTITY"]),
      user: toString(json["USER"]),
      transaction: toString(json["TRANSACTION"]),
      type: toString(json["TYPE"]),
      consider: toString(json["CONSIDER"]),
      amount: toDouble(json["AMOUNT"]),
      openBal: toDouble(json["OPENBAL"]),
      closeBal: toDouble(json["CLOSEBAL"]),
      narration: toString(json["NARRATION"]),
      created: toString(json["CREATED"]),
    );
  }
}
