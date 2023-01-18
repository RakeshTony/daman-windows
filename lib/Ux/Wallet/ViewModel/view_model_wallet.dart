import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_settings.dart';

import '../../../DataBeans/PinsStatusUpdateDataModel.dart';

class ViewModelWallet extends BaseViewModel {
  final StreamController<List<WalletStatementDataModel>>
      _responseStreamController = StreamController();

  Stream<List<WalletStatementDataModel>> get responseStream =>
      _responseStreamController.stream;

  final StreamController<PinsStatusUpdateDataModel>
      _responseStreamControllerSoldStatus = StreamController();

  Stream<PinsStatusUpdateDataModel> get responseStreamSoldStatus =>
      _responseStreamControllerSoldStatus.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestBalanceEnquiry() async {
    final box = HiveBoxes.getBalance();
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["app_version"] = Encoder.encode(AppSettings.APP_VERSION);
    await request(
      networkRequest.getBalanceEnquiry(requestMap),
      (map) async {
        BalanceDataModel dataModel = BalanceDataModel();
        dataModel.parseData(map);
        await box.put("BAL", dataModel.balance.toBalance);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NONE,
    );
  }

  void requestWallet() async {
    final box = HiveBoxes.getRecentTransactions();
    if (box.values.isNotEmpty) {
      await box.clear();
    }
    var requestData = HashMap<String, dynamic>();
    requestData["consider_as"] = ""; // Cr  Dr
    requestData["from_date_time"] = "";
    requestData["to_date_time"] = "";
    requestData["offset"] = 0;
    requestData["type"] = ""; // recharge , transfer ,  etc.
    request(
      networkRequest.getWalletStatements(requestData),
      (map) async {
        WalletStatementResponseDataModel dataModel =
            WalletStatementResponseDataModel();
        dataModel.parseData(map);
        var data = dataModel.statements.map((e) => e.toTransaction).toList();
        await box.addAll(data);
        _responseStreamController.sink.add(dataModel.statements);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
