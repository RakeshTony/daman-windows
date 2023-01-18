import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/DownlineUsersDataModel.dart';
import 'package:daman/DataBeans/MyBankAccountDataModel.dart';
import 'package:daman/DataBeans/UserWalletDetailsData.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';

import '../../../../DataBeans/DefaultDataModel.dart';

class ViewModelMyBankAccount extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DownLineUser> _responseStreamController =
      StreamController();

  Stream<DownLineUser> get responseStream => _responseStreamController.stream;

  final StreamController<List<MyBankAccount>> _banksStreamController =
      StreamController();

  Stream<List<MyBankAccount>> get banksStream =>
      _banksStreamController.stream;

  final StreamController<DefaultDataModel> _responseRemoveAccStreamController = StreamController();

  Stream<DefaultDataModel> get responseRemoveAccStream => _responseRemoveAccStreamController.stream;


  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _banksStreamController.close();
    _responseRemoveAccStreamController.close();
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

  void requestDeleteBeneficiary(String beneficiaryId) async {
    String _beneficiaryId = beneficiaryId;
    String _error = _validateDetails(_beneficiaryId);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["id"] = Encoder.encode(_beneficiaryId);
      request(
        networkRequest.deleteBeneficiary(requestMap),
            (map) {
          DefaultDataModel dataModel = DefaultDataModel();
          dataModel.parseData(map);
          _responseRemoveAccStreamController.sink.add(dataModel);
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
      return "invalid id";
    else
      return "";
  }
}
