import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_reports.dart';

import '../../../Utils/app_decorations.dart';
import '../../../main.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TransactionsBody();
  }
}

class TransactionsBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TransactionsBodyState();
}

class _TransactionsBodyState
    extends BasePageState<TransactionsBody, ViewModelReports> {
  var user = mPreference.value.userData;
  @override
  void initState() {
    super.initState();
    viewModel.userStream.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: kMainColor,
        image: DecorationImage(
          image: AssetImage(VOUCHER_BG),
          fit: BoxFit.cover,
        ),
      ),
      child:Scaffold(
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
                    AppLocalizations.of(context)!.reports!,
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
              child: ListView(
                children: [
                  _itemMenu(IC_REPORT_SALES, AppLocalizations.of(context)!.salesReport!, onTap: () {
                    Navigator.pushNamed(context, PageRoutes.salesReport);
                    // viewModel.requestMyUser();
                  }),
                  _itemMenu(IC_MY_TRANSACTION, AppLocalizations.of(context)!.myTransactions!,
                      onTap: () {
                    Navigator.pushNamed(context, PageRoutes.customRange);
                  }),
                  _itemMenu(IC_ABOUT_US, AppLocalizations.of(context)!.commissionReport!, onTap: () {
                    Navigator.pushNamed(context, PageRoutes.commissionReport);
                  }),
                  _itemMenu(IC_FUND_DEPOSIT, AppLocalizations.of(context)!.prefundDepositSummary!, onTap: () {
                    Navigator.pushNamed(context, PageRoutes.preFundDeposit);
                  }),
                   _itemMenu(IC_WALLET, AppLocalizations.of(context)!.walletTopupBankTransfer!, onTap: () {
                    Navigator.pushNamed(context, PageRoutes.fundRequestReport,arguments: {"isCredit": "0","paymentType":"Bank"});
                  }),
                  Visibility(
                      visible: user.isCredit,
                      child: _itemMenu(IC_WALLET, AppLocalizations.of(context)!.creditRequest!, onTap: () {
                    Navigator.pushNamed(context, PageRoutes.fundRequestReport,arguments: {"isCredit": "1","paymentType":"Cash"});
                  })),
                 /* _itemMenu(IC_WALLET_REPORT, "Wallet Topup - Bank Card", onTap: () {
                    Navigator.pushNamed(context, PageRoutes.fundRequestReport,arguments: {"isCredit": "0","paymentType":"BankCard"});
                  }),*/
                  SizedBox(
                    height: 36,
                  )
                ],
              ),
            ),
          ],
        ),
      ),),
    );
  }

  _itemMenu(String icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          /*decoration: BoxDecoration(
            color: kOTPBackground,
            boxShadow: [
              BoxShadow(
                color: kShadow,
                offset: Offset(1.0, 1.0),
                blurRadius: 2,
                spreadRadius: 1.0,
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(26)),
          ),*/
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(.2),
                child: Image.asset(
                  icon,
                  width: 52,
                  height: 52,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                title,
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.LIGHT),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
