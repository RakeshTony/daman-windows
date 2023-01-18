import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BulkTopUpResponseDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/pair.dart';

class ViewModelTopUpCheckOut extends BaseViewModel {
  final StreamController<Pair<String, BulkTopUpResponseDataModel>>
      _responseStreamController = StreamController();

  Stream<Pair<String, BulkTopUpResponseDataModel>> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestBulkTopUp({
    String mServiceId = "",
    String operatorId = "",
    String denominationId = "",
    String denominationCategoryId = "0",
    String mobile = "",
    double amount = 0.0,
    double amountOriginal = 0.0,
    double amountReceiver = 0.0,
    List<Pair<String, dynamic>> formFields = const [],
  }) async {
    var min = 100000;
    var max = 999999;
    var requestNumber = min + Random.secure().nextInt(max - min);

    var mainJsonArray = [];
    var mainObject = HashMap();
    var operatorsArray = [];

    var operatorJsonObject = HashMap();
    operatorJsonObject["operator_id"] = operatorId;

    var denominationsArray = [];
    var denominationJsonObject = HashMap();

    denominationJsonObject["denomination_id"] = denominationId;
    denominationJsonObject["denomination_category_id"] = denominationCategoryId;

    denominationJsonObject["amount"] = amount;
    denominationJsonObject["mobile"] = mobile;

    if (amountOriginal == 0.0) {
      denominationJsonObject["org_amount"] = amount;
    } else {
      denominationJsonObject["org_amount"] = amountOriginal;
    }

    if (amountReceiver == 0.0) {
      denominationJsonObject["rec_amount"] = 0;
    } else {
      denominationJsonObject["rec_amount"] = amountReceiver;
    }

    // HERE ADDED DYNAMIC FORM KEYS
    formFields.forEach((element) {
      denominationJsonObject[element.first] = element.second;
    });

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
    request(
      networkRequest.doBulkTopUp(requestMap),
      (map) {
        BulkTopUpResponseDataModel dataModel = BulkTopUpResponseDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink
            .add(Pair(requestNumber.toString(), dataModel));
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
      isResponseStatus: true,
    );
  }
}
