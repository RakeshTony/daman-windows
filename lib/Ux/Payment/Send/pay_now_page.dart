import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/UserWalletDetailsData.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Payment/Send/ViewModel/view_model_pay_now.dart';

import '../../../Utils/app_decorations.dart';

class PayNowPage extends StatelessWidget {
  UserData users;

  PayNowPage({required this.users});

  @override
  Widget build(BuildContext context) {
    return PayNowBody(
      users: users,
    );
  }
}

class PayNowBody extends StatefulWidget {
  UserData users;

  PayNowBody({required this.users});

  @override
  State<StatefulWidget> createState() => _PayNowBodyState();
}

class _PayNowBodyState extends BasePageState<PayNowBody, ViewModelPayNow> {
  var _wallet = HiveBoxes.getBalanceWallet();
  String isCreditType = "0"; //cash = "0", credit = "1"
  String user_wallet_balance = "";
  TextEditingController _amountController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  FocusNode _amountNode = FocusNode();
  FocusNode _remarkNode = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel.requestUserBalanceEnquiry(widget.users.id);

    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              Navigator.pop(context);
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);

    viewModel.balanceResponseStream.listen((map) {
      if (mounted) {
        setState(() => user_wallet_balance = '${map.balance.total}');
      }
    }, cancelOnError: false);
  }

  @override
  void dispose() {
    super.dispose();
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
            maxWidth: 720,
            minWidth: 720,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: Container(

            child: Container(
              child: ListView(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: AppImage(widget.users.icon, 65),
                    title: Text(
                      "${widget.users.name}",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "${widget.users.mobile}",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: RFontFamily.SOFIA_PRO,
                        fontWeight: RFontWeight.LIGHT,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              IC_WALLET,
                              width: 24,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${_wallet?.currencySign ?? ""} ' +
                                  user_wallet_balance,
                              style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: RFontWeight.REGULAR,
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                    ),
                  ),
                  InputFieldWidget.number(
                    "Amount",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _amountController,
                    focusNode: _amountNode,
                  ),
                  InputFieldWidget.text(
                    "Remark",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _remarkController,
                    focusNode: _remarkNode,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    text: "Pay Now",
                    margin: EdgeInsets.only(
                        left: 80, top: 16, bottom: 16, right: 80),
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    onPressed: () async {
                      var amount = _amountController.text.trim();
                      if (amount.isEmpty) {
                        AppAction.showGeneralErrorMessage(
                            context, "Please Enter amount");
                      } else {
                        var status = await Navigator.pushNamed(
                            context, PageRoutes.enterPin);
                        if (status == "SUCCESS") {
                          viewModel.requestPayNow(
                              _amountController,
                              _remarkController,
                              widget.users.walletId,
                              isCreditType);
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Recent Transfer",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14,
                        fontFamily: RFontFamily.POPPINS,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable:
                          HiveBoxes.getRecentTransactions().listenable(),
                      builder: (context, Box<RecentTransaction> data, _) {
                        List<RecentTransaction> items = data.values
                            .where((data) => data.type.contains("Transfer"))
                            .take(5)
                            .toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) =>
                              _itemTransaction(items[index]),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _itemTransaction(RecentTransaction data) {
    var isCrDr = data.type.equalsIgnoreCases(["transfer", "received"]);
    var url = isCrDr ? data.consider : data.operatorLogo;
    var isCredit = data.consider.equalsIgnoreCase("cr");
    return Container(
      padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
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
              Flexible(
                child: Text(
                  data.narration,
                  //textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: isCredit ? kTextAmountCR : kTextAmountDR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${isCredit ? '+' : '-'} ${_wallet?.currencySign ?? ''}${data.amount.toSeparatorFormat()}",
                    style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.MEDIUM,
                        fontSize: 14),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.created.getDateFormat(),
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 14),
                ),
                Flexible(
                  child: Text(
                    "Balance: ${_wallet?.currencySign ?? ""}${data.closeBal.toSeparatorFormat()}",
                    style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
