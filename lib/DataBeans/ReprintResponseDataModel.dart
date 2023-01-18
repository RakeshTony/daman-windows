import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_request_key.dart';

class ReprintResponseDataModel extends BaseDataModel {
  late ReprintData reprintData;
  @override
  ReprintResponseDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    reprintData = ReprintData.fromJson(result[AppRequestKey.RESPONSE_DATA]);

    return this;
  }

}



class ReprintData {


  String mobile;
  //double recAmount;
  //double orgAmount;
  double amount;
  String responseStatus;
  bool response;
  String mnoResponse;
  String operatorsId;
  String operatortxnId;
  String adminId;
  String txnId;
  String status;
  String created;
  String receipt_number;
  List<ExtraDetailsReprint> extraDetails;

  ReprintData({
    this.mobile = "",
    //this.orgAmount = 0.0,
    this.amount = 0.0,
    //this.recAmount = 0.0,
    this.responseStatus = "",
    this.response = false,
    this.mnoResponse = "",
    this.operatorsId = "",
    this.operatortxnId = "",
    this.adminId = "",
    this.txnId = "",
    this.status = "",
   this.created = "",
    this.receipt_number="",
    this.extraDetails = const [],
  });

  factory ReprintData.fromJson(Map<String, dynamic> json) {
    return ReprintData(
      mobile: toString(json['mobile']),
      //recAmount: toDouble(json['rec_amount']),
      //orgAmount: toDouble(json['org_amount']),
      amount: toDouble(json['amount']),
      responseStatus: toString(json['RSTATUS']),
      response: toBoolean(json['RESPONSE']),
      mnoResponse: toString(json['MNO_RESP']),
      operatorsId: toString(json['operator_id']),
      operatortxnId: toString(json['OPERATORS_ID']),
      created: toString(json['created']),
      adminId: toString(json['ADMIN_ID']),
      txnId: toString(json['TXN_ID']),
      receipt_number: toString(json['receipt_number']),
      status: toString(json['STATUS']),
      extraDetails: toList(json['EXTRA_DETAILS'])
          .map((e) => ExtraDetailsReprint.fromJson(e))
          .toList(),
    );
  }
}

class ExtraDetailsReprint {
  String key;
  String value;

  ExtraDetailsReprint({
    this.key = "",
    this.value = "",
  });

  factory ExtraDetailsReprint.fromJson(Map<String, dynamic> json) {
    return ExtraDetailsReprint(
      key: toString(json['key']),
      value: toString(json['value']),
    );
  }
}
