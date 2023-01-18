import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';

part 'countries.g.dart';

@HiveType(typeId: 0)
class Country extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String iso;
  @HiveField(3)
  late String phoneCode;
  @HiveField(4)
  late String flag;
  @HiveField(5)
  late int mobileNumberLength;
  @override
  String toString() {
    var data = {};
    data["countryId"] = id;
    data["countryName"] = title;
    return jsonEncode(data);
  }
}

extension CountryDataExtension on Country {
  CountryData get toCountryData => CountryData()
    ..id = this.id
    ..title = this.title
    ..iso = this.iso
    ..phoneCode = this.phoneCode
    ..flag = this.flag
    ..mobileNumberLength = this.mobileNumberLength;
}