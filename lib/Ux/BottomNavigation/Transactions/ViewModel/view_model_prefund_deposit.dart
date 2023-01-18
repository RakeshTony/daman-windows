import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/PrefundDepositDataModel.dart';
import 'package:daman/DataBeans/SalesReportDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_extensions.dart';

class ViewModelPrefundDeposit extends BaseViewModel {
  final StreamController<PrefundDepositDataModel> _responseStreamController =
      StreamController();

  Stream<PrefundDepositDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestPrefundDeposit(
      String userId, DateTime? fromDate, DateTime? toDate) {
    var requestData = HashMap<String, dynamic>();
    requestData["user_id"] = Encoder.encode(userId);
    if (fromDate != null && toDate != null) {
      requestData["from_date_time"] =
          Encoder.encode(fromDate.getDate() + " 00:00:00");
      requestData["to_date_time"] =
          Encoder.encode(toDate.getDate() + " 23:59:59");
    }
    request(
      networkRequest.getFundReceivedSummaryReport(requestData),
      (map) {
        PrefundDepositDataModel dataModel = PrefundDepositDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
