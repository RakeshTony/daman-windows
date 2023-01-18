import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';

import '../../../DataBeans/BulkOrderResponseDataModel.dart';
import '../../../DataBeans/PinsStatusUpdateDataModel.dart';
import '../../../Utils/app_encoder.dart';
import '../../../Utils/app_log.dart';

class ViewModelAddUserPurchaseOrder extends BaseViewModel {
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
    List operatorsArray = const [],
  }) async {
    var min = 100000;
    var max = 999999;
    var requestNumber = min + Random.secure().nextInt(max - min);

    var mainJsonArray = [];
    var mainObject = HashMap();

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

    var response =
        '{"RESPONSE":true,"RESPONSE_MSG":"Params","RESPONSE_DATA":[{"recordid":13214564,"operator_id":"7","operator_title":"SALIK","denomination_title":"SALIK 50","batch_number":"2021/08/16602980128","pin_number":"396629806940","serial_number":"464532231","decimal_value":"50.00","selling_price":"49.50","face_value":"50.00","voucher_validity_in_days":"-48515","expiry_date":"","assigned_date":"2021-10-05 18:32:01","order_number":"798465465456","used_date":"2021-10-05 18:32:01","denomination_currency":"2","denomination_currency_sign":"AED","decimal_value_conversion_price":"50.00","selling_price_conversion_price":"49.50","receipt_data":""}],"RESPONSE_CODE":200}';
    BulkOrderResponseDataModel dataModel = BulkOrderResponseDataModel();
    dataModel.parseData(jsonDecode(response));
    // _responseStreamController.sink.add(dataModel);
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
