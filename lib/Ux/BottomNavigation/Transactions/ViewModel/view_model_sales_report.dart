import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/SalesReportDataModel.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_extensions.dart';

class ViewModelSalesReport extends BaseViewModel {
  final StreamController<SalesReportDataModel> _responseStreamController =
      StreamController();

  Stream<SalesReportDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestSalesReport(String userId, DateTime? fromDate, DateTime? toDate,
      Service? service, Operator? operator) {
    var requestData = HashMap<String, dynamic>();
    requestData["user_id"] = Encoder.encode(userId);
    if (fromDate != null && toDate != null) {
      requestData["from_date_time"] =
          Encoder.encode(fromDate.getDate() + " 00:00:00");
      requestData["to_date_time"] =
          Encoder.encode(toDate.getDate() + " 23:59:59");
    }
    if (service != null) {
      requestData["service_id"] = Encoder.encode(service.id);
    }
    if (operator != null) {
      requestData["operator_id"] = Encoder.encode(operator.id);
    }
    request(
      networkRequest.getSalesReport(requestData),
      (map) {
        SalesReportDataModel dataModel = SalesReportDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
