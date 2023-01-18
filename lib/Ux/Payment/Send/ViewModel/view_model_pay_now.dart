import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_settings.dart';

class ViewModelPayNow extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream => _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController = StreamController();

  Stream<DefaultDataModel> get responseStream => _responseStreamController.stream;

  final StreamController<BalanceDataModel> _balanceResponseStreamController = StreamController();

  Stream<BalanceDataModel> get balanceResponseStream => _balanceResponseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestPayNow(TextEditingController payAmount,TextEditingController paydesc,String w_Id,String credit_type) async {
    String _amount = payAmount.text.trim();
    String _paydesc = paydesc.text.trim();
    String _walletid = w_Id;
    String _isCredit = credit_type;
    String _error = _validateDetails(_amount,_walletid,_amount);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["amount"] = Encoder.encode(_amount);
      requestMap["wallet_id"] = Encoder.encode(_walletid);
      requestMap["is_credit"] = Encoder.encode(_isCredit);
      requestMap["description"] = Encoder.encode(_paydesc);
      request(
        networkRequest.payNow(requestMap),
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

  String _validateDetails(String amount,String walletId,String iscredit) {
    if (amount.isEmpty)
      return "Please Enter amount";
    else if(walletId.isEmpty)
      return "Please select valid user";
    else if(iscredit.isEmpty)
      return "Please select transfer type";
    else
      return "";
  }

  void requestUserBalanceEnquiry(String UserId) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["app_version"] = Encoder.encode(AppSettings.APP_VERSION);
    requestMap["user_id"] = Encoder.encode(UserId);
    await request(
      networkRequest.getBalanceEnquiry(requestMap),
          (map) {
        BalanceDataModel dataModel = BalanceDataModel();
        dataModel.parseData(map);
        _balanceResponseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
