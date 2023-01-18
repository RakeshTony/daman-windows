import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_settings.dart';

import '../../../../DataBeans/BulkOrderResponseDataModel.dart';
import '../../../../DataBeans/MyOrderReportResponseDataModel.dart';

class ViewModelMyOrderReport extends BaseViewModel {
  final StreamController<List<MyOrderReportDataModel>>_responseStreamController = StreamController();

  Stream<List<MyOrderReportDataModel>> get responseStream => _responseStreamController.stream;

  final StreamController<BulkOrderResponseDataModel> _responseStreamControllerSettlement = StreamController();

  Stream<BulkOrderResponseDataModel> get responseStreamSettlement => _responseStreamControllerSettlement.stream;

  final StreamController<DefaultDataModel> _responseStreamControllerDownloadStatus = StreamController();

  Stream<DefaultDataModel> get responseStreamDownloadStatus => _responseStreamControllerDownloadStatus.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }


  void requestWallet() {
    final box = HiveBoxes.getRecentTransactions();
    if (box.values.isNotEmpty) {
      box.clear();
    }
    var requestData = HashMap<String, dynamic>();
    requestData["consider_as"] = ""; // Cr  Dr
    requestData["from_date_time"] = "";
    requestData["to_date_time"] = "";
    requestData["offset"] = 0;
    requestData["type"] = ""; // recharge , transfer ,  etc.
    request(
      networkRequest.getUserOrders(requestData),
      (map) {
        MyOrderReportResponseDataModel dataModel = MyOrderReportResponseDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel.orderData);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestPinSettlementEnquiry(String  orderNumber) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["order_number"] = Encoder.encode(orderNumber);
    await request(
      networkRequest.doPinSettlement(requestMap),
          (map) {
            BulkOrderResponseDataModel dataModel = BulkOrderResponseDataModel();
            dataModel.parseData(map);
            _responseStreamControllerSettlement.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestUpdatePinDownloadStatus(String  orderNumber,String orderStatus) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["oid"] = Encoder.encode(orderNumber);
    requestMap["osts"] = Encoder.encode(orderStatus);
    await request(
      networkRequest.doUpdatePinsDownloadStatus(requestMap),
          (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamControllerDownloadStatus.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
