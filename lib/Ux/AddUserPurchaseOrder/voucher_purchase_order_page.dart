import 'dart:collection';
import 'dart:convert';

import 'package:daman/Database/models/offline_pin_stock.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/pair.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_icons.dart';

import '../../Database/hive_boxes.dart';
import '../../Database/models/denomination.dart';
import '../../Utils/Widgets/custom_button.dart';
import '../../Utils/app_decorations.dart';
import '../Dialog/dialog_success.dart';
import 'ViewModel/view_model_adduser_purchase_order.dart';

class VoucherPurchaseOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddUserPurchaseOrderBody();
  }
}

class AddUserPurchaseOrderBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddUserPurchaseOrderBodyState();
}

class _AddUserPurchaseOrderBodyState extends BasePageState<
    AddUserPurchaseOrderBody, ViewModelAddUserPurchaseOrder> {
  var boxDenominations = HiveBoxes.getDenomination();
  var boxOperator = HiveBoxes.getOperators();

  var pinsStockBox = HiveBoxes.getOfflinePinStock();
  List<OfflinePinStock> offlinePinsStockList = [];

  List<Pair<Operator, List<DenominationWidget>>> mAllData = [];
  ValueNotifier<Pair<int, double>> mCalculations = ValueNotifier(Pair(0, 0.0));
  static const _SERVICE_ID = "4";

  _loadDenominationData() {
    var mOperators = boxOperator.values
        .where((element) => element.serviceId == _SERVICE_ID)
        .toList();

    mOperators.forEach((operator) {
      var mDenominations = boxDenominations.values
          .where((element) => element.operatorId == operator.id)
          .map((e) => DenominationWidget(e, doCalculateAmount))
          .toList();
      mAllData.add(Pair(operator, mDenominations));
    });
    AppLog.e("opDataLis", mOperators.length.toString());
  }

  void doCalculateAmount() {
    AppLog.e("CALCULATE", "AMOUNT");
    var quantity = 0;
    var total = 0.0;
    mAllData.forEach((element) {
      element.second.forEach((element) {
        var data = element.getPair();
        quantity += data.first;
        total += (data.first * data.second);
      });
    });
    mCalculations.value = Pair(quantity, total);
  }

  doSubmit() {
    var operatorsArray = [];
    mAllData.forEach((element) {
      var operatorJsonObject = HashMap();
      operatorJsonObject["operator_id"] = element.first.id;

      var denominationsArray = [];

      element.second.forEach((element) {
        var denominationJsonObject = HashMap();

        denominationJsonObject["denomination_id"] = element.denomination.id;
        denominationJsonObject["denomination_category_id"] =
            element.denomination.categoryId;

        var data = element.getPair();
        var quantity = data.first;
        var amount = data.second;

        denominationJsonObject["amount"] = amount;
        denominationJsonObject["quantity"] = quantity;
        if (quantity > 0) denominationsArray.add(denominationJsonObject);
      });
      operatorJsonObject["denominations"] = denominationsArray;
      if (denominationsArray.isNotEmpty) operatorsArray.add(operatorJsonObject);
    });
    if (operatorsArray.isEmpty) {
      AppAction.showGeneralErrorMessage(
          context, "Please Select at least one voucher");
    } else {
      viewModel.requestVoucherSell(
          mServiceId: _SERVICE_ID, operatorsArray: operatorsArray);
    }
    AppLog.e("DATA", jsonEncode(operatorsArray));
  }

  @override
  void initState() {
    super.initState();
    _loadDenominationData();
    setState(() {});
    viewModel.responseStream.listen((event) async {
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
        mDownloadPins.forEach((element) async {
          await HiveBoxes.getOfflinePinStock().put(element.recordId, element);
        });
        // await HiveBoxes.getOfflinePinStock().addAll(mDownloadPins);
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
      }
    });
    // STATUS UPDATE SOLD PINS
    viewModel.requestUpdatePinSoldStatus();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    HiveBoxes.getOfflinePinStock().values.forEach((element) {
      AppLog.e("STOCK PINS", element.toString());
    });
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
                    decoration: BoxDecoration(
                      color: kMainColor,
                      image: DecorationImage(
                        image: AssetImage(VOUCHER_BG),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: decorationBackground,
                      child: Scaffold(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .addPurchaseOrder!,
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
                                child: ListView.separated(
                                  itemCount: mAllData.length,
                                  itemBuilder: (context, index) =>
                                      OperatorWidget(mAllData[index]),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        bottomNavigationBar: Container(
                          margin: EdgeInsets.only(
                              left: 10, bottom: 16, right: 10, top: 8),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: kWhiteColor.withOpacity(.1),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: kWhiteColor, width: .5),
                          ),
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: ValueListenableBuilder(
                                    valueListenable: mCalculations,
                                    builder: (BuildContext context,
                                        Pair<int, double> value,
                                        Widget? child) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Qty : ${value.first}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: kWhiteColor,
                                                fontSize: 14,
                                                fontWeight: RFontWeight.BLACK),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                    .total! +
                                                " : ${value.second}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: kWhiteColor,
                                                fontSize: 16,
                                                fontWeight: RFontWeight.BOLD),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              Expanded(
                                flex: 1,
                                child: CustomButton(
                                  text: AppLocalizations.of(context)!.submit!,
                                  radius: BorderRadius.all(Radius.circular(8)),
                                  onPressed: () async {
                                    doSubmit();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )))));
  }
}

