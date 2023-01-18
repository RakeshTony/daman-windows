import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_request_key.dart';

class BulkTopUpResponseDataModel extends BaseDataModel {
  List<TopUpService> services = [];

  @override
  BulkTopUpResponseDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    if (result.containsKey(AppRequestKey.RESPONSE_DATA)) {
      this.services = toList(result[AppRequestKey.RESPONSE_DATA])
          .map((e) => TopUpService.fromJson(e))
          .toList();
    }
    return this;
  }

  List<TopUpDenomination> getDenomination() {
    var data = List<TopUpDenomination>.empty(growable: true);
    services.forEach((service) {
      // AppLog.e("SERVICE", service.serviceId);
      service.operators.forEach((operator) {
        // AppLog.e("SERVICE OPERATOR", operator.operatorId);
        operator.denominations.forEach((denomination) {
          data.add(denomination);
        });
      });
    });
    return data;
  }
}

class TopUpService {
  List<TopUpOperator> operators;
  String serviceId;

  TopUpService({this.operators = const [], this.serviceId = ""});

  factory TopUpService.fromJson(Map<String, dynamic> json) {
    return TopUpService(
      operators: toList(json['operators'])
          .map((e) => TopUpOperator.fromJson(e))
          .toList(),
      serviceId: toString(json['service_id']),
    );
  }
}

class TopUpOperator {
  String operatorId;
  List<TopUpDenomination> denominations;

  TopUpOperator({this.operatorId = "", this.denominations = const []});

  factory TopUpOperator.fromJson(Map<String, dynamic> json) {
    return TopUpOperator(
      operatorId: toString(json['operator_id']),
      denominations: toList(json['denominations'])
          .map((e) => TopUpDenomination.fromJson(e))
          .toList(),
    );
  }
}

class TopUpDenomination {
  String denominationId;
  String denominationCategoryId;
  String mobile;
  double recAmount;
  double orgAmount;
  double amount;
  String responseStatus;
  bool response;
  String mnoResponse;
  String operatorsId;
  String adminId;
  String txnId;
  String status;
  String printData;
  List<ExtraDetails> extraDetails;

  TopUpDenomination({
    this.denominationId = "",
    this.denominationCategoryId = "",
    this.mobile = "",
    this.orgAmount = 0.0,
    this.amount = 0.0,
    this.recAmount = 0.0,
    this.responseStatus = "",
    this.response = false,
    this.mnoResponse = "",
    this.operatorsId = "",
    this.adminId = "",
    this.txnId = "",
    this.status = "",
    this.printData = "",
    this.extraDetails = const [],
  });

  factory TopUpDenomination.fromJson(Map<String, dynamic> json) {
    return TopUpDenomination(
      denominationId: toString(json['denomination_id']),
      denominationCategoryId: toString(json['denomination_category_id']),
      mobile: toString(json['mobile']),
      recAmount: toDouble(json['rec_amount']),
      orgAmount: toDouble(json['org_amount']),
      amount: toDouble(json['amount']),
      responseStatus: toString(json['RSTATUS']),
      response: toBoolean(json['RESPONSE']),
      mnoResponse: toString(json['MNO_RESP']),
      operatorsId: toString(json['OPERATORS_ID']),
      printData: toString(json['PRINT_DATA']),
      adminId: toString(json['ADMIN_ID']),
      txnId: toString(json['TXN_ID']),
      status: toString(json['STATUS']),
      extraDetails: toList(json['EXTRA_DETAILS'])
          .map((e) => ExtraDetails.fromJson(e))
          .toList(),
    );
  }
}

class ExtraDetails {
  String key;
  String value;
  bool isBold;

  ExtraDetails({
    this.key = "",
    this.value = "",
    this.isBold = false,
  });

  factory ExtraDetails.fromJson(Map<String, dynamic> json) {
    return ExtraDetails(
      key: toString(json['key']),
      value: toString(json['value']),
      isBold: toIntBoolean(json['is_bold']),
    );
  }
}
