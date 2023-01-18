import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/GetParamsDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_top_up_check_out.dart';

class TopUpCheckOutPage extends StatelessWidget {
  String mobile;
  String mobileCountryId;
  String mobileCountryCode;
  String operatorIcon;
  CurrencyData currency;
  ParamOperatorModel operator;
  UserPlanModel plan;

  TopUpCheckOutPage({
    required this.mobile,
    required this.mobileCountryId,
    required this.mobileCountryCode,
    required this.currency,
    required this.operator,
    required this.operatorIcon,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return TopUpCheckOutBody(
      mobile: mobile,
      mobileCountryId: mobileCountryId,
      mobileCountryCode: mobileCountryCode,
      currency: currency,
      operator: operator,
      operatorIcon: operatorIcon,
      plan: plan,
    );
  }
}

class TopUpCheckOutBody extends StatefulWidget {
  String mobile;
  String mobileCountryId;
  String mobileCountryCode;
  String operatorIcon;
  CurrencyData currency;
  ParamOperatorModel operator;
  UserPlanModel plan;

  TopUpCheckOutBody({
    required this.mobile,
    required this.mobileCountryId,
    required this.mobileCountryCode,
    required this.currency,
    required this.operator,
    required this.operatorIcon,
    required this.plan,
  });

  @override
  State<StatefulWidget> createState() => _TopUpCheckOutBodyState();
}

class _TopUpCheckOutBodyState
    extends BasePageState<TopUpCheckOutBody, ViewModelTopUpCheckOut> {
  @override
  void initState() {
    super.initState();
    viewModel.responseStream.listen((event) {
      if (mounted) {
        var message = event.second.getMessage;
        var data = event.second.getDenomination();
        if (data.isNotEmpty) {
          var args = HashMap<String, dynamic>();
          args["receiptNo"] = event.first;
          args["mobile"] = widget.mobile;
          args["mobileCountryId"] = widget.mobileCountryId;
          args["mobileCountryCode"] = widget.mobileCountryCode;
          args["operatorIcon"] = widget.operatorIcon;
          args["operator"] = widget.operator;
          args["currency"] = widget.currency;
          args["status"] = data.first;
          args["subscriber_title"] = "Mobile Number";

          Navigator.pushNamedAndRemoveUntil(
            context,
            PageRoutes.rechargeStatus,
            ModalRoute.withName(PageRoutes.bottomNavigation),
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
  }

  double _getCommission() {
    return widget.operator.isMarkup ? widget.operator.markupValue : 0.0;
  }

  double _calculateCommission() {
    if (widget.operator.isMarkup) {
      var amount = widget.plan.planAmount;
      var commission = widget.operator.markupValue;
      return (amount * commission) / 100;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 8,
              margin: EdgeInsets.only(left: 16, right: 16, top: 24),
              decoration: BoxDecoration(
                color: kStrip,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
            Container(
              color: theme.backgroundColor,
              margin: EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  Image.asset(VOUCHER_STRIP),
                  SizedBox(
                    height: 24,
                  ),
                  AppImage(
                    widget.operatorIcon,
                    72,
                    defaultImage: DEFAULT_OPERATOR,
                    borderWidth: 1,
                    borderColor: kHintColor,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "${widget.operator.title} ${widget.operator.operatorMainType}",
                    style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 15,
                      fontWeight: RFontWeight.LIGHT,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _getRow('Mobile Number',
                      "+${widget.mobileCountryCode} ${widget.mobile}"),
                  _getRow('Operator', "${widget.operator.title}"),
                  _getRow('Price',
                      "${widget.currency.sign} ${widget.plan.planAmount}"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Text(
                      "Note - Top-up bonus is added by the operator",
                      style: TextStyle(
                        color: kMainTextColor,
                        fontSize: 11,
                        fontWeight: RFontWeight.LIGHT,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: kBorder, width: .5),
                      ),
                      child: Column(
                        children: [
                          _getRow_1("Product Type", "Mobile Top-up"),
                          Divider(
                            height: .5,
                            color: kBorder,
                          ),
                          _getRow_1("Top-up Amount",
                              "${widget.currency.sign} ${widget.plan.planAmount}"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                    child: Text(
                      "Please note that some receive amounts may have updated since your last visit.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: kMainTextColor,
                        fontSize: 9,
                        fontWeight: RFontWeight.LIGHT,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                    child: Divider(
                      color: kBorder,
                      height: .5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: _getRow_1("Sub total",
                        "${widget.currency.sign} ${(widget.plan.planAmount - _calculateCommission()).toStringAsPrecision(3)}",
                        textSize: 10),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: _getRow_1(
                        "Processing fee (${_getCommission()}${widget.operator.defaultCommissionType} of Topup Amount)",
                        "${widget.currency.sign} ${_calculateCommission().toStringAsPrecision(3)}",
                        textSize: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                    child: Divider(
                      color: kBorder,
                      height: .5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: _getRow_1("Total",
                        "${widget.currency.sign} ${widget.plan.planAmount}",
                        textSize: 10, fontWeight: RFontWeight.BOLD),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Image.asset(VOUCHER_STRIP_SINGLE),
                ],
              ),
            ),
            SizedBox(
              height: 36,
            ),
            CustomButton(
              text: "Proceed to Checkout",
              margin: EdgeInsets.symmetric(horizontal: 24),
              radius: BorderRadius.all(Radius.circular(34.0)),
              color: kWhiteColor,
              padding: 15,
              style: Theme.of(context).textTheme.button!.copyWith(
                  fontWeight: RFontWeight.LIGHT,
                  fontSize: 18,
                  color: kMainTextColor),
              onPressed: () {
                //Navigator.pushNamed(context, PageRoutes.topUpCheckOut);
                viewModel.requestBulkTopUp(
                  mServiceId: widget.operator.serviceId,
                  operatorId: widget.operator.id,
                  denominationId: widget.plan.planId,
                  amount: widget.plan.planAmount,
                  amountOriginal: widget.plan.planAmountOriginal,
                  amountReceiver: widget.plan.planAmountReceiver,
                  mobile: widget.mobile,
                );
              },
            ),
            SizedBox(
              height: 36,
            ),
          ],
        ),
      ),
    );
  }

  _getRow(String label, String value) {
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
                fontWeight: RFontWeight.LIGHT,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              ":",
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 12,
                fontWeight: RFontWeight.LIGHT,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "$value",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 12,
                fontWeight: RFontWeight.LIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getRow_1(String label, String value,
      {double textSize = 12, FontWeight fontWeight = RFontWeight.LIGHT}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "$label",
              style: TextStyle(
                color: kMainTextColor,
                fontSize: textSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
          Text(
            "$value",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: kMainTextColor,
              fontSize: textSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
