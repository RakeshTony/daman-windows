import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class SalesReportDataModel extends BaseDataModel {
  late SalesReportData report;

  @override
  SalesReportDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.report =
        SalesReportData.fromJson(toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class SalesReportData {
  String total;
  String lockFund;
  String totalFund;
  String totalSales;
  String totalProfit;
  String totalRefund;
  String openingBalance;
  String closingBalance;
  String dueCredits;
  List<SalesReportOperatorData> operatorRecords;

  SalesReportData({
    this.total = "",
    this.lockFund = "",
    this.totalFund = "",
    this.totalSales = "",
    this.totalProfit = "",
    this.totalRefund = "",
    this.openingBalance = "",
    this.closingBalance = "",
    this.dueCredits = "",
    this.operatorRecords = const [],
  });

  factory SalesReportData.fromJson(Map<String, dynamic> json) {
    return SalesReportData(
      total: toString(json['TOTAL']),
      lockFund: toString(json['LOCK_FUND']),
      totalFund: toString(json['TOTAL_FUND']),
      totalSales: toString(json['TOTAL_SALES']),
      totalProfit: toString(json['TOTAL_PROFIT']),
      totalRefund: toString(json['TOTAL_REFUND']),
      openingBalance: toString(json['START_BAL']),
      closingBalance: toString(json['CLOSE_BAL']),
      dueCredits: toString(json['DUE_CREDITS']),
      operatorRecords: toList(json['OP_RECORD']).map((e) => SalesReportOperatorData.fromJson(e)).toList(),
    );
  }
}

class SalesReportOperatorData {
  String id;
  String title;
  String logo;
  String profit;
  String sales;
  String salesCount;

  SalesReportOperatorData({
    this.id = "",
    this.title = "",
    this.logo = "",
    this.profit = "",
    this.sales = "",
    this.salesCount = "",
  });

  factory SalesReportOperatorData.fromJson(Map<String, dynamic> json) {
    return SalesReportOperatorData(
      id: toString(json['id']),
      title: toString(json['title']),
      logo: toString(json['logo']),
      profit: toString(json['Profit']),
      sales: toString(json['Sales']),
      salesCount: toString(json['Sales_Count']),
    );
  }
}
