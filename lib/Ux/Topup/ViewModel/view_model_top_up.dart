import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/AutoDetectOperatorDataModel.dart';
import 'package:daman/DataBeans/RecentTransactionDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

class ViewModelTopUp extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<AutoDetectOperatorDataModel>
      _responseStreamController = StreamController();

  Stream<AutoDetectOperatorDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<RecentTransactionModel>>
      _recentTopUpStreamController = StreamController();

  Stream<List<RecentTransactionModel>> get recentTopUpStream =>
      _recentTopUpStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _recentTopUpStreamController.close();
    super.disposeStream();
  }

  void requestAutoDetectOperator(
      String countryId, TextEditingController number) async {
    var mNumber = number.text.toString();

    String _error = _validateUserDetails(mNumber);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["country_id"] = Encoder.encode(countryId);
      requestMap["mobilenumber"] = Encoder.encode(mNumber);
      request(
        networkRequest.getAutoDetectOperator(requestMap),
        (map) {
          AutoDetectOperatorDataModel dataModel = AutoDetectOperatorDataModel();
          dataModel.parseData(map);
          _responseStreamController.sink.add(dataModel);
        },
        errorType: ErrorType.NONE,
        requestType: RequestType.NON_INTERACTIVE,
        isResponseStatus: true,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  void requestRecentTopUps() {
    var requestMap = HashMap<String, dynamic>();
    request(
      networkRequest.getLatestTransactions(requestMap),
      (map) {
        RecentTransactionDataModel dataModel = RecentTransactionDataModel();
        dataModel.parseData(map);
        _recentTopUpStreamController.sink.add(dataModel.transactions);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.INTERACTIVE,
    );
  }

  String _validateUserDetails(String number) {
    if (number.isEmpty) return "Please Enter Mobile Number";
    return "";
  }
}
