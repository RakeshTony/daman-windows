import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/LoginDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/pair.dart';
import 'package:daman/Ux/Authentication/Verification/verification_page.dart';

class ViewModelLogin extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<Pair<RedirectVerificationModel, LoginDataModel>>
      _responseStreamController = StreamController();

  Stream<Pair<RedirectVerificationModel, LoginDataModel>> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<CountryData>> _countriesStreamController =
      StreamController();

  Stream<List<CountryData>> get countriesStream =>
      _countriesStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _countriesStreamController.close();
    super.disposeStream();
  }

  void requestCountries() {
    final box = HiveBoxes.getCountries();
    if (box.values.isEmpty) {
      request(
        networkRequest.getCountries(),
        (map) {
          CountryDataModel dataModel = CountryDataModel();
          dataModel.parseData(map);
          var countries = dataModel.countries.map((element) {
            return element.toCountry;
          }).toList();
          box.addAll(countries);
          _countriesStreamController.sink.add(dataModel.countries);
        },
        errorType: ErrorType.BANNER,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      var countries = box.values.map((e) => e.toCountryData).toList();
      _countriesStreamController.sink.add(countries);
    }
  }

  void requestLogin(
    TextEditingController mobileController,
    TextEditingController passwordController,
    String deviceInfo,
  ) async {
    String _username = mobileController.text.trim();
    String _password = passwordController.text.trim();
    String _error = _validateUserDetails(_username, _password);
    if (_error.isEmpty) {
      AppLog.e("DEVICE INFO", deviceInfo);
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["username"] = Encoder.encode(_username);
      requestMap["pass"] = Encoder.encode(_password);
      requestMap["is_sales"] = Encoder.encode("false");
      requestMap["device_info"] = Encoder.encode(deviceInfo);
      requestMap["device_details"] = Encoder.encode("Empty Send");
      requestMap["fcm_token_key"] = Encoder.encode("Empty Send");
      request(
        networkRequest.loginUser(requestMap),
        (map) {
          LoginDataModel dataModel = LoginDataModel();
          dataModel.parseData(map);

          var redirect = RedirectVerificationModel(
            requestMap["username"],
            requestMap["pass"],
            requestMap["is_sales"],
            requestMap["device_info"],
            requestMap["device_details"],
            requestMap["fcm_token_key"],
          );
          _responseStreamController.sink.add(Pair(redirect, dataModel));
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  String _validateUserDetails(String number, String password) {
    if (number.isEmpty)
      return "Please Enter Username Number";
    else if (password.isEmpty)
      return "Please Enter Password";
    else
      return "";
  }
}
