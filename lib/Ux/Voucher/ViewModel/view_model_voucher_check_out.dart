import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';

class ViewModelVoucherCheckOut extends BaseViewModel {
  final StreamController<BulkOrderResponseDataModel> _responseStreamController =
      StreamController();

  Stream<BulkOrderResponseDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
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
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
