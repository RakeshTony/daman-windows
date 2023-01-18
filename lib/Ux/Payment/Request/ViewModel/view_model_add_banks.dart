import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultBankDataModel.dart';
import 'package:daman/DataBeans/DefaultBranchDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

class ViewModelAddBanks extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<List<DefaultBank>> _defaultBankStreamController =
      StreamController();

  Stream<List<DefaultBank>> get defaultBankStream =>
      _defaultBankStreamController.stream;

  final StreamController<List<DefaultBranch>> _branchStreamController =
      StreamController();

  Stream<List<DefaultBranch>> get branchStream =>
      _branchStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _defaultBankStreamController.close();
    _branchStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestAddBanks(
    TextEditingController name,
    TextEditingController number,
    DefaultBank? bank,
    DefaultBranch? branch,
  ) async {
    var mName = name.text.toString();
    var mNumber = number.text.toString();
    String _error =
        _validateDetails(mName, mNumber, bank?.id ?? "", branch?.id ?? "");
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["acc_name"] = Encoder.encode(mName);
    requestMap["acc_number"] =Encoder.encode(mNumber);
    requestMap["bank_id"] = Encoder.encode(bank?.id ?? "");
    requestMap["bank_branch_id"] = Encoder.encode(branch?.id ?? "");
    if (_error.isEmpty) {
      request(
        networkRequest.addUserBank(requestMap),
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

  void requestBankList() async {
    request(
      networkRequest.getBanksList(),
      (map) {
        DefaultBankDataModel dataModel = DefaultBankDataModel();
        dataModel.parseData(map);
        _defaultBankStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestBranchList(String bankId) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["bid"] = Encoder.encode(bankId);
    request(
      networkRequest.getBanksBranchList(requestMap),
      (map) {
        DefaultBranchDataModel dataModel = DefaultBranchDataModel();
        dataModel.parseData(map);
        _branchStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  String _validateDetails(
      String name, String number, String bankId, String branchId) {
    if (name.isEmpty) return "Please Enter account holder name";
    if (number.isEmpty) return "Please Enter account number";
    if (bankId.isEmpty) return "Please choose Bank";
    if (branchId.isEmpty)
      return "Please choose Branch";
    else
      return "";
  }
}
