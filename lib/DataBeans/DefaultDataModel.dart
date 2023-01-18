import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_request_key.dart';

class DefaultDataModel extends BaseDataModel {
  @override
  DefaultDataModel parseData(result) {
    this.statusCode = result[AppRequestKey.RESPONSE_CODE] as int;
    this.status = result[AppRequestKey.RESPONSE] as bool;
    this.message = result[AppRequestKey.RESPONSE_MSG].toString();
    return this;
  }
}