class OperatorWidget extends StatelessWidget {
  final Pair<Operator, List<DenominationWidget>> data;

  OperatorWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: kWhiteColor.withOpacity(.1),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: kWhiteColor, width: .5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(data.first.name,
                style: TextStyle(fontSize: 24, color: kWhiteColor)),
            leading: AppImage(
              data.first.logo,
              36,
              defaultImage: DEFAULT_OPERATOR,
              borderWidth: 1,
              borderColor: kHintColor,
            ),
            tileColor: kMainButtonColor,
          ),
          Container(
            height: 36,
            color: kMainColor.withOpacity(.1),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    AppLocalizations.of(context)!.title!,
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.LIGHT),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    AppLocalizations.of(context)!.amount!,
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.LIGHT),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Qty",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.LIGHT),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    AppLocalizations.of(context)!.total!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.LIGHT),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: data.second.length,
            itemBuilder: (context, index) => data.second[index],
            separatorBuilder: (context, index) => SizedBox(height: .5),
          ),
        ],
      ),
    );
  }
}

class DenominationWidget extends StatefulWidget {
  final Denomination denomination;
  final Function() onTap;

  DenominationWidget(this.denomination, this.onTap);

  var _count = 0;

  Pair<int, double> getPair() {
    return Pair(_count, denomination.denomination);
  }

  double getTotal() {
    return denomination.denomination * _count;
  }

  @override
  State<DenominationWidget> createState() => _DenominationWidgetState();
}

class _DenominationWidgetState extends State<DenominationWidget> {
  void _increment() {
    widget._count++;
    setState(() {});
    widget.onTap();
  }

  void _decrement() {
    if (widget._count > 0) {
      widget._count--;
      setState(() {});
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      color: kWhiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              widget.denomination.title,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.denomination.denomination.toString(),
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                decoration: BoxDecoration(
                    color: kMainButtonColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _decrement,
                        child: Image.asset(
                          IC_MINUS,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "${widget._count < 10 ? "  " : ""}${widget._count}",
                              style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 14,
                                  fontWeight: RFontWeight.BOLD,
                                  fontFamily: RFontFamily.POPPINS),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _increment,
                        child: Image.asset(
                          IC_PLUS,
                          width: 20,
                          height: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${widget._count * widget.denomination.denomination}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ],
      ),
    );
  }
}
