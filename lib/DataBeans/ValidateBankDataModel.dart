import 'dart:convert';

import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class ValidateBankDataModel extends BaseDataModel {
  late ValidateBank data;

  @override
  ValidateBankDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    data =
        ValidateBank.fromJson(jsonDecode(result[AppRequestKey.RESPONSE_DATA]));
    // this.data = list.map((e) => DefaultBank.fromJson(e)).toList();
    return this;
  }
}

class ValidateBank {
  String status;
  String message;
  String data;
  String sourceAccount;
  String sourceBankCode;
  String sourceAccountName;
  String responseData;

  ValidateBank({
    this.status = "",
    this.message = "",
    this.data = "",
    this.sourceAccount = "",
    this.sourceBankCode = "",
    this.sourceAccountName = "",
    this.responseData = "",
  });

  factory ValidateBank.fromJson(Map<String, dynamic> json) {
    return ValidateBank(
      status: toString(json["status"]),
      message: toString(json["message"]),
      data: toString(json["data"]),
      sourceAccount: toString(json["sourceAccount"]),
      sourceBankCode: toString(json["sourceBankCode"]),
      sourceAccountName: toString(json["sourceAccountName"]),
      responseData: toString(json["responseData"]),
    );
  }
}
