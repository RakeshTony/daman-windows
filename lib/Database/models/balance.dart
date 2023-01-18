import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';

part 'balance.g.dart';

@HiveType(typeId: 3)
class Balance extends HiveObject {
  @HiveField(0)
  late double total;
  @HiveField(1)
  late double lockFund;
  @HiveField(2)
  late double balance;
  @HiveField(3)
  late double balanceStock;
  @HiveField(4)
  late double totalSales;
  @HiveField(5)
  late double totalProfit;
  @HiveField(6)
  late double dueCredits;
  @HiveField(7)
  late String currencyCode;
  @HiveField(8)
  late String currencySign;
}

extension BalanceExtension on Balance {
  BalanceData get toBalanceData => BalanceData()
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
