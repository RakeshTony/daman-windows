import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/balance.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class BalanceDataModel extends BaseDataModel {
  late BalanceData balance;

  @override
  BalanceDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var data = result[AppRequestKey.RESPONSE_DATA];
    this.balance = BalanceData.fromJson(data);
    return this;
  }
}

class BalanceData {
  double total;
  double lockFund;
  double balance;
  double balanceStock;
  double totalSales;
  double totalProfit;
  double dueCredits;
  String currencyCode;
  String currencySign;

  BalanceData({
    this.total = 0.0,
    this.lockFund = 0.0,
    this.balance = 0.0,
    this.balanceStock = 0.0,
    this.totalSales = 0.0,
    this.totalProfit = 0.0,
    this.dueCredits = 0.0,
    this.currencyCode = "",
    this.currencySign = "",
  });

  factory BalanceData.fromJson(Map<dynamic, dynamic> json) {
    return BalanceData(
      total: toDouble(json['RESPONSE_TOTAL']),
      lockFund: toDouble(json['LOCK_FUND']),
      balance: toDouble(json['BALANCE']),
      balanceStock: toDouble(json['STOCK_BAL']),
      totalSales: toDouble(json['TOTAL_SALES']),
      totalProfit: toDouble(json['TOTAL_PROFIT']),
      dueCredits: toDouble(json['DUE_CREDITS']),
      currencyCode: toString(json['CURRENCY_CODE']),
      currencySign: toString(json['CURRENCY_SIGN']),
    );
  }
}

extension BalanceDataExtension on BalanceData {
  Balance get toBalance => Balance()
    ..total = this.total
    ..lockFund = this.lockFund
    ..balance = this.balance
    ..balanceStock = this.balanceStock
    ..totalSales = this.totalSales
    ..totalProfit = this.totalProfit
    ..dueCredits = this.dueCredits
    ..currencyCode = this.currencyCode
    ..currencySign = this.currencySign;
}
