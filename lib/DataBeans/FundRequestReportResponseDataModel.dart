import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class FundRequestReportResponseDataModel extends BaseDataModel {
  List<FundRequestDataModel> statements = [];
  @override
  FundRequestReportResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.statements = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => FundRequestDataModel.fromJson(e))
        .toList();
    return this;
  }
}

class FundRequestDataModel {
  FundRequestModel fundRequest;
  UserData user;
  UserBankerData userBanker;

  FundRequestDataModel({
    required this.fundRequest,
    required this.user,
    required this.userBanker,
  });

  factory FundRequestDataModel.fromJson(Map<String, dynamic> json) {
    return FundRequestDataModel(
      fundRequest: FundRequestModel.fromJson(toMap(json['FundRequest'])),
      user: UserData.fromJson(toMap(json["User"])),
      userBanker: UserBankerData.fromJson(toMap(json["AdminBanker"])),//UserBanker
    );
  }
}

class FundRequestModel {
  String id;
  String amount;
  String fundDateTime;
  String status;
  String statusNote;
  String created;

  FundRequestModel({
    this.id = "",
    this.amount = "",
    this.fundDateTime = "",
    this.status = "",
    this.statusNote = "",
    this.created = "",
  });

  factory FundRequestModel.fromJson(Map<String, dynamic> json) {
    return FundRequestModel(
      id: toString(json["id"]),
      amount: toString(json["amount"]),
      fundDateTime: toString(json["fund_datetime"]),
      status: toString(json["status"]),
      statusNote: toString(json["status_note"]),
      created: toString(json["created"]),
    );
  }
}

class UserData {
  String id;
  String username;
  String name;

  UserData({
    required this.id,
    required this.username,
    required this.name,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: toString(json['id']),
      username: toString(json['username']),
      name: toString(json['name']),
    );
  }
}

class UserBankerData {
  String id;
  String accountName;
  String accountNumber;

  UserBankerData({
    required this.id,
    required this.accountName,
    required this.accountNumber,
  });

  factory UserBankerData.fromJson(Map<String, dynamic> json) {
    return UserBankerData(
      id: toString(json['id']),
      accountName: toString(json['acc_name']),
      accountNumber: toString(json['acc_number']),
    );
  }
}
