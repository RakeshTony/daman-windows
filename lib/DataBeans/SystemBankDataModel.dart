import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class SystemBankDataModel extends BaseDataModel {
  List<SystemBankData> data = [];
  @override
  SystemBankDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => SystemBankData.fromJson(e)).toList();
    return this;
  }
}

class SystemBankData {
  String id;
  String accountName;
  String number;
  String ifsc;
  String micr;
  String bankName;
  String aadhar;

  SystemBankData({
    this.id = "",
    this.accountName = "",
    this.number = "",
    this.ifsc = "",
    this.micr = "",
    this.bankName = "",
    this.aadhar = "",
  });

  factory SystemBankData.fromJson(Map<String, dynamic> json) {
    return SystemBankData(
      id: toString(json['RECORDID']),
      accountName: toString(json['ACCNAME']),
      number: toString(json['NUMBER']),
      ifsc: toString(json['IFSC']),
      micr: toString(json['MICR']),
      bankName: toString(json['BANKNAME']),
      aadhar: toString(json['AADHAAR']),
    );
  }
}
