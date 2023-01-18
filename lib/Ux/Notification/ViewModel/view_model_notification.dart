import 'dart:async';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/CommissionResponseDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';

class ViewModelNotification extends BaseViewModel {
  final StreamController<List<CommissionOperatorData>>
      _commissionStreamController = StreamController();

  Stream<List<CommissionOperatorData>> get commissionStream =>
      _commissionStreamController.stream;

  @override
  void disposeStream() {
    _commissionStreamController.close();
    super.disposeStream();
  }

  void requestCommission() {
    request(
      networkRequest.getCommissionReport(),
      (map) {
        CommissionResponseDataModel dataModel = CommissionResponseDataModel();
        dataModel.parseData(map);
        _commissionStreamController.sink.add(dataModel.operators);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
