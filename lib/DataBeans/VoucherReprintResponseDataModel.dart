import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class VoucherReprintResponseDataModel extends BaseDataModel {
  List<VoucherReprintData> pinsNotRequested = [];
  List<VoucherReprintData> pinsRequested = [];
  List<VoucherReprintData> pinsApproved = [];

  @override
  VoucherReprintResponseDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    if (result.containsKey(AppRequestKey.RESPONSE_DATA)) {
      this.pinsNotRequested = toList(
              toMap(result[AppRequestKey.RESPONSE_DATA])["NOT_REQUESTED_PINS"])
          .map((e) => VoucherReprintData.fromJson(e))
          .toList();
      this.pinsRequested =
          toList(toMap(result[AppRequestKey.RESPONSE_DATA])["REQUESTED_PINS"])
              .map((e) => VoucherReprintData.fromJson(e))
              .toList();
      this.pinsApproved = toList(toMap(
              result[AppRequestKey.RESPONSE_DATA])["APPROVED_REQUESTED_PINS"])
          .map((e) => VoucherReprintData.fromJson(e))
          .toList();
    }
    return this;
  }
}

class VoucherReprintData {
  String recordId;
  String operatorId;
  String operatorTitle;
  String denominationTitle;
  String operatorLogo;
  String voucherLogo;
  String batchNumber;
  String pinNumber;
  String serialNumber;
  String decimalValue;
  String faceValue;
  String voucherValidityInDays;
  String assignedDate;
  String orderNumber;
  String used_datetime;
  String printData;
  String finalStringToPrint;

  VoucherReprintData(
      {this.recordId = "",
      this.operatorId = "",
      this.operatorTitle = "",
      this.operatorLogo = "",
      this.voucherLogo = "",
      this.batchNumber = "",
      this.pinNumber = "",
      this.denominationTitle = "",
      this.serialNumber = "",
      this.decimalValue = "",
      this.faceValue = "",
      this.voucherValidityInDays = "",
      this.assignedDate = "",
      this.orderNumber = "",
      this.used_datetime = "",
      this.printData = "",
      this.finalStringToPrint = ""});

  factory VoucherReprintData.fromJson(Map<String, dynamic> json) {
    return VoucherReprintData(
      recordId: toString(json['recordid']),
      operatorId: toString(json['operator_id']),
      operatorTitle: toString(json['operator_name']),
      denominationTitle: toString(json['denomination_title']),
      operatorLogo: toString(json['operator_logo']),
      voucherLogo: toString(json['voucher_logo']),
      batchNumber: toString(json['batch_number']),
      pinNumber: toString(json['pin_number']),
      serialNumber: toString(json['serial_number']),
      decimalValue: toString(json['decimal_value']),
      faceValue: toString(json['face_value']),
      assignedDate: toString(json['assigned_date']),
      voucherValidityInDays: toString(json['voucher_validity_in_days']),
      orderNumber: toString(json['order_number']),
      used_datetime: toString(json['used_datetime']),
      printData: toString(json['print_data']),
      finalStringToPrint: toString(json['final_string_to_print']),
    );
  }
}
