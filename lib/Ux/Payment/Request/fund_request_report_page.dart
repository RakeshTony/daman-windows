import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/FundRequestReportResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';

import '../../../Routes/routes.dart';
import '../../../Utils/app_decorations.dart';
import '../../../Utils/app_icons.dart';
import 'ViewModel/view_model_fund_request_report.dart';

class FundRequestReportPage extends StatelessWidget {
  String isCredit , paymentType;

  FundRequestReportPage(this.isCredit,this.paymentType);
  @override
  Widget build(BuildContext context) {
    return FundRequestReportBody(isCredit,paymentType);
  }
}

class FundRequestReportBody extends StatefulWidget {
  String isCredit,paymentType ;
  FundRequestReportBody(this.isCredit,this.paymentType);
  @override
  State<StatefulWidget> createState() => _FundRequestReportBodyState();
}

class _FundRequestReportBodyState
    extends BasePageState<FundRequestReportBody, ViewModelFundRequestReport> {
  var wallet = HiveBoxes.getBalanceWallet();
  DateTime? toDate;
  DateTime? fromDate;
  String? status = "All";
  @override
  void initState() {
    super.initState();
    _fetchReport();
  }
  _fetchReport() {
    viewModel.requestFundRequestReport(widget.isCredit,widget.paymentType, fromDate, toDate, status!);
  }
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
        decoration: decorationBackground,
        child: Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kTitleBackground,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.paymentType=="BankCard"?"Bank Cards": widget.isCredit=="1"?AppLocalizations.of(context)!.creditReport!:AppLocalizations.of(context)!.walletTopupReport!,
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                  InkWell(
                    onTap: () async {
                      var args = Map<String, dynamic>();
                      args["from_date_time"] = fromDate;
                      args["to_date_time"] = toDate;
                      args["status"] = status;
                      var result = await Navigator.pushNamed(
                          context, PageRoutes.walletRequestFilter,
                          arguments: args);
                      if (result != null) {
                        var success = result as Map<String, dynamic>;
                        fromDate = success["from"];
                        toDate = success["to"];
                        status = success["status"];
                        _fetchReport();
                      }
                    },
                    child: Image.asset(
                      IC_FILTER_WHITE,
                      width: 24,
                      height: 24,
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
                initialData: List<FundRequestDataModel>.empty(growable: true),
                builder: (context,
                    AsyncSnapshot<List<FundRequestDataModel>> snapshot) {
                  var items = List<FundRequestDataModel>.empty(growable: true);
                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data ?? [];
                    for (FundRequestDataModel item in data) {
                      items.add(item);
                      if (items.length == 5) break;
                    }
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _itemTransaction(items[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ),);
  }

  _itemTransaction(FundRequestDataModel data) {
    //var isRequestStatus = data.status.equalsIgnoreCases(["PENDING", "APPROVED","REJECTED"]);
    var mode = data.userBanker.accountName.isEmpty ? "CASH" : "BANK";
    return Container(
      padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getRow(AppLocalizations.of(context)!.requestedBy!+" : ", "${data.user.name}"),
          _getRow(AppLocalizations.of(context)!.amount!+" : ", "${wallet?.currencySign ?? ""}${data.fundRequest.amount}"),
          _getRow(AppLocalizations.of(context)!.requestedDate!+" : ", "${data.fundRequest.fundDateTime}"),
          widget.paymentType=="BankCard"?_getRow("Payment : ", "Bank Card"):widget.isCredit=="0"?_getRow("Payment : ", mode):Container(),
          widget.isCredit=="0"?"${data.userBanker.accountName}"==""?Container():_getRow("Bank Name : ", "${data.userBanker.accountName}"):Container(),
          _getRow(AppLocalizations.of(context)!.status!+" : ", "${data.fundRequest.status}", color: getStatusColor(data.fundRequest.status)),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "APPROVED":
        return kColorApprove;
      case "PENDING":
        return kColorPending;
      case "REJECTED":
        return kColorReject;
      default:
        return kMainTextColor;
    }
  }

  _getRow(String label, String value, {Color color = kMainTextColor}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label",
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 12,
                fontWeight: RFontWeight.REGULAR,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "$value",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: RFontWeight.REGULAR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
