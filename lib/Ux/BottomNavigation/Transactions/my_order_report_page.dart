import 'package:daman/Database/models/offline_pin_stock.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import '../../../DataBeans/MyOrderReportResponseDataModel.dart';
import '../../../Routes/routes.dart';
import '../../../Utils/app_decorations.dart';
import '../../Dialog/dialog_success.dart';
import 'ViewModel/view_model_my_order_report.dart';

class MyOrderReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyOrderReportBody();
  }
}

class MyOrderReportBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyOrderReportBodyState();
}

class _MyOrderReportBodyState
    extends BasePageState<MyOrderReportBody, ViewModelMyOrderReport> {
  var wallet = HiveBoxes.getBalanceWallet();
  var downloadOrderId = "";

  @override
  void initState() {
    super.initState();
    viewModel.responseStreamSettlement.listen((event) async {
      if (event.vouchers.isEmpty) {
        if (mounted) {
          var dialog = DialogSuccess(
              title: "Success",
              message: event.getMessage,
              actionText: "Ok",
              isCancelable: false,
              onActionTap: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(PageRoutes.bottomNavigation),
                );
              });
          showDialog(context: context, builder: (context) => dialog);
        }
      } else {
        var mDownloadPins =
            event.vouchers.map((e) => e.toOfflinePinStock).toList();
        await HiveBoxes.getOfflinePinStock().addAll(mDownloadPins);
        if (mounted) {
          var dialog = DialogSuccess(
              title: "Success",
              message: event.getMessage,
              actionText: "Ok",
              isCancelable: false,
              onActionTap: () {
                viewModel.requestUpdatePinDownloadStatus(
                    downloadOrderId, "Installed"); //Installed Approved
                viewModel.requestWallet();
              });
          showDialog(context: context, builder: (context) => dialog);
        }
      }
    });
    viewModel.requestWallet();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                constraints: BoxConstraints(
                  minHeight: 480,
                  maxHeight: 480,
                  maxWidth: 820,
                  minWidth: 820,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kTitleBackground, width: 2)),
                child: Container(
                  child: Scaffold(
                    backgroundColor: kTransparentColor,
                    body: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: kWalletBackground,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "My Orders",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: kWhiteColor,
                                      fontWeight: RFontWeight.LIGHT,
                                      fontFamily: RFontFamily.POPPINS),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: InkWell(
                                    child: Icon(Icons.close,
                                        color: kWhiteColor),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: StreamBuilder(
                              stream: viewModel.responseStream,
                              initialData: List<MyOrderReportDataModel>.empty(
                                  growable: true),
                              builder: (context,
                                  AsyncSnapshot<List<MyOrderReportDataModel>>
                                      snapshot) {
                                var items = List<MyOrderReportDataModel>.empty(
                                    growable: true);
                                if (snapshot.hasData && snapshot.data != null) {
                                  var data = snapshot.data ?? [];
                                  for (MyOrderReportDataModel item in data) {
                                    items.add(item);
                                  }
                                }
                                AppLog.e("dataItems", items.toString());
                                return ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                    },
                                  ),
                                  child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) =>
                                        _itemTransaction(items[index]),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  _itemTransaction(MyOrderReportDataModel data) {
    return Container(
      padding: EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "User Name",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.user_name,
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Number",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.order_number.toString(),
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.total_amount.toString(),
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net Amount",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.net_amount.toString(),
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Toatal Qty",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.total_qty.toString(),
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.status,
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              Text(
                data.created,
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Download Pin",
                style: TextStyle(
                    color: kMainTextColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.MEDIUM,
                    fontSize: 14),
              ),
              (data.status.equalsIgnoreCase("A") &&
                      data.download_status.equalsIgnoreCase("Installed"))
                  ? Text(
                      data.download_status,
                      style: TextStyle(
                          color: kMainTextColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.MEDIUM,
                          fontSize: 14),
                    )
                  : InkWell(
                      onTap: () {
                        downloadOrderId = data.id.toString();
                        viewModel.requestUpdatePinDownloadStatus(
                            downloadOrderId, "Installed");
                        viewModel.requestPinSettlementEnquiry(
                            data.order_number.toString());
                      },
                      child: Container(
                        height: 32,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Download".toUpperCase(),
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 14,
                              fontWeight: RFontWeight.MEDIUM,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
