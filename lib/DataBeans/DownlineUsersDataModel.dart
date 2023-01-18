import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class DownLineUsersModel extends BaseDataModel {
  List<DownLineUser> data = [];

  @override
  DownLineUsersModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => DownLineUser.fromJson(e))
        .toList();
    return this;
  }
}

class DownLineUser {
  String id;
  String name;
  String mobile;
  String email;
  String address;
  String icon;
  String created;
  String lastWalletTopupDate;
  double walletBalance;
  String groupRank;

  DownLineUser({
    this.id = "",
    this.name = "",
    this.mobile = "",
    this.email = "",
    this.address = "",
    this.icon = "",
    this.created = "",
    this.lastWalletTopupDate = "",
    this.walletBalance = 0.0,
    this.groupRank ="",
  });

  factory DownLineUser.fromJson(Map<dynamic, dynamic> json) {
    return DownLineUser(
      id: toString(json["id"]),
      name: toString(json["name"]),
      mobile: toString(json["mobile"]),
      email: toString(json["email"]),
      address: toString(json["address"]),
      icon: toString(json["icon"]),
      created: toString(json["created"]),
      groupRank:toString(json["group"]),
      lastWalletTopupDate: toString(json["last_wallet_topup_date"]),
      walletBalance: toDouble(toMaps(json["wallet"])["BALANCE"]),
    );
  }
}
