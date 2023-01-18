import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';

part 'recent_transaction.g.dart';

@HiveType(typeId: 7)
class RecentTransaction extends HiveObject {
  @HiveField(0)
  late String operator;
  @HiveField(1)
  late String operatorLogo;
  @HiveField(2)
  late String orderNumber;
  @HiveField(3)
  late String orderQuantity;
  @HiveField(4)
  late String user;
  @HiveField(5)
  late String transaction;
  @HiveField(6)
  late String type;
  @HiveField(7)
  late String consider;
  @HiveField(8)
  late double amount;
  @HiveField(9)
  late double openBal;
  @HiveField(10)
  late double closeBal;
  @HiveField(11)
  late String created;
  @HiveField(12)
  late String narration;
}

extension RecentTransactionDataExtension on RecentTransaction {
  WalletStatementDataModel get toWalletData => WalletStatementDataModel()
    ..operator = this.operator
    ..operatorLogo = this.operatorLogo
    ..orderNumber = this.orderNumber
    ..orderQuantity = this.orderQuantity
    ..user = this.user
    ..transaction = this.transaction
    ..type = this.type
    ..consider = this.consider
    ..amount = this.amount
    ..openBal = this.openBal
    ..closeBal = this.closeBal
    ..narration = this.narration
    ..created = this.created;
}

extension WalletStatementDataModelExtension on WalletStatementDataModel {
  RecentTransaction get toTransaction => RecentTransaction()
    ..operator = this.operator
    ..operatorLogo = this.operatorLogo
    ..orderNumber = this.orderNumber
    ..orderQuantity = this.orderQuantity
    ..user = this.user
    ..transaction = this.transaction
    ..type = this.type
    ..consider = this.consider
    ..amount = this.amount
    ..openBal = this.openBal
    ..closeBal = this.closeBal
    ..narration = this.narration
    ..created = this.created;
}
