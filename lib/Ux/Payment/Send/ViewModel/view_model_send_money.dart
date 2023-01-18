import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/UserWalletDetailsData.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

class ViewModelSendMoney extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream => _validationErrorStreamController.stream;

  final StreamController<UserWalletDetailsDataModel> _responseStreamController = StreamController();

  Stream<UserWalletDetailsDataModel> get responseStream => _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestUserWallet(TextEditingController voucherPinNumber) async {
    String _pinNumber = voucherPinNumber.text.trim();
    String _error = _validateDetails(_pinNumber);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["value"] = Encoder.encode(_pinNumber);
      requestMap["type"] = Encoder.encode("SEND");
      request(
        networkRequest.getUserWalletDetails(requestMap),
        (map) {
          UserWalletDetailsDataModel dataModel = UserWalletDetailsDataModel();
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
      return "Please Enter number";
    else
      return "";
  }
}
