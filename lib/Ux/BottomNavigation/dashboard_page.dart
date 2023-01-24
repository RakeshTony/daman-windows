import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/denomination.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Windows/app_bar_dashboard_widget.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_helper.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Ux/BottomNavigation/ViewModel/view_model_bottom_navigation.dart';
import 'package:daman/Ux/Dialog/windows/dialog_voucher_receipt.dart';
import 'package:daman/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../DataBeans/BulkOrderResponseDataModel.dart';
import '../../Database/models/offline_pin_stock.dart';
import '../../Utils/app_file_utils.dart';
import '../../Utils/app_style_text.dart';
import '../Dialog/dialog_success.dart';

class DashboardPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState
    extends BasePageState<DashboardPage, ViewModelBottomNavigation> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchNode = FocusNode();
  TextEditingController _searchOperatorController = TextEditingController();
  FocusNode _searchOperatorNode = FocusNode();
  var _mWallet = HiveBoxes.getBalanceWallet();
  var mOperators = HiveBoxes.getOperators();
  var mDenominations = HiveBoxes.getDenomination();
  List<Operator> filterOperatorData = [];
  List<Denomination> filterData = [];

  Operator? mSelectedOperator;
  Denomination? mSelectedDenomination;
  var _count = 1;

  _doSearchListener() {
    var key = _searchController.text;
    if (filterData.isNotEmpty) filterData.clear();
    if (mSelectedOperator != null) {
      if (key.isNotEmpty) {
        filterData.addAll(mDenominations.values
            .where((element) =>
                element.title.startsWithIgnoreCase(key) &&
                element.operatorId == mSelectedOperator?.id)
            .toList());
      } else {
        filterData.addAll(mDenominations.values
            .where((element) => element.operatorId == mSelectedOperator?.id)
            .toList());
      }
    }
    setState(() {});
  }

  _doSearchOperatorListener() {
    var key = _searchOperatorController.text;
    if (filterOperatorData.isNotEmpty) filterOperatorData.clear();
    if (key.isNotEmpty) {
      filterOperatorData.addAll(mOperators.values
          .where((element) =>
              element.name.toLowerCase().contains(key.toLowerCase()))
          .toList());
    } else {
      filterOperatorData.addAll(mOperators.values.toList());
    }
    mSelectedOperator = null;
    mSelectedDenomination = null;
    setState(() {});
  }

  @override
  Future<bool> didPopRoute() {
    AppLog.e("didPopRoute", "1");
    return super.didPopRoute();
  }

  @override
  void initState() {
    super.initState();
    _searchOperatorController.addListener(_doSearchOperatorListener);
    if (filterOperatorData.isEmpty)
      filterOperatorData.addAll(mOperators.values.toList());
    _searchController.addListener(_doSearchListener);
    if (filterData.isEmpty && mSelectedOperator != null)
      filterData.addAll(mDenominations.values
          .where((element) => element.operatorId == mSelectedOperator?.id)
          .toList());

    viewModel.responseBulkOrderStream.listen((event) {
      viewModel.requestBalanceEnquiry();
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
        doShowPrintDialog(mSelectedOperator!, event.vouchers);
      }
    });
  }

  doShowPrintDialog(Operator operator, List<VoucherDenomination> vouchers) {
    var receipt = DialogVoucherReceipt(vouchers, operator);
    showDialog(context: context, builder: (builder) => receipt);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        appBar: AppBarDashboardWidget(widget.scaffoldKey, elevation: 0),
        key: widget.scaffoldKey,
        body: Container(
          color: kColor_1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kColor_1,
                constraints: BoxConstraints(
                  minHeight: 100,
                  minWidth: double.maxFinite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Choose Operator",
                            style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: RFontWeight.MEDIUM,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Container(
                            color: kColor_4,
                            child: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              controller: _searchOperatorController,
                              focusNode: _searchOperatorNode,
                              style: AppStyleText.inputFiledPrimaryText
                                  .copyWith(color: kWhiteColor),
                              decoration: InputDecoration(
                                hintText: "Search Operator",
                                hintStyle: AppStyleText.inputFiledPrimaryHint
                                    .copyWith(color: kWhiteColor),
                                // isDense: true,
                                // filled: true,
                                contentPadding: EdgeInsets.all(16),
                                fillColor: kColor_4,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kColor_4,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kColor_4, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  minHeight: 20,
                                  minWidth: 20,
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    IC_SEARCH,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: kMainButtonColor,
                      child: SizedBox(
                        height: 150,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                              },
                            ),
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: filterOperatorData.length,
                              itemBuilder: (context, index) =>
                                  _itemOperators(filterOperatorData[index]),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 20),
                              shrinkWrap: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Choose Denomination",
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: RFontWeight.MEDIUM,
                  ),
                ),
              ),
              Expanded(
                child: mSelectedOperator != null
                    ? Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: GridView.builder(
                                itemCount: filterData.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 1 / 1.4,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16),
                                itemBuilder: (context, index) =>
                                    _itemVouchers(filterData[index]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 16, left: 16, right: 16),
                              child: Visibility(
                                visible: mSelectedDenomination != null,
                                child: _itemVouchersSelected(
                                    mSelectedDenomination),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, bottom: 24, top: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          border: Border.all(
                            width: 1,
                            color: kWhiteColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "No Denomination Found",
                            style: TextStyle(
                                fontFamily: RFontFamily.SOFIA_PRO,
                                fontSize: 16,
                                color: kWhiteColor,
                                fontWeight: RFontWeight.SEMI_BOLD),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemOperators(Operator operator) {
    if (mSelectedOperator == null && _searchOperatorController.text.isEmpty) {
      mSelectedOperator = operator;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _doSearchListener();
      });
    }
    return InkWell(
      onTap: () {
        mSelectedDenomination = null;
        if (mSelectedOperator == operator) {
          mSelectedOperator = null;
        } else {
          mSelectedOperator = operator;
        }
        _doSearchListener();
      },
      child: SizedBox(
        width: 150,
        height: 100,
        child: Container(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  /*gradient: CARD_GRADIENT,*/
                  color:kOperatorItemBackground,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      operator.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: kWhiteColor,
                          fontWeight: RFontWeight.BOLD),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 70,
                      child: CachedNetworkImage(
                        imageUrl: operator.logo,
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(DEFAULT_OPERATOR),
                        ),
                        errorWidget: (context, url, error) => AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(DEFAULT_OPERATOR),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: mSelectedOperator == operator,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kColor4,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.check,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _itemVouchers(Denomination voucher) {
    return InkWell(
      onTap: () {
        setState(() {
          mSelectedDenomination = voucher;
          _count = 1;
        });
      },
      child: Container(
        height: double.maxFinite,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
        //decoration: decorationCardBackground,
        decoration: BoxDecoration(
          color: kColor_3,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: mSelectedDenomination == voucher
                ? kBorderColorActive
                : kColor_3,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: AspectRatio(
                        aspectRatio: 2 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: voucher.logo,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio: 2 / 1,
                              child:
                                  Image.asset(DUMMY_BANNER, fit: BoxFit.fill),
                            ),
                            errorWidget: (context, url, error) => AspectRatio(
                              aspectRatio: 2 / 1,
                              child:
                                  Image.asset(DUMMY_BANNER, fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*Visibility(
                      visible: mSelectedDenomination == voucher,
                      child: Container(

                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.check_circle,
                          color: kColor4,
                        ),
                      ),
                    ),*/
                  ],
                )),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      voucher.title,
                      style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.SEMI_BOLD,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.yourPrice!,
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 10,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                        ),
                      ),
                      Text(
                        "${_mWallet?.currencySign} ${voucher.sellingPrice}",
                        style: TextStyle(
                          fontSize: 10,
                          color: kWhiteColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.customerPrice!,
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 10,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                        ),
                      ),
                      Text(
                        "${_mWallet?.currencySign} ${voucher.denomination}",
                        style: TextStyle(
                          fontSize: 10,
                          color: kWhiteColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _itemVouchersSelected(Denomination? voucher) {
    return Container(
      height: double.maxFinite,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kColor_3,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Container(
            child: AspectRatio(
              aspectRatio: 3 / 1.4,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: "${voucher?.logo}",
                  fit: BoxFit.fill,
                  placeholder: (context, url) => AspectRatio(
                    aspectRatio: 2 / 1,
                    child: Image.asset(DUMMY_BANNER, fit: BoxFit.fill),
                  ),
                  errorWidget: (context, url, error) => AspectRatio(
                    aspectRatio: 2 / 1,
                    child: Image.asset(DUMMY_BANNER, fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${voucher?.title}",
                    style: TextStyle(
                      color: kWhiteColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.SEMI_BOLD,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _decrement,
                        child: Image.asset(
                          IC_MINUS,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "${_count < 10 ? '0' : ""}$_count",
                          style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 17,
                              fontWeight: RFontWeight.BOLD,
                              fontFamily: RFontFamily.POPPINS),
                        ),
                      ),
                      InkWell(
                        onTap: _increment,
                        child: Image.asset(
                          IC_PLUS,
                          width: 24,
                          height: 24,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourPrice!,
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 10,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                    Text(
                      "${_mWallet?.currencySign} ${voucher?.sellingPrice}",
                      style: TextStyle(
                        fontSize: 10,
                        color: kWhiteColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.localPinStock!,
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 10,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable:
                            HiveBoxes.getOfflinePinStock().listenable(),
                        builder: (context, Box<OfflinePinStock> data, _) {
                          return Text(
                            "${getLocalPinAvailableCount(mSelectedDenomination)}",
                            style: TextStyle(
                              fontSize: 10,
                              color: kWhiteColor,
                              fontFamily: RFontFamily.POPPINS,
                              fontWeight: RFontWeight.REGULAR,
                            ),
                          );
                        }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (mSelectedOperator != null &&
                        mSelectedDenomination != null) {
                      doSoldVoucher(mSelectedOperator!, mSelectedDenomination!);
                    }
                    /*viewModel.requestVoucherSell(
                      mServiceId: mSelectedOperator?.serviceId ?? "",
                      mOperatorId: mSelectedOperator?.id ?? "",
                      mDenominationId: mSelectedDenomination?.id ?? "",
                      mDenominationCategoryId:
                          mSelectedDenomination?.categoryId ?? "",
                      mAmount: mSelectedDenomination?.denomination ?? 0.0,
                      mQuantity: _count,
                    );*/
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: BUTTON_GRADIENT,
                      borderRadius: BorderRadius.all(Radius.circular(34.0)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.buyNow!,
                      style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: RFontWeight.REGULAR, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void doSoldVoucher(Operator operator, Denomination voucher) async {
    if (mPreference.value.userData.posStatus &&
        _count <= getLocalPinAvailableCount(voucher)) {
      await doOrderProcessWithLocal(operator, voucher);
    } else {
      await doOrderProcessWithAPI(operator, voucher);
    }
    _count = 1;
    mSelectedDenomination = null;
    setState(() {});
  }

  doOrderProcessWithLocal(Operator operator, Denomination voucher) async {
    List<VoucherDenomination> mPinsForSale = [];
    var json = List<Map<String, dynamic>>.empty(growable: true);
    var mOfflinePins = getUnSoldLocalPinAvailable(voucher);
    for (int index = 0;
        (index < _count && index < mOfflinePins.length);
        index++) {
      var mPinForSale = mOfflinePins[index];
      mPinForSale.usedDate = DateTime.now().toString();
      mPinForSale.isSold = true;
      mPinForSale.syncServer = false;
      mPinForSale.time = DateTime.now();
      mPinForSale.status = 0;
      await HiveBoxes.getOfflinePinStock()
          .put(mPinForSale.recordId, mPinForSale);
      json.add({
        "recordId": mPinForSale.recordId,
        "usedDate": mPinForSale.usedDate,
      });
      mPinsForSale.add(VoucherDenomination.fromOfflinePinStock(mPinForSale));
    }

    var mFile = await localFile();
    AppLog.e("FILE PATH", mFile.path);
    await writerFile(mFile, json);
    var result = await readFile(mFile);
    AppLog.e("SAVED RESULT", result);

    /*   Navigator.pushNamedAndRemoveUntil(context, PageRoutes.voucherCheckOut,
        ModalRoute.withName(PageRoutes.bottomNavigation),
        arguments: {"operator": widget.operator, 'voucher': mPinsForSale});
 */
    await doShowPrintDialog(operator, mPinsForSale);
  }

  doOrderProcessWithAPI(Operator operator, Denomination voucher) {
    viewModel.requestVoucherSell(
      mServiceId: operator.serviceId,
      mOperatorId: operator.id,
      mDenominationId: voucher.id,
      mDenominationCategoryId: voucher.categoryId,
      mAmount: voucher.denomination,
      mQuantity: _count,
    );
  }

  int getLocalPinAvailableCount(Denomination? voucher) {
    if (voucher == null) return 0;
    return HiveBoxes.getOfflinePinStock()
        .values
        .where((element) =>
            element.isSold == false && element.denominationId == voucher.id)
        .toList()
        .length;
  }

  List<OfflinePinStock> getUnSoldLocalPinAvailable(Denomination? voucher) {
    if (voucher == null) return [];
    return HiveBoxes.getOfflinePinStock()
        .values
        .where((element) =>
            element.isSold == false && element.denominationId == voucher.id)
        .toList();
  }

  void _increment() {
    _count++;
    setState(() {});
  }

  void _decrement() {
    if (_count > 1) {
      _count--;
      setState(() {});
    }
  }
}
