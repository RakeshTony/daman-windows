import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Ux/Wallet/ViewModel/view_model_wallet.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Database/models/balance.dart';
import '../../../Utils/app_decorations.dart';

class DialogWallet extends StatefulWidget {
  @override
  State<DialogWallet> createState() => _DialogWalletState();
}

class _DialogWalletState extends BasePageState<DialogWallet, ViewModelWallet> {
  var wallet = HiveBoxes.getBalanceWallet();

  @override
  void initState() {
    super.initState();
    viewModel.requestBalanceEnquiry();
    viewModel.requestWallet();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
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
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.wallet!,
                    style: title(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      child: Icon(Icons.close, color: kWhiteColor),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder(
                      valueListenable: HiveBoxes.getBalance().listenable(),
                      builder: (context, Box<Balance> data, _) {
                        var mWallet =
                            data.values.isNotEmpty ? data.values.first : null;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildAmountWidget(
                                "${mWallet?.balance}", locale.currentBalance!),
                            _buildAmountWidget(
                                "${mWallet?.dueCredits}", locale.dueCredit!),
                          ],
                        );
                      }),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.walletTopUp);
                    },
                    child: Container(
                      decoration: decoration,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        locale.refillBalance!,
                        style: title(),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.recentTransactions!,
                    style: title_1(),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: kOTPBackground,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kBorderColorActive,
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
                              flex: 5,
                              child: Text(
                                "Narration",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                locale.amount!,
                                style: title_1(),
                              ),
                            ),
                            /*Expanded(
                              flex: 2,
                              child: Text(
                                locale.opening!,
                                style: title_1(),
                              ),
                            ),*/
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Date",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                locale.closing!,
                                style: title_1(),
                              ),
                            ),

                            /*Expanded(
                              flex: 1,
                              child: Text(
                                "Action",
                                style: title_1(),
                              ),
                            ),*/
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
                              for (WalletStatementDataModel item in data) {
                                items.add(item);
                                // if (items.length == 5) break;
                              }
                            }
                            return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) =>
                                  _itemTransaction(items[index]),
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

  BoxDecoration decoration = BoxDecoration(
    gradient: BUTTON_GRADIENT,
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  Widget _buildAmountWidget(String amount, String label) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${wallet?.currencySign} $amount",
            style: title().copyWith(fontSize: 24),
          ),
          Text(
            "$label",
            style: description_1().copyWith(color: kWhiteColor),
          ),
        ],
      ),
    );
  }

  Widget _itemTransaction(WalletStatementDataModel data) {
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
            flex: 5,
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
            flex: 3,
            child: Text(
              "${data.created}",
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
          /*Expanded(
            flex: 1,
            child: Icon(
              Icons.print_outlined,
              color: kWhiteColor,
              size: 24,
            ),
          ),*/
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
