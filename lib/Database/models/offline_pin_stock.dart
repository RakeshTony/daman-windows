import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:hive_flutter/adapters.dart';

part 'offline_pin_stock.g.dart';

@HiveType(typeId: 13)
class OfflinePinStock extends HiveObject {
  @HiveField(0)
  late String recordId;
  @HiveField(1)
  late String operatorId;
  @HiveField(2)
  late String operatorTitle;
  @HiveField(3)
  late String denominationId;
  @HiveField(4)
  late String denominationTitle;
  @HiveField(5)
  late String batchNumber;
  @HiveField(6)
  late String pinNumber;
  @HiveField(7)
  late String serialNumber;
  @HiveField(8)
  late String decimalValue;
  @HiveField(9)
  late String sellingPrice;
  @HiveField(10)
  late String faceValue;
  @HiveField(11)
  late String voucherValidityInDays;
  @HiveField(12)
  late String expiryDate;
  @HiveField(13)
  late String assignedDate;
  @HiveField(14)
  late String orderNumber;
  @HiveField(15)
  late String usedDate;
  @HiveField(16)
  late String denominationCurrency;
  @HiveField(17)
  late String denominationCurrencySign;
  @HiveField(18)
  late String decimalValueConversionPrice;
  @HiveField(19)
  late String sellingPriceConversionPrice;
  @HiveField(20)
  late String receiptData;
  @HiveField(21)
  bool isSold = false;
  @HiveField(22)
  bool syncServer = false;
  @HiveField(23)
  DateTime time = DateTime.now();
  @HiveField(24)
  int status = 0;
}

extension VoucherDenominationExtension on VoucherDenomination {
  OfflinePinStock get toOfflinePinStock => OfflinePinStock()
    ..recordId = this.recordId
    ..operatorId = this.operatorId
    ..operatorTitle = this.operatorTitle
    ..denominationId = this.denominationId
    ..denominationTitle = this.denominationTitle
    ..batchNumber = this.batchNumber
    ..pinNumber = this.pinNumber
    ..serialNumber = this.serialNumber
    ..decimalValue = this.decimalValue
    ..sellingPrice = this.sellingPrice
    ..faceValue = this.faceValue
    ..voucherValidityInDays = this.voucherValidityInDays
    ..expiryDate = this.expiryDate
    ..assignedDate = this.assignedDate
    ..orderNumber = this.orderNumber
    ..usedDate = this.usedDate
    ..denominationCurrency = this.denominationCurrency
    ..denominationCurrencySign = this.denominationCurrencySign
    ..decimalValueConversionPrice = this.decimalValueConversionPrice
    ..sellingPriceConversionPrice = this.sellingPriceConversionPrice
    ..receiptData = this.receiptData;
}
