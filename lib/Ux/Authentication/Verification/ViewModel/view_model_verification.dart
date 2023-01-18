import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/LoginDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Ux/Authentication/Verification/verification_page.dart';

class ViewModelVerification extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<LoginDataModel> _verifyLoginStreamController =
      StreamController();

  Stream<LoginDataModel> get verifyLoginStream =>
      _verifyLoginStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _verifyLoginStreamController.close();
    super.disposeStream();
  }

  void requestVerify(String otp, RedirectVerificationModel data,
      {bool isResend = false}) async {
    String _error = _validateUserDetails(otp);
    if (_error.isEmpty || isResend) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["username"] = data.username;
      requestMap["pass"] = data.password;
      requestMap["is_sales"] = data.isSales;
      requestMap["device_info"] = data.deviceInfo;
      requestMap["device_details"] = data.deviceDetails;
      requestMap["fcm_token_key"] = data.fcmTokenKey;
      if (!isResend) {
        requestMap["otp"] = Encoder.encode(otp);
      }
      request(
        networkRequest.loginUser(requestMap),
        (map) {
          if (isResend) {
            DefaultDataModel dataModel = DefaultDataModel();
            dataModel.parseData(map);
            _validationErrorStreamController.sink.add(dataModel.getMessage);
          } else {
            LoginDataModel dataModel = LoginDataModel();
            dataModel.parseData(map);
            _verifyLoginStreamController.sink.add(dataModel);
          }
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  String _validateUserDetails(String otp) {
    if (otp.isEmpty)
      return "Please Enter OTP";
    else if (otp.length != 4)
      return "Please Enter 4 Digit OTP";
    else
      return "";
  }
}
