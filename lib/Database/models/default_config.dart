import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/DefaultConfigDataModel.dart';

part 'default_config.g.dart';

@HiveType(typeId: 10)
class DefaultConfig extends HiveObject {
  @HiveField(0)
  late String balance;
  @HiveField(1)
  late String complaint;
  @HiveField(2)
  late String contactNo;
  @HiveField(3)
  late String faq;
  @HiveField(4)
  late String fundTransfer;
  @HiveField(5)
  late String fUrl;
  @HiveField(6)
  late String last5;
  @HiveField(7)
  late String logoUrl;
  @HiveField(8)
  late String longCode;
  @HiveField(9)
  late String recharge;
  @HiveField(10)
  late String register;
  @HiveField(11)
  late String support;
  @HiveField(12)
  late String tcUrl;
  @HiveField(13)
  late String timeOut;
  @HiveField(14)
  late String twitterUrl;
  @HiveField(15)
  late String warehouse;
  @HiveField(16)
  late String whatsAppNo;
  @HiveField(17)
  late String facebookUrl;
  @HiveField(18)
  late String website;
  @HiveField(19)
  late String email;
}

extension DefaultConfigExtension on DefaultConfig {
  DefaultConfigModel get toDefaultConfigModel => DefaultConfigModel()
    ..balance = this.balance
    ..complaint = this.complaint
    ..facebookUrl = this.facebookUrl
    ..contactNo = this.contactNo
    ..faq = this.faq
    ..fundTransfer = this.fundTransfer
    ..fUrl = this.fUrl
    ..last5 = this.last5
    ..logoUrl = this.logoUrl
    ..longCode = this.longCode
    ..recharge = this.recharge
    ..register = this.register
    ..support = this.support
    ..tcUrl = this.tcUrl
    ..timeOut = this.timeOut
    ..twitterUrl = this.twitterUrl
    ..warehouse = this.warehouse
    ..whatsAppNo = this.whatsAppNo
    ..website = this.website
    ..email = this.email;
}

extension DefaultConfigModelExtension on DefaultConfigModel {
  DefaultConfig get toDefaultConfig => DefaultConfig()
    ..balance = this.balance
    ..complaint = this.complaint
    ..facebookUrl = this.facebookUrl
    ..contactNo = this.contactNo
    ..faq = this.faq
    ..fundTransfer = this.fundTransfer
    ..fUrl = this.fUrl
    ..last5 = this.last5
    ..logoUrl = this.logoUrl
    ..longCode = this.longCode
    ..recharge = this.recharge
    ..register = this.register
    ..support = this.support
    ..tcUrl = this.tcUrl
    ..timeOut = this.timeOut
    ..twitterUrl = this.twitterUrl
    ..warehouse = this.warehouse
    ..whatsAppNo = this.whatsAppNo
    ..website = this.website
    ..email = this.email;
}
