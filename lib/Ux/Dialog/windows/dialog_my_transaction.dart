import 'dart:collection';

import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_transaction.dart';
import 'package:flutter/material.dart';

import '../../../Locale/locales.dart';
import '../../../Routes/routes.dart';
import '../../Voucher/voucher_reprint.dart';
import '../dialog_success.dart';
import 'filter/filter_custom_range_page.dart';

class DialogMyTransactions extends StatefulWidget {
  @override
  State<DialogMyTransactions> createState() => _DialogMyTransactionsState();
}

class _DialogMyTransactionsState
    extends BasePageState<DialogMyTransactions, ViewModelTransaction> {
  var wallet = HiveBoxes.getBalanceWallet();
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();
  String type = "";
  String number = "";
  String txnID = "";
  int page = 0;
  bool isLoading = false;
  bool isLoadMore = true;

  TextEditingController _fromDateController = TextEditingController();
  FocusNode _fromDateNode = FocusNode();

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
    _loadData(page);
  }

  _loadData(int offset) {
    page = offset;
    isLoading = true;
    viewModel.requestWalletStatements(
        fromDateTime,
        toDateTime,
        (type == 'Select Main Type' || type == 'All') ? "" : type,
        number,
        txnID,
        offset: page, callBack: (isLoading, isLoadMore) {
      this.isLoading = isLoading;
      this.isLoadMore = isLoadMore;
    });
  }

  @override
  Widget build(BuildContext context) {
    _fromDateController.text =
        "${fromDateTime.getDate()} - ${toDateTime.getDate()}";
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 480,
            maxHeight: 480,
            maxWidth: 720,
            minWidth: 720,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: kColor_1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: Column(
            children: [
             Container(
                 decoration: BoxDecoration(
                   color: kMainButtonColor,
                   borderRadius: BorderRadius.all(Radius.circular(8)),
                 ),
                 padding:
                 EdgeInsets.symmetric(horizontal: 16, vertical: 5),

               child:Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                     AppLocalizations.of(context)!.myTransactions!,
                     style: title(),
                   ),
                   Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       SizedBox(
                         width: 180,
                         child: GestureDetector(
                           onTap: () async {},
                           child: AbsorbPointer(
                             child: InputFieldWidget.text(
                               "From - To Date",
                               margin: EdgeInsets.only(
                                 left: 16,
                               ),
                               textEditingController: _fromDateController,
                               focusNode: _fromDateNode,
                               readOnly: true,
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       InkWell(
                         onTap: () async {
                           var dialog =
                           DialogCustomRangeFilter(fromDateTime, toDateTime);
                           var args = await showDialog(
                             context: context,
                             builder: (context) => dialog,
                           );
                           if (args != null) {
                             var data = args as Map<String, dynamic>;
                             fromDateTime = data["from_date_time"] as DateTime;
                             toDateTime = data["to_date_time"] as DateTime;
                             type = data["type"] as String;
                             number = data["number"] as String;
                             txnID = data["transaction_id"] as String;
                             setState(() {});
                             page = 0;
                             _loadData(page);
                           }
                         },
                         child: Image.asset(
                           IC_FILTER_WHITE,
                           width: 18,
                           height: 18,
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 16),
                         child: InkWell(
                           child: Icon(Icons.close, color: kWhiteColor),
                           onTap: () {
                             Navigator.pop(context);
                           },
                         ),
                       ),
                     ],
                   )
                 ],
               )
             ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: kOTPBackground,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Type",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Narration",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Amount",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Opening",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Closing",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Date",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Action",
                                style: title_1(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: viewModel.responseStream,
                          initialData: List<WalletStatementDataModel>.empty(
                              growable: true),
                          builder: (context,
                              AsyncSnapshot<List<WalletStatementDataModel>>
                                  snapshot) {
                            var items = List<WalletStatementDataModel>.empty(
                                growable: true);
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemTransaction(WalletStatementDataModel data, int index) {
    var isCrDr = data.type.equalsIgnoreCases(["transfer", "received"]);
    var url = isCrDr ? data.consider : data.operatorLogo;
    var isCredit = data.consider.equalsIgnoreCase("cr");
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "${data.type}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${data.narration}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${isCredit ? '+' : '-'} ${wallet?.currencySign ?? ''} ${data.amount.toSeparatorFormat()}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${wallet?.currencySign ?? ''} ${data.openBal.toSeparatorFormat()}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${wallet?.currencySign ?? ''} ${data.closeBal.toSeparatorFormat()}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "${data.created}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Visibility(
              visible: data.type.contains("Recharge") ||
                      data.type.contains("IssueEpin")
                  ? true
                  : false,
              child: InkWell(
                onTap: () {
                  if (data.type.contains("IssueEpin")) {
                    var dialog = VoucherReprintPage(orderNumber: data.orderNumber,);
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (data.type.contains("Recharge")) {
                    viewModel.requestReprint(data.transaction);
                  }
                },
                child: Image.asset(
                  IC_WIN_PRINT,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle title() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 13,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }

  TextStyle title_1() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 12,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }

  TextStyle description_1() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 11,
        fontWeight: RFontWeight.REGULAR,
        fontFamily: RFontFamily.POPPINS);
  }
}
