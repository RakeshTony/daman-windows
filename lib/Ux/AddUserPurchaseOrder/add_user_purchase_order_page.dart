import 'package:daman/Database/models/operator.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:flutter/gestures.dart';
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
import 'ViewModel/view_model_adduser_purchase_order.dart';

class AddUserPurchaseOrderPage extends StatelessWidget {
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
  var _wallet = HiveBoxes.getBalanceWallet();
  List<Operator> mOperators = [];
  List<Denomination> mDenominations = [];

  _loadDenominationData() {
    mOperators.addAll(boxOperator.values
        .where((element) => element.serviceId == "4")
        .toList());
    AppLog.e("opDataLis", mOperators.length.toString());
  }

  double _getTotalAmount(int qty, double amount) {
    return amount * qty;
  }

  @override
  void initState() {
    super.initState();
    _loadDenominationData();
    // viewModel.requestCommission();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
        onWillPop: () async => false,
    child:Dialog(
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
              child: Scaffold(
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: theme.primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Text(
                                "Add Purchase Order",
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
                            initialData: mOperators,
                            builder: (context,
                                AsyncSnapshot<List<Operator>> snapshot) {
                              var items = List<Operator>.empty(growable: true);
                              if (snapshot.hasData && snapshot.data != null) {
                                var data = snapshot.data ?? [];
                                items.addAll(data);
                              }
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
                                      _itemExpendable(items[index], index),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    color: kMainButtonColor,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CustomButton(
                              text: "Submit",
                              radius: BorderRadius.all(Radius.circular(0.0)),
                              onPressed: () async {},
                            )),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Total",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 14,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "10",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 14,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "500",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 14,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ),
                      ],
                    ),
                  )),
            ))));
  }

  _itemExpendable(Operator data, int index) {
    var children = List<Widget>.empty(growable: true);
    children.add(_itemHeader());
    mDenominations.clear();
    mDenominations.addAll(boxDenominations.values
        .where((element) => element.operatorId == data.id)
        .toList());
    children.addAll(List<Widget>.generate(
        mDenominations.length, (index) => _itemContent(mDenominations[index])));

    return ExpansionTile(
      backgroundColor: kTitleBackground,
      collapsedTextColor: kMainTextColor,
      textColor: kWhiteColor,
      collapsedBackgroundColor: kColor1,
      iconColor: kWhiteColor,
      collapsedIconColor: kMainTextColor,
      tilePadding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      title: Text(data.name),
      leading: AppImage(
        data.logo,
        24,
        defaultImage: DEFAULT_OPERATOR,
        borderWidth: 1,
        borderColor: kHintColor,
      ),
      children: children,
    );
  }

  _itemHeader() {
    return Container(
      height: 46,
      color: kWhiteColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Title",
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Amount",
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Qty",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Total",
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

  _itemContent(Denomination data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: kWhiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.title,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.denomination.toString(),
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              //controller: widget._textEditingController,
              // focusNode: widget._focusNode,
              keyboardType: TextInputType.number,
              cursorColor: kMainColor,
              style: TextStyle(color: kMainColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "0",
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
