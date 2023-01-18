import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

class ViewModelChangePassword extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestChangePassword(
      TextEditingController oldPasswordController,
      TextEditingController passwordController,
      TextEditingController passwordConfirmController) async {
    String _old = oldPasswordController.text.trim();
    String _password = passwordController.text.trim();
    String _passwordConfirm = passwordConfirmController.text.trim();
    String _error = _validateDetails(_old, _password, _passwordConfirm);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["pass"] = Encoder.encode(_old);
      requestMap["newpass"] = Encoder.encode(_password);
      request(
        networkRequest.changePassword(requestMap),
        (map) {
          DefaultDataModel dataModel = DefaultDataModel();
          dataModel.parseData(map);
          _responseStreamController.sink.add(dataModel);
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  void requestForgotPasswordInside() async {
    HashMap<String, dynamic> requestMap = HashMap();
    request(
      networkRequest.resetPassword(requestMap),
          (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );

  }

  String _validateDetails(String old, String password, String confirm) {
    if (old.isEmpty)
      return "Please Enter Old Password";
    else if (password.isEmpty)
      return "Please Enter Password";
    else if (confirm.isEmpty)
      return "Please Enter Confirm Password";
    else if (!confirm.endsWith(password))
      return "Password Not Match";
    else
      return "";
  }
}
