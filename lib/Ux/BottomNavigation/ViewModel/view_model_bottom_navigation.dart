import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_settings.dart';

import '../../../Database/hive_boxes.dart';
import '../../../Utils/app_encoder.dart';
import '../../../Utils/app_log.dart';

class ViewModelBottomNavigation extends BaseViewModel {
  final StreamController<BulkOrderResponseDataModel>
      _bulkOrderStreamController = StreamController();

  Stream<BulkOrderResponseDataModel> get responseBulkOrderStream =>
      _bulkOrderStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestLogout() {
    HashMap<String, dynamic> requestMap = HashMap();
    request(
      networkRequest.logout(requestMap),
      (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestVoucherSell({
    String mServiceId = "",
    String mOperatorId = "",
    String mDenominationId = "",
    String mDenominationCategoryId = "0",
    int mQuantity = 0,
    double mAmount = 0.0,
  }) async {
    var min = 100000;
    var max = 999999;
    var requestNumber = min + Random.secure().nextInt(max - min);

    var mainJsonArray = [];
    var mainObject = HashMap();
    var operatorsArray = [];

    var operatorJsonObject = HashMap();
    operatorJsonObject["operator_id"] = mOperatorId;

    var denominationsArray = [];
    var denominationJsonObject = HashMap();

    denominationJsonObject["denomination_id"] = mDenominationId;
    denominationJsonObject["denomination_category_id"] =
        mDenominationCategoryId;

    denominationJsonObject["amount"] = mAmount;
    denominationJsonObject["quantity"] = mQuantity;

    denominationsArray.add(denominationJsonObject);
    operatorJsonObject["denominations"] = denominationsArray;
    operatorsArray.add(operatorJsonObject);

    mainObject["service_id"] = mServiceId;
    mainObject["operators"] = operatorsArray;

    mainJsonArray.add(mainObject);
    var requestData = jsonEncode(mainJsonArray);

    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["request"] = Encoder.encode(requestData);
    requestMap["request_number"] = Encoder.encode(requestNumber.toString());
    AppLog.i("REQUEST BULK ORDER : " + requestData);
    AppLog.i(
        "REQUEST BULK ORDER : " + Encoder.encode(requestNumber.toString()));
    request(
      networkRequest.doBulkOrder(requestMap),
      (map) {
        BulkOrderResponseDataModel dataModel = BulkOrderResponseDataModel();
        dataModel.parseData(map);
        _bulkOrderStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
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
}
