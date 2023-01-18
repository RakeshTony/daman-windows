import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

class ViewModelRedeemVoucher extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream => _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController = StreamController();

  Stream<DefaultDataModel> get responseStream => _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestRedeemVoucher(
      TextEditingController voucherPinNumber) async {
    String _pinNumber = voucherPinNumber.text.trim();
    String _error = _validateDetails(_pinNumber);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["pin_number"] = Encoder.encode(_pinNumber);
      request(
        networkRequest.doRedeemVoucher(requestMap),
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

  String _validateDetails(String pinNumber) {
    if (pinNumber.isEmpty)
      return "Please Enter voucher number";
    else
      return "";
  }
}
