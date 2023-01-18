import 'dart:convert';

import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class CountryDataModel extends BaseDataModel {
  List<CountryData> countries = [];

  @override
  CountryDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this.countries = list.map((e) => CountryData.fromJson(e)).toList();
    return this;
  }
}

class CountryData {
  String id;
  String title;
  String iso;
  String phoneCode;
  String flag;
  int mobileNumberLength;

  CountryData({
    this.id = "",
    this.title = "",
    this.iso = "",
    this.phoneCode = "",
    this.flag = "",
    this.mobileNumberLength = 0,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: json["id"].toString(),
      title: json["title"].toString(),
      iso: json["iso"].toString(),
      phoneCode: json["phonecode"].toString(),
      flag: json["flag"].toString(),
      mobileNumberLength: int.parse(json["mobile_number_length"]),
    );
  }
  @override
  String toString() {
    var map = Map<String,dynamic>();
    map["id"] = this.id;
    map["name"] = this.title;
    return jsonEncode(map);
  }
}

extension CountryExtension on CountryData {
  Country get toCountry => Country()
    ..id = this.id
    ..title = this.title
    ..iso = this.iso
    ..phoneCode = this.phoneCode
    ..flag = this.flag
    ..mobileNumberLength = this.mobileNumberLength;
}
