import 'dart:async';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';

class ViewModelReports extends BaseViewModel {
  final StreamController<List<WalletStatementDataModel>>
      _usersStreamController = StreamController();

  Stream<List<WalletStatementDataModel>> get userStream =>
      _usersStreamController.stream;

  @override
  void disposeStream() {
    _usersStreamController.close();
    super.disposeStream();
  }

  void requestMyUser() {
    request(
      networkRequest.getMyUsers(),
      (map) {
        WalletStatementResponseDataModel dataModel =
            WalletStatementResponseDataModel();
        dataModel.parseData(map);
        _usersStreamController.sink.add(dataModel.statements);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
