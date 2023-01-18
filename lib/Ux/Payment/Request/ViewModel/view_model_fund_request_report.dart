import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/FundRequestReportResponseDataModel.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_settings.dart';

class ViewModelFundRequestReport extends BaseViewModel {
  final StreamController<List<FundRequestDataModel>>
      _responseStreamController = StreamController();

  Stream<List<FundRequestDataModel>> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }


  void requestFundRequestReport(String isCredit, String paymentType,DateTime? fromDate, DateTime? toDate,String status) {
    var requestData = HashMap<String, dynamic>();
    requestData["type"] = Encoder.encode("ME"); // recharge , transfer ,  etc.
    requestData["payment_mode"] = Encoder.encode(paymentType);
    requestData["is_credit"] = Encoder.encode(isCredit);
    if (fromDate != null && toDate != null) {
      requestData["from_date_time"] =
          Encoder.encode(fromDate.getDate() + " 00:00:00");
      requestData["to_date_time"] =
          Encoder.encode(toDate.getDate() + " 23:59:59");
    }
    requestData["status"] = Encoder.encode(status);
    request(
      networkRequest.fundRequestReport(requestData),
      (map) {
        FundRequestReportResponseDataModel dataModel = FundRequestReportResponseDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel.statements);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
