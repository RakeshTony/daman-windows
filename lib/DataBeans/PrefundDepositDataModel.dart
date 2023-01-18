import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class PrefundDepositDataModel extends BaseDataModel {
  List<PrefundDepositData> data = [];
  @override
  PrefundDepositDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => PrefundDepositData.fromJson(e)).toList();
    return this;
  }
}

class PrefundDepositData {
  String date;
  double amount;
  double debitNoteAmount;

  PrefundDepositData({
    this.date = "",
    this.amount = 0.0,
    this.debitNoteAmount = 0.0,
  });

  factory PrefundDepositData.fromJson(Map<String, dynamic> json) {
    return PrefundDepositData(
      date: toString(json['DATE']),
      amount: toDouble(json['AMOUNT']),
      debitNoteAmount: toDouble(json['DEBIT_NOTE_AMOUNT']),
    );
  }
}
