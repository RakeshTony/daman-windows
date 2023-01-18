import 'dart:convert';

import 'package:daman/Utils/app_encoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daman/DataBeans/LoginDataModel.dart';
import 'package:daman/Utils/app_settings.dart';

import '../main.dart';

class PreferencesHandler {
  static late SharedPreferences _sharedPreferences;

  static Future<PreferencesHandler> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return PreferencesHandler();
  }

  set userToken(value) => _sharedPreferences.setString("userToken", value);

  String get userToken =>
      _sharedPreferences.getString("userToken") ?? AppSettings.USER_TOKEN;

  set userIV(value) => _sharedPreferences.setString("userIV", value);

  String get userIV =>
      _sharedPreferences.getString("userIV") ?? AppSettings.USER_IV;

  set authToken(value) => _sharedPreferences.setString("authToken", value);

  String get authToken => _sharedPreferences.getString("authToken") ?? "";

  set mPin(value) => _sharedPreferences.setString("m-pin", value);

  String get mPin => _sharedPreferences.getString("m-pin") ?? "";
  set defaultBluetoothPrinter(value) =>
      _sharedPreferences.setString("default-bluetooth-printer", value);

  String get defaultBluetoothPrinter =>
      _sharedPreferences.getString("default-bluetooth-printer") ?? "";
  set selectedLanguage(value) =>
      _sharedPreferences.setString("selectedLanguage", value);

  String get selectedLanguage =>
      _sharedPreferences.getString("selectedLanguage") ?? "en";

  set userData(UserData value) =>
      _sharedPreferences.setString("userData", value.toJson());

  set groupData(GroupData value) =>
      _sharedPreferences.setString("groupData", value.toJson());

  set memberPlanData(MembershipPlanData value) =>
      _sharedPreferences.setString("memberPlanData", value.toJson());

  UserData get userData => UserData.formJson(
      jsonDecode(_sharedPreferences.getString("userData") ?? "{}"));

  GroupData get groupData => GroupData.formJson(
      jsonDecode(_sharedPreferences.getString("groupData") ?? "{}"));

  MembershipPlanData get memberPlanData => MembershipPlanData.formJson(
      jsonDecode(_sharedPreferences.getString("memberPlanData") ?? "{}"));

  bool get isLogin => authToken.isNotEmpty;

  Future<Null> setUserLogin(LoginDataModel data) async {
    userToken = data.authorizeData.userToken;
    var mAuthToken = Encoder.decode(data.authorizeData.authToken);
    var list = mAuthToken.split('~');
    userIV = list[1];
    authToken = data.authorizeData.authToken;
    userData = data.userData;
    groupData = data.groupData;
    memberPlanData = data.membershipPlanData;
    mPreference.value.mPin = userData.mobilePin;
  }

  void clear() {
    _sharedPreferences.clear();
  }
}
