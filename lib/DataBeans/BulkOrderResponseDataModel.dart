import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/offline_pin_stock.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class BulkOrderResponseDataModel extends BaseDataModel {
  List<VoucherDenomination> vouchers = [];

  @override
  BulkOrderResponseDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.vouchers =
        toList(toMap(result[AppRequestKey.RESPONSE_DATA])["PURCHASE_PINS"])
            .map((e) => VoucherDenomination.fromJson(e))
            .toList();
    return this;
  }

  BulkOrderResponseDataModel parseDataSettlement(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    if (result.containsKey(AppRequestKey.RESPONSE_DATA)) {
      this.vouchers = toList(result[AppRequestKey.RESPONSE_DATA])
          .map((e) => VoucherDenomination.fromJson(e))
          .toList();
    }
    return this;
  }
}

class VoucherDenomination {
  String recordId;
  String operatorId;
  String operatorTitle;
  String denominationId;
  String denominationTitle;
  String batchNumber;
  String pinNumber;
  String serialNumber;
  String decimalValue;
  String sellingPrice;
  String faceValue;
  String voucherValidityInDays;
  String expiryDate;
  String assignedDate;
  String orderNumber;
  String usedDate;
  String denominationCurrency;
  String denominationCurrencySign;
  String decimalValueConversionPrice;
  String sellingPriceConversionPrice;
  String receiptData;

  VoucherDenomination({
    this.recordId = "",
    this.operatorId = "",
    this.operatorTitle = "",
    this.batchNumber = "",
    this.pinNumber = "",
    this.denominationId = "",
    this.denominationTitle = "",
    this.serialNumber = "",
    this.decimalValue = "",
    this.sellingPrice = "",
    this.faceValue = "",
    this.voucherValidityInDays = "",
    this.expiryDate = "",
    this.assignedDate = "",
    this.orderNumber = "",
    this.usedDate = "",
    this.denominationCurrency = "",
    this.denominationCurrencySign = "",
    this.decimalValueConversionPrice = "",
    this.sellingPriceConversionPrice = "",
    this.receiptData = "",
  });

  factory VoucherDenomination.fromJson(Map<String, dynamic> json) {
    return VoucherDenomination(
      recordId: toString(json['recordid']),
      operatorId: toString(json['operator_id']),
      operatorTitle: toString(json['operator_title']),
      denominationId: toString(json['denomination_id']),
      denominationTitle: toString(json['denomination_title']),
      batchNumber: toString(json['batch_number']),
      pinNumber: toString(json['pin_number']),
      serialNumber: toString(json['serial_number']),
      decimalValue: toString(json['decimal_value']),
      sellingPrice: toString(json['selling_price']),
      faceValue: toString(json['face_value']),
      assignedDate: toString(json['assigned_date']),
      voucherValidityInDays: toString(json['voucher_validity_in_days']),
      expiryDate: toString(json['expiry_date']),
      orderNumber: toString(json['order_number']),
      usedDate: toString(json['used_date']),
      denominationCurrency: toString(json['denomination_currency']),
      denominationCurrencySign: toString(json['denomination_currency_sign']),
      decimalValueConversionPrice:
          toString(json['decimal_value_conversion_price']),
      sellingPriceConversionPrice:
          toString(json['selling_price_conversion_price']),
      receiptData: toString(json['receipt_data']),
    );
  }

  factory VoucherDenomination.fromOfflinePinStock(OfflinePinStock json) {
    return VoucherDenomination(
      recordId: json.recordId,
      operatorId: json.operatorId,
      operatorTitle: json.operatorTitle,
      denominationId: json.denominationId,
      denominationTitle: json.denominationTitle,
      batchNumber: json.batchNumber,
      pinNumber: json.pinNumber,
      serialNumber: json.serialNumber,
      decimalValue: json.decimalValue,
      sellingPrice: json.sellingPrice,
      faceValue: json.faceValue,
      assignedDate: json.assignedDate,
      voucherValidityInDays: json.voucherValidityInDays,
      expiryDate: json.expiryDate,
      orderNumber: json.orderNumber,
      usedDate: json.usedDate,
      denominationCurrency: json.denominationCurrency,
      denominationCurrencySign: json.denominationCurrencySign,
      decimalValueConversionPrice: json.decimalValueConversionPrice,
      sellingPriceConversionPrice: json.sellingPriceConversionPrice,
      receiptData: json.receiptData,
    );
  }
}
