import 'package:daman/Utils/app_log.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import '../../Database/models/offline_pin_stock.dart';
import '../../Utils/app_decorations.dart';
import 'ViewModel/view_model_pin_local_stock.dart';

class PinsLocalStockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PinsLocalStockBody();
  }
}

class PinsLocalStockBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PinsLocalStockBodyState();
}

class _PinsLocalStockBodyState
    extends BasePageState<PinsLocalStockBody, ViewModelPinLocalStock> {
  var wallet = HiveBoxes.getBalanceWallet();
  var pinsStockBox = HiveBoxes.getOfflinePinStock();
  List<OfflinePinStock> offlinePinsStockList = [];

  int getOfflinePinCount() {
    return HiveBoxes.getOfflinePinStock()
        .values
        .where((element) => element.isSold == false)
        .length;
  }

  int getPinCount(String denominationId) {
    return HiveBoxes.getOfflinePinStock()
        .values
        .where((element) => element.isSold == false)
        .where((element) => element.denominationId == denominationId)
        .length;
  }

  @override
  void initState() {
    super.initState();
    var mData = (pinsStockBox.values
        .where((element) => element.isSold == false)
        .toList());
    var mSet = mData.map((e) => e.denominationId).toSet();
    mSet.forEach((denomination) {
      offlinePinsStockList.add(mData
          .firstWhere((element) => element.denominationId == denomination));
    });
    offlinePinsStockList
        .sort((a, b) => a.operatorTitle.compareTo(b.operatorTitle));
    AppLog.e("DENOMINATIONS", mSet.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Scaffold(
                      backgroundColor: kTransparentColor,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .localPinsStock!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: kWhiteColor,
                                        fontWeight: RFontWeight.LIGHT,
                                        fontFamily: RFontFamily.POPPINS),
                                  ),
                                  Row(children: [
                                    Text(
                                      "${getOfflinePinCount()}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kWhiteColor,
                                          fontWeight: RFontWeight.BOLD,
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
                                  ],),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Expanded(
                                child: ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                              ),
                              child: ListView.builder(
                                itemCount: offlinePinsStockList.length,
                                itemBuilder: (context, index) =>
                                    _itemTransaction(
                                        offlinePinsStockList[index]),
                              ),
                            )),
                          ],
                        ),
                      ),
                    )))));
  }

  _itemTransaction(OfflinePinStock data) {
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
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: kTitleBackground,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "${getPinCount(data.denominationId)}",
                    style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.MEDIUM,
                        fontSize: 14),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    data.denominationTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: kMainTextColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14),
                  ),
                  Text(
                    data.serialNumber,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: kMainTextColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 11),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(left: 12),
                child: Center(
                  child: Text(
                    "${wallet?.currencySign ?? ''} ${data.decimalValue}",
                    style: TextStyle(
                        color: kTextAmountDR,
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
                  data.operatorTitle,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
