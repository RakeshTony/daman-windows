import 'dart:async';
import 'dart:collection';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import '../../../DataBeans/VoucherReprintResponseDataModel.dart';

class ViewModelVoucherReprint extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<VoucherReprintResponseDataModel>
      _responseStreamController = StreamController();

  Stream<VoucherReprintResponseDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestOrderPinsData(String orderNumber) {
    HashMap<String, dynamic> requestMap = HashMap();
    _validateDetails(orderNumber);
    requestMap["order_number"] = Encoder.encode(orderNumber);
    request(
      networkRequest.getOrderRequestPins(requestMap),
      (map) {
        VoucherReprintResponseDataModel dataModel =
            VoucherReprintResponseDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestVoucherReprintRequest(String ids, String orderNumber) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["ids"] = Encoder.encode(ids);
    request(
      networkRequest.makeRePrintRequest(requestMap),
      (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        if (dataModel.getStatus) {
          requestOrderPinsData(orderNumber);
        }
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  String _validateDetails(String pinNumber) {
    if (pinNumber.isEmpty)
      return "invalid number";
    else
      return "";
  }
}
