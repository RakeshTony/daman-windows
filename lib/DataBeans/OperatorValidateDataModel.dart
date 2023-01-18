import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class OperatorValidateDataModel extends BaseDataModel {
  late OperatorValidateData data;

  @override
  OperatorValidateDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = OperatorValidateData.fromJson(
        toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class OperatorValidateData {
  String meterNo;
  String accountNo;
  String customerName;
  String customerAddress;
  String customerDistrict;
  String phoneNumber;
  String type;
  String disco;
  double minimumPayable;
  double outstandingAmount;

  OperatorValidateData({
    this.meterNo = "",
    this.accountNo = "",
    this.customerName = "",
    this.customerAddress = "",
    this.customerDistrict = "",
    this.phoneNumber = "",
    this.type = "",
    this.disco = "",
    this.minimumPayable = 0.0,
    this.outstandingAmount = 0.0,
  });

  factory OperatorValidateData.fromJson(Map<String, dynamic> json) {
    return OperatorValidateData(
      meterNo: toString(json['meterNo']),
      accountNo: toString(json['accountNo']),
      customerName: toString(json['customerName']),
      customerAddress: toString(json['customerAddress']),
      customerDistrict: toString(json['customerDistrict']),
      phoneNumber: toString(json['phoneNumber']),
      type: toString(json['type']),
      disco: toString(json['disco']),
      minimumPayable: toDouble(json['minimumPayable']),
      outstandingAmount: toDouble(json['outstadingAmount']),
    );
  }
}
