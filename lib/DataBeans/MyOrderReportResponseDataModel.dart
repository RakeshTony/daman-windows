import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class MyOrderReportResponseDataModel extends BaseDataModel {
  List<MyOrderReportDataModel> orderData = [];

  @override
  MyOrderReportResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.orderData = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => MyOrderReportDataModel.fromJson(e))
        .toList();
    return this;
  }
}

class MyOrderReportDataModel {
  int SNO;
  int id;
  String user_id;
  String user_name;
  int order_number;
  int total_qty;
  double total_amount;
  double net_amount;
  double commission;
  double collected_amount;
  double overdue_amount;
  String download_status;
  String created;
  String status;
  String remarks;
  String android_refferrenceid;

  MyOrderReportDataModel({
    this.SNO = 0,
    this.id = 0,
    this.user_id = "",
    this.user_name ="",
    this.order_number = 0,
    this.total_qty = 0,
    this.total_amount = 0.0,
    this.net_amount = 0.0,
    this.commission = 0.0,
    this.collected_amount = 0.0,
    this.overdue_amount = 0.0,
    this.download_status = "",
    this.created = "",
    this.status = "",
    this.remarks = "",
    this.android_refferrenceid = "",
  });

  factory MyOrderReportDataModel.fromJson(Map<String, dynamic> json) {
    return MyOrderReportDataModel(
      SNO: toInt(json["ORDERS_DATA"]["SNO"]),
      id: toInt(json["ORDERS_DATA"]["id"]),
      user_id: toString(json["ORDERS_DATA"]["user_id"]),
       user_name: toString(json["ORDERS_DATA"]["user_name"]),
      order_number: toInt(json["ORDERS_DATA"]["order_number"]),
      total_qty: toInt(json["ORDERS_DATA"]["total_qty"]),
      total_amount: toDouble(json["ORDERS_DATA"]["total_amount"]),
      net_amount: toDouble(json["ORDERS_DATA"]["net_amount"]),
      commission: toDouble(json["ORDERS_DATA"]["commission"]),
      collected_amount: toDouble(json["ORDERS_DATA"]["collected_amount"]),
      overdue_amount: toDouble(json["ORDERS_DATA"]["overdue_amount"]),
      download_status: toString(json["ORDERS_DATA"]["download_status"]),
      created: toString(json["ORDERS_DATA"]["created"]),
      status: toString(json["ORDERS_DATA"]["status"]),
      remarks: toString(json["ORDERS_DATA"]["remarks"]),
      android_refferrenceid: toString(json["ORDERS_DATA"]["android_refferrenceid"]),
    );
  }
}
