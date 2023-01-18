import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_settings.dart';

class ViewModelPinLocalStock extends BaseViewModel {
  final StreamController<List<WalletStatementDataModel>>
      _responseStreamController = StreamController();

  Stream<List<WalletStatementDataModel>> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestPinSettlementEnquiry() async {
    HashMap<String, dynamic> requestMap = HashMap();
    //requestMap["order_number"] = Encoder.encode("7973843197");
    await request(
      networkRequest.doPinSettlement(requestMap),
      (map) {

      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

}
