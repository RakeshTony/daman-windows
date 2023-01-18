import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/MyBankAccountDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';

import '../../../../Utils/app_action.dart';

class ViewModelTransferMoney extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<MyBankAccount>> _banksStreamController =
      StreamController();

  Stream<List<MyBankAccount>> get banksStream => _banksStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _banksStreamController.close();
    super.disposeStream();
  }

  void requestMyBankAccount(int beneficiaryType) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["is_beneficiary"] = Encoder.encode(beneficiaryType.toString());
    request(
      networkRequest.getUserBanksList(requestMap),
      (map) {
        MyBankAccountDataModel dataModel = MyBankAccountDataModel();
        dataModel.parseData(map);
        _banksStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
      isResponseStatus: true,
    );
  }

  void redirectBankCardPaymentMethod(
      TextEditingController amountController,
      TextEditingController amountConfirmController,
      TextEditingController remark,
      BuildContext context) async {
    String _remark = remark.text.trim();
    String _amount = amountController.text.trim();
    String _amountConfirm = amountConfirmController.text.trim();
    String _error = _validateDetailsBankCard(_amount, _amountConfirm);
    if (_error.isEmpty) {
      AppAction.openWebPage(context, "Wallet Topup - Bank Card",
          "${AppSettings.BASE_URL}payments/manual_refill_wallet");
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  void requestTransferMoney(
    MyBankAccount? sender,
    MyBankAccount receiver,
    TextEditingController amountController,
    TextEditingController amountConfirmController,
    TextEditingController remark,
  ) async {
    String _remark = remark.text.trim();
    String _amount = amountController.text.trim();
    String _amountConfirm = amountConfirmController.text.trim();
    String _error = _validateDetails(
        sender?.recordId ?? "", _amount, _amountConfirm, _remark);
    AppLog.e("SENDER ", sender?.recordId ?? "");
    AppLog.e("RECEIVER", receiver.recordId);
    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["sender_banker_id"] = Encoder.encode(sender?.recordId ?? "");
      requestMap["receiver_banker_id"] = Encoder.encode(receiver.recordId);
      requestMap["amount"] = Encoder.encode(_amount);
      requestMap["description"] = Encoder.encode(_remark);
      request(
        networkRequest.transferMoney(requestMap),
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

  String _validateDetails(
      String senderBankId, String amount, String confirm, String remark) {
    if (senderBankId.isEmpty)
      return "Please Select Bank";
    else if (amount.isEmpty)
      return "Please Enter Amount";
    else if (confirm.isEmpty)
      return "Please Enter Confirm Amount";
    else if (!confirm.endsWith(amount))
      return "Amount Not Match";
    else if (remark.isEmpty)
      return "Please Enter Remark";
    else
      return "";
  }

  String _validateDetailsBankCard(String amount, String confirm) {
    if (amount.isEmpty)
      return "Please Enter Amount";
    else if (confirm.isEmpty)
      return "Please Enter Confirm Amount";
    else if (!confirm.endsWith(amount))
      return "Amount Not Match";
    else
      return "";
  }
}
