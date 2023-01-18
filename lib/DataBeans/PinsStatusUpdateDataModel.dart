import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class PinsStatusUpdateDataModel extends BaseDataModel {
  List<PinsId> data = [];

  @override
  PinsStatusUpdateDataModel parseData(result) {
    this.statusCode = result[AppRequestKey.RESPONSE_CODE] as int;
    this.status = result[AppRequestKey.RESPONSE] as bool;
    this.message = result[AppRequestKey.RESPONSE_MSG].toString();
    this.data =
        toList(result["RESPONSE_PINS"]).map((e) => PinsId.fromJson(e)).toList();
    return this;
  }
}

class PinsId {
  String id;
  PinsId({
    this.id = "",
  });
  factory PinsId.fromJson(String json) {
    return PinsId(
      id: toString(json),
    );
  }
}
