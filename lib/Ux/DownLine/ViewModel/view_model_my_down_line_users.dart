import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/DownlineUsersDataModel.dart';
import 'package:daman/DataBeans/UserWalletDetailsData.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_settings.dart';

class ViewModelMyDownLineUsers extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DownLineUser> _responseStreamController =
      StreamController();

  Stream<DownLineUser> get responseStream => _responseStreamController.stream;

  final StreamController<List<DownLineUser>> _downLineStreamController =
      StreamController();

  Stream<List<DownLineUser>> get downLineStream =>
      _downLineStreamController.stream;

  final StreamController<UserWalletDetailsDataModel>
      _userWalletStreamController = StreamController();

  Stream<UserWalletDetailsDataModel> get userWalletStream =>
      _userWalletStreamController.stream;



  final StreamController<BalanceDataModel> _balanceResponseStreamController = StreamController();

  Stream<BalanceDataModel> get balanceResponseStream => _balanceResponseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _downLineStreamController.close();
    _userWalletStreamController.close();
    _balanceResponseStreamController.close();
    super.disposeStream();
  }

  void requestDownlineUsers() {
    request(
      networkRequest.getMyDownlineUsesList(),
      (map) {
        DownLineUsersModel dataModel = DownLineUsersModel();
        dataModel.parseData(map);
        _downLineStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestUserWallet(String number) async {
    String _error = _validateDetails(number);
    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["value"] = Encoder.encode(number);
      requestMap["type"] = Encoder.encode("SEND");
      request(
        networkRequest.getUserWalletDetails(requestMap),
        (map) {
          UserWalletDetailsDataModel dataModel = UserWalletDetailsDataModel();
          dataModel.parseData(map);
          _userWalletStreamController.sink.add(dataModel);
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
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

  String _validateDetails(String pinNumber) {
    if (pinNumber.isEmpty)
      return "invalid number";
    else
      return "";
  }
}
