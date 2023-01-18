import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class RecentTransactionDataModel extends BaseDataModel {
  late List<RecentTransactionModel> transactions;

  @override
  RecentTransactionDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    transactions = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => RecentTransactionModel.fromJson(e))
        .toList();
    return this;
  }
}

class RecentTransactionModel {
  String loginId;
  String reloadNo;
  String operator;
  String operatorLogo;
  String mainType;
  String amount;
  String userDeliverableAmount;
  String status;
  String dtTxnId;
  String operatorTxnId;
  String updatedTime;
  String insertedTime;

  RecentTransactionModel({
    this.loginId = "",
    this.reloadNo = "",
    this.operator = "",
    this.operatorLogo = "",
    this.mainType = "",
    this.amount = "",
    this.userDeliverableAmount = "",
    this.status = "",
    this.dtTxnId = "",
    this.operatorTxnId = "",
    this.updatedTime = "",
    this.insertedTime = "",
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      loginId: toString(json['LOGINID']),
      reloadNo: toString(json['RELOADNO']),
      operator: toString(json['OPERATOR']),
      operatorLogo: toString(json['OPERATORLOGO']),
      mainType: toString(json['MAINTYPE']),
      amount: toString(json['AMOUNT']),
      userDeliverableAmount: toString(json['USERDELIVERABLEAMOUNT']),
      status: toString(json['STATUS']),
      dtTxnId: toString(json['DTTXNID']),
      operatorTxnId: toString(json['OPRTXNID']),
      updatedTime: toString(json['UPDATEDTIME']),
      insertedTime: toString(json['INSERTEDTIME']),
    );
  }
}
