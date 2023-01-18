import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class DefaultBankDataModel extends BaseDataModel {
  List<DefaultBank> data = [];

  @override
  DefaultBankDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this.data = list.map((e) => DefaultBank.fromJson(e)).toList();
    return this;
  }
}

class DefaultBank {
  String id;
  String bankName;
  String description;
  String logo;

  DefaultBank({
    this.id = "",
    this.bankName = "",
    this.description = "",
    this.logo = "",
  });

  factory DefaultBank.fromJson(Map<String, dynamic> json) {
    return DefaultBank(
      id: toString(json["id"]),
      bankName: toString(json["bank_name"]),
      description: toString(json["description"]),
      logo: toString(json["logo"]),
    );
  }
}
