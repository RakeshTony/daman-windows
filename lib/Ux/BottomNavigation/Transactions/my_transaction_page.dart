import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_transaction.dart';

import '../../../Routes/routes.dart';
import '../../../Utils/app_decorations.dart';
import '../../Dialog/dialog_success.dart';

class MyTransactionPage extends StatelessWidget {
  DateTime fromDateTime;
  DateTime toDateTime;
  String type;
  String number;
  String txnID;

  MyTransactionPage(
      {required this.fromDateTime,
      required this.toDateTime,
      required this.type,
      required this.number,
      required this.txnID});

  @override
  Widget build(BuildContext context) {
    return MyTransactionBody(
      fromDateTime: fromDateTime,
      toDateTime: toDateTime,
      type: type,
      number: number,
      txnID: txnID,
    );
  }
}

class MyTransactionBody extends StatefulWidget {
  DateTime fromDateTime;
  DateTime toDateTime;
  String type;
  String number;
  String txnID;

  MyTransactionBody(
      {required this.fromDateTime,
      required this.toDateTime,
      required this.type,
      required this.number,
      required this.txnID});

  @override
  State<StatefulWidget> createState() => _MyTransactionBodyState();
}

class _MyTransactionBodyState
    extends BasePageState<MyTransactionBody, ViewModelTransaction> {
  var wallet = HiveBoxes.getBalanceWallet();
  int page = 0;
  bool isLoading = false;
  bool isLoadMore = true;

  @override
  void initState() {
    super.initState();
    viewModel.reprintResponseStream.listen((event) {
      if (mounted) {
        var message = event.getMessage;
        var data = event.getMessage;
        if (data.isNotEmpty) {
          var args = HashMap<String, dynamic>();
          args["status"] = event.reprintData;
          Navigator.pushNamed(
            context,
            PageRoutes.reprintPage,
            arguments: args,
          );
        } else {
          var dialog = DialogSuccess(
              title: "Recharge Failed",
              message: message,
              actionText: "Go Back",
              isCancelable: false,
              isErrorIcon: true,
              onActionTap: () {
                Navigator.pop(context);
              });
          showDialog(context: context, builder: (context) => dialog);
        }
      }
    });
    _loadData(0);
    //viewModel.requestParams("13");
  }

  _loadData(int offset) {
    page = offset;
    isLoading = true;
    viewModel.requestWalletStatements(
        widget.fromDateTime,
        widget.toDateTime,
        (widget.type == 'Select Main Type' || widget.type == 'All')
            ? ""
            : widget.type,
        widget.number,
        widget.txnID,
        offset: page, callBack: (isLoading, isLoadMore) {
      this.isLoading = isLoading;
      this.isLoadMore = isLoadMore;
    });
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
        // appBar: AppBar(),
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: kTitleBackground,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.myTransactions!,
                      style: TextStyle(
                          fontSize: 14,
                          color: kWhiteColor,
                          fontWeight: RFontWeight.LIGHT,
                          fontFamily: RFontFamily.POPPINS),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: viewModel.responseStream,
                  initialData:
                      List<WalletStatementDataModel>.empty(growable: true),
                  builder: (context,
                      AsyncSnapshot<List<WalletStatementDataModel>> snapshot) {
                    var items =
                        List<WalletStatementDataModel>.empty(growable: true);
                    if (snapshot.hasData && snapshot.data != null) {
                      var data = snapshot.data ?? [];
                      items.addAll(data);
                    }
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (isLoadMore &&
                            !isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          print("LOAD MORE");
                          _loadData(page + 1);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _itemTransaction(items[index], index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemTransaction(WalletStatementDataModel data, int index) {
    var isCrDr = data.type.equalsIgnoreCases(["transfer", "received"]);
    var url = isCrDr ? data.consider : data.operatorLogo;
    var isCredit = data.consider.equalsIgnoreCase("cr");
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          color: index % 2 == 0 ? kWhiteColor : kColor1,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.opening! +
                    " : ${wallet?.currencySign ?? ''} ${data.openBal.toSeparatorFormat()}",
                style: TextStyle(
                    fontSize: 11,
                    color: kMainTextColor,
                    fontWeight: RFontWeight.LIGHT),
              ),
              Text(
                AppLocalizations.of(context)!.closingBalance! +
                    " : ${wallet?.currencySign ?? ''} ${data.closeBal.toSeparatorFormat()}",
                style: TextStyle(
                    fontSize: 11,
                    color: kMainTextColor,
                    fontWeight: RFontWeight.LIGHT),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppImage(
                url,
                52,
                backgroundColor: kMainColor,
                defaultImage: DEFAULT_OPERATOR,
                isUrl: !isCrDr,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: kMainTextColor,
                          fontWeight: RFontWeight.LIGHT,
                        ),
                      ),
                      Text(
                        data.narration,
                        style: TextStyle(
                          fontSize: 11,
                          color: kTextColor4,
                          fontWeight: RFontWeight.LIGHT,
                        ),
                      ),
                      Text(
                        data.created,
                        style: TextStyle(
                          fontSize: 11,
                          color: kTextColor4,
                          fontWeight: RFontWeight.LIGHT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isCredit ? '+' : '-'} ${wallet?.currencySign ?? ''} ${data.amount.toSeparatorFormat()}",
                    style: TextStyle(
                        fontSize: 12,
                        color: isCredit ? kTextAmountCR : kTextAmountDR,
                        fontWeight: RFontWeight.MEDIUM),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Visibility(
                    visible: data.type.contains("Recharge") ? true : false,
                    child: InkWell(
                      onTap: () {
                        viewModel.requestReprint(data.transaction);
                      },
                      child: Image.asset(
                        IC_PRINTER,
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Visibility(
                    visible: data.type.contains("IssueEpin") ? true : false,
                    child: InkWell(
                      onTap: () {
                        //viewModel.requestrePrint(data.transaction);
                        Navigator.pushNamed(
                            context, PageRoutes.voucherReprintPage,
                            arguments: {
                              "orderNumber": data.orderNumber,
                            });
                      },
                      child: Image.asset(
                        IC_PRINTER,
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
