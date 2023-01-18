import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/balance.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/firebase_node.dart';
import 'package:daman/Ux/Wallet/ViewModel/view_model_wallet.dart';
import 'package:daman/main.dart';

import '../../DataBeans/BalanceDataModel.dart';
import '../../DataBeans/LoginDataModel.dart';
import '../../Utils/app_decorations.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WalletBody();
  }
}

class WalletBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends BasePageState<WalletBody, ViewModelWallet> {
  var wallet = HiveBoxes.getBalanceWallet();

  @override
  void initState() {
    super.initState();
    // viewModel.requestBalanceEnquiry();
/*
    databaseReference
        .child(FirebaseNode.USERS)
        .child(mPreference.value.userData.firebaseId)
        .child(FirebaseNode.WALLET)
        .onValue
        .listen((data) {
      if (data.snapshot.value is Map) {
        var walletData = BalanceData.fromJson(toMaps(data.snapshot.value));
        final box = HiveBoxes.getBalance();
        box.put("BAL", walletData.toBalance);
        AppLog.e("USERS WALLET", data.snapshot.value ?? "");
      }
    });
*/
    viewModel.requestWallet();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
        decoration: decorationBackground,
        child: Scaffold(
      appBar: AppBarCommonWidget(
        title: "Wallet",
        isShowBalance: false,
        isShowUser: false,
      ),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kTitleBackground,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.wallet!,
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    IC_WALLET,
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                              valueListenable:
                                  HiveBoxes.getBalance().listenable(),
                              builder: (context, Box<Balance> data, _) {
                                var mWallet = data.values.isNotEmpty
                                    ? data.values.first
                                    : null;
                                return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!.currentBalance!,
                                        style: TextStyle(
                                          color: kWhiteColor,
                                          fontSize: 14,
                                          fontWeight: RFontWeight.REGULAR,
                                        ),
                                      ),
                                      SizedBox(width:10),
                                      Text(
                                        "${mWallet?.currencySign ?? ""} ${(mWallet?.balance ?? 0.0).toSeparatorFormat()}",
                                        style: TextStyle(
                                          color: kWhiteColor,
                                          fontSize: 14,
                                          fontWeight: RFontWeight.REGULAR,
                                        ),
                                      ),
                                    ]);
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          ValueListenableBuilder(
                              valueListenable:
                                  HiveBoxes.getBalance().listenable(),
                              builder: (context, Box<Balance> data, _) {
                                var mWallet = data.values.isNotEmpty
                                    ? data.values.first
                                    : null;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!.dueCredit!,
                                        style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 14,
                                            fontWeight: RFontWeight.REGULAR),
                                      ),
                                      SizedBox(width:10),
                                      Text(
                                        "${mWallet?.currencySign ?? ""} ${(mWallet?.dueCredits ?? 0.0).toSeparatorFormat()}",
                                        style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 14,
                                            fontWeight: RFontWeight.REGULAR),
                                      )
                                    ]);
                              })
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        height: 36,
                        child: CustomButton(
                          text:  AppLocalizations.of(context)!.refillBalance!,
                          radius: BorderRadius.all(Radius.circular(18.0)),
                          padding: 0,
                          style: TextStyle(
                              fontFamily: RFontFamily.POPPINS,
                              fontWeight: RFontWeight.LIGHT,
                              fontSize: 14,
                              color: kWhiteColor),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, PageRoutes.walletTopUp);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context)!.recentTransactions!,
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 18,
                    fontWeight: RFontWeight.LIGHT),
              ),
            ),
            SizedBox(
              height: 10,
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
                    for (WalletStatementDataModel item in data) {
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

  _itemTransaction(WalletStatementDataModel data) {
    var isCrDr = data.type.equalsIgnoreCases(["transfer", "received"]);
    var url = isCrDr ? data.consider : data.operatorLogo;
    var isCredit = data.consider.equalsIgnoreCase("cr");
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isCredit ? kTextAmountCR : kTextAmountDR,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    isCredit ? "CR":"DR",
                    style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.MEDIUM,
                        fontSize: 14),
                  ),
                ),
              ),
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
                /*decoration: BoxDecoration(
                  color: isCredit ? kTextAmountCR : kTextAmountDR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),*/
                child: Center(
                  child: Text(
                    "${isCredit ? '+' : '-'} ${wallet?.currencySign ?? ''} ${data.amount.toSeparatorFormat()}",
                    style: TextStyle(
                        color: isCredit ? kTextAmountCR : kTextAmountDR,
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
                    //Opening: ${wallet?.currencySign ?? ""}${data.openBal.toSeparatorFormat()}\n
                    "Closing: ${wallet?.currencySign ?? ""}${data.closeBal.toSeparatorFormat()}",
                    style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        ));
  }
}
