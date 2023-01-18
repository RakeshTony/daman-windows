import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class DefaultBranchDataModel extends BaseDataModel {
  List<DefaultBranch> data = [];

  @override
  DefaultBranchDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this.data = list.map((e) => DefaultBranch.fromJson(e)).toList();
    return this;
  }
}

class DefaultBranch {
  String id;
  String branchCode;
  String branchAddress;

  DefaultBranch({
    this.id = "",
    this.branchCode = "",
    this.branchAddress = "",
  });

  factory DefaultBranch.fromJson(Map<String, dynamic> json) {
    return DefaultBranch(
      id: toString(json["id"]),
      branchCode: toString(json["branch_code"]),
      branchAddress: toString(json["branch_address"]),
    );
  }
}
