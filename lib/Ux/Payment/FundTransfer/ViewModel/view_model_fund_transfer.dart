import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/ValidateBankDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

import '../../../../DataBeans/DefaultBankDataModel.dart';

class ViewModelFundTransfer extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<DefaultBank>> _defaultBankStreamController =
      StreamController();

  Stream<List<DefaultBank>> get defaultBankStream =>
      _defaultBankStreamController.stream;

  final StreamController<ValidateBank> _validateStreamController =
      StreamController();

  Stream<ValidateBank> get validateStream =>
      _validateStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _defaultBankStreamController.close();
    _validateStreamController.close();
    super.disposeStream();
  }

  void validateBeneficiary(TextEditingController accountNumberController,
      String bankIdController) async {
    String _accountNumber = accountNumberController.text.trim();
    String _bankId = bankIdController.trim();
    String _error = _validateAccountDetails(_bankId, _accountNumber);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["acc_number"] = Encoder.encode(_accountNumber);
      requestMap["bank_id"] = Encoder.encode(_bankId);
      request(
        networkRequest.validateBeneficiary(requestMap),
        (map) {
          ValidateBankDataModel dataModel = ValidateBankDataModel();
          dataModel.parseData(map);
          _validateStreamController.sink.add(dataModel.data);
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  void bankTransferDirect(
    int beneficiaryType,
    TextEditingController accountNumberController,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController paymentMethodController,
    TextEditingController amountController,
    TextEditingController emailController,
    String accountType,
    String bankIdController,
    String id,
  ) async {
    String _accountNumber = accountNumberController.text.trim();
    String _firstName = firstNameController.text.trim();
    String _lastName = lastNameController.text.trim();
    String _accType = accountType.trim();
    String _bankId = bankIdController.trim();
    String _paymentMethod = paymentMethodController.text.trim();
    String _amount = amountController.text.trim();
    String _email = emailController.text.trim();
    String _id = id.trim();
    String _error = _validateDetails(
        _accountNumber, _firstName, _lastName, _accType, _bankId);
    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["sender_acc_number"] = Encoder.encode(_id);
      requestMap["sender_acc_name"] = Encoder.encode(_bankId);
      requestMap["sender_bank_code"] = Encoder.encode(_accType);
      requestMap["receiver_acc_number"] = Encoder.encode(_accountNumber);
      requestMap["receiver_acc_name"] = Encoder.encode(_firstName);
      requestMap["receiver_bank_code"] = Encoder.encode(_lastName);
      requestMap["payment_method"] = Encoder.encode(_paymentMethod);
      requestMap["email"] = Encoder.encode(_email);
      requestMap["amount"] = Encoder.encode(_amount);
      requestMap["description"] = Encoder.encode(beneficiaryType.toString());
      request(
        networkRequest.bankTransferDirect(requestMap),
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

  String _validateAccountDetails(String bankId, String accNumber) {
    if (bankId.isEmpty)
      return "Please select bank";
    else if (accNumber.isEmpty)
      return "Please Enter Account Number";
    else
      return "";
  }

  String _validateDetails(String accNumber, String firstName, String lastName,
      String accType, String bankId) {
    if (accNumber.isEmpty)
      return "Please Enter Account Number";
    else if (firstName.isEmpty)
      return "Please Enter First Name";
    else if (lastName.isEmpty)
      return "Please Enter Last Name";
    else if (accType.isEmpty || accType == "Account Type")
      return "Please select account type";
    else if (bankId.isEmpty)
      return "Please select bank";
    else
      return "";
  }
}
