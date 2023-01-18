import 'dart:async';
import 'dart:collection';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_extensions.dart';

import '../../../../DataBeans/ReprintResponseDataModel.dart';

class ViewModelTransaction extends BaseViewModel {

  List<WalletStatementDataModel> data =
      List<WalletStatementDataModel>.empty(growable: true);

  final StreamController<List<WalletStatementDataModel>>
      _responseStreamController = StreamController();

  Stream<List<WalletStatementDataModel>> get responseStream =>
      _responseStreamController.stream;

  final StreamController<ReprintResponseDataModel>
      _reprintResponseStreamController = StreamController();

  Stream<ReprintResponseDataModel> get reprintResponseStream =>
      _reprintResponseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    _reprintResponseStreamController.close();
    super.disposeStream();
  }

  void requestWalletStatements(
    DateTime fromDate,
    DateTime toDate,
    String mainType,
    String number,
    String txnId, {
    String considerAs = "",
    int offset = 0,
    String type = "",
    Function(bool, bool)? callBack,
  }) {
    var requestData = HashMap<String, dynamic>();
    requestData["consider_as"] = Encoder.encode(considerAs); // Cr  Dr
    requestData["from_date_time"] =
        Encoder.encode(fromDate.getDate() + " 00:00:00");
    requestData["to_date_time"] =
        Encoder.encode(toDate.getDate() + " 23:59:59");
    requestData["offset"] = Encoder.encode(offset.toString());
    requestData["type"] = Encoder.encode(mainType);
    requestData["subscriber"] = Encoder.encode(number);
    requestData["transaction_id"] =
        Encoder.encode(txnId); // recharge , transfer ,  etc.
    // requestData.clear();
    request(
      networkRequest.getWalletStatements(requestData),
      (map) {
        WalletStatementResponseDataModel dataModel =
            WalletStatementResponseDataModel();
        dataModel.parseData(map);
        if (offset == 0) {
          data.clear();
        }
        data.addAll(dataModel.statements);
        _responseStreamController.sink.add(data);
        if (callBack != null) callBack(false, dataModel.statements.isNotEmpty);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestReprint(String id) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["id"] = Encoder.encode(id);
    request(
      networkRequest.getTransactionReprintData(requestMap),
      (map) {
        ReprintResponseDataModel dataModel = ReprintResponseDataModel();
        dataModel.parseData(map);
        _reprintResponseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
      isResponseStatus: true,
    );
  }

}
