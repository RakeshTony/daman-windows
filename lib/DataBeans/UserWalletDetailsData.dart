import 'dart:convert';

import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_request_key.dart';
import 'package:daman/Utils/app_extensions.dart';

class UserWalletDetailsDataModel extends BaseDataModel {
  late UserData userData;

  @override
  UserWalletDetailsDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.userData = UserData.formJson(toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class UserData {
  String id;
  String email;
  String name;
  String icon;
  String mobile;
  String walletId;


  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.icon,
    required this.mobile,
    required this.walletId,
  });

  String toJson() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['email'] = email;
    map['name'] = name;
    map['icon'] = icon;
    map['mobile'] = mobile;
    map['wallet_id'] = walletId;
    return jsonEncode(map);
  }

  factory UserData.formJson(Map<String, dynamic> json) {
    return UserData(
      id: toString(json['id']),
      email: toString(json['email']),
      name: toString(json['name']),
      icon: toString(json['icon']),
      mobile: toString(json['mobile']),
      walletId: toString(json['wallet_id']),
    );
  }
}



class ProfileDataModel extends BaseDataModel {
  late UserData userData;
  @override
  ProfileDataModel parseData(result) {
    this.statusCode = result[AppRequestKey.RESPONSE_CODE] as int;
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var responseData = result[AppRequestKey.RESPONSE_DATA];
    this.userData = UserData.formJson(responseData["User"]);
    return this;
  }
}
