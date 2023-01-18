import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/SystemBankDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_fund_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/pair.dart';
import 'package:path/path.dart';

class ViewModelFundRequest extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<SystemBankData>> _systemBankStreamController =
      StreamController();

  Stream<List<SystemBankData>> get systemBankStream =>
      _systemBankStreamController.stream;

  final StreamController<List<SystemBankData>> _userBankStreamController =
      StreamController();

  Stream<List<SystemBankData>> get userBankStream =>
      _userBankStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _systemBankStreamController.close();
    _userBankStreamController.close();
    super.disposeStream();
  }

  void requestFundRequest(
      TextEditingController amount,
      TextEditingController remark,
      TextEditingController settleCredits,
      FundType fundType,
      SystemBankData? admin,
      SystemBankData? user,
      Pair<String, String>? paymentType,
      TextEditingController paymentDate,
      File? receipt) async {
    String mAmount = amount.text.trim();
    String mRemark = remark.text.trim();
    String mSettleAmount = settleCredits.text.trim();
    String adminBankerId = admin?.id ?? "";
    String userBankerId = user?.id ?? "";
    String mPaymentDate = paymentDate.text.trim();

    String _error = _validateDetails(fundType, mAmount, adminBankerId,
        userBankerId, paymentType?.second ?? "");
    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["amount"] = Encoder.encode(mAmount);
      requestMap["remark"] = Encoder.encode(mRemark);
      requestMap["is_credit"] = Encoder.encode(fundType.value.toString());
      if (fundType == FundType.ADD_MONEY) {
        requestMap["admin_banker_id"] = Encoder.encode(adminBankerId);
        requestMap["user_banker_id"] = Encoder.encode(userBankerId);
        requestMap["receivable_credit"] = Encoder.encode(mSettleAmount);
        requestMap["payment_mode"] = Encoder.encode(paymentType?.second ?? "");
        requestMap["fund_datetime"] = Encoder.encode(mPaymentDate);
        if (receipt != null) {
          var fileName = basename(receipt.path);
          requestMap["image"] = MultipartFile.fromBytes(
              receipt.readAsBytesSync(),
              filename: fileName);
        }
      }
      request(
        networkRequest.fundRequest(requestMap),
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

  void requestSystemBank() async {
    request(
      networkRequest.getSystemAdminBanksList(),
      (map) {
        SystemBankDataModel dataModel = SystemBankDataModel();
        dataModel.parseData(map);
        _systemBankStreamController.sink.add(dataModel.data);
        // requestUserBank();
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NONE,
    );
  }

  void requestUserBank() async {
    HashMap<String, dynamic> requestMap = HashMap();
    //requestMap["is_beneficiary"] = Encoder.encode("0");
    request(
      networkRequest.getUserBanksList(requestMap),
      (map) {
        SystemBankDataModel dataModel = SystemBankDataModel();
        dataModel.parseData(map);
        _userBankStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NONE,
    );
  }

  String _validateDetails(FundType type, String amount, String adminBankId,
      String userBankId, String paymentType) {
    if (adminBankId.isEmpty && type == FundType.ADD_MONEY)
      return "Please choose admin bank";
/*
    else if (userBankId.isEmpty && type == FundType.ADD_MONEY)
      return "Please choose user bank";
*/
    else if (paymentType.isEmpty &&
        type == FundType.ADD_MONEY)
      return "Please choose Payment type";
    else if (amount.isEmpty)
      return "Please Enter amount";
    else
      return "";
  }
}
