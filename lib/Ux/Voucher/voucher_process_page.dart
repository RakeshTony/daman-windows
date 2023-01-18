import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/denomination.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_file_utils.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Voucher/ViewModel/view_model_voucher_check_out.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Database/models/offline_pin_stock.dart';
import '../../Utils/app_device.dart';
import '../../main.dart';

class VoucherProcessPage extends StatelessWidget {
  final Denomination voucher;
  final Operator operator;

  VoucherProcessPage(this.voucher, this.operator);

  @override
  Widget build(BuildContext context) {
    return VoucherProcessBody(voucher, operator);
  }
}

class VoucherProcessBody extends StatefulWidget {
  final Denomination voucher;
  final Operator operator;

  VoucherProcessBody(this.voucher, this.operator);

  @override
  State<StatefulWidget> createState() => _VoucherProcessBodyState();
}

class _VoucherProcessBodyState
    extends BasePageState<VoucherProcessBody, ViewModelVoucherCheckOut> {
  var _wallet = HiveBoxes.getBalanceWallet();

  @override
  void initState() {
    super.initState();
    viewModel.responseStream.listen((event) {
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
        Navigator.pushNamedAndRemoveUntil(context, PageRoutes.voucherCheckOut,
            ModalRoute.withName(PageRoutes.bottomNavigation), arguments: {
          "operator": widget.operator,
          'voucher': event.vouchers
        });
      }
    });
  }

  var _count = 1;

  int getLocalPinAvailableCount() {
    return HiveBoxes.getOfflinePinStock()
        .values
        .where((element) =>
            element.isSold == false &&
            element.denominationId == widget.voucher.id)
        .toList()
        .length;
  }

  List<OfflinePinStock> getUnSoldLocalPinAvailable() {
    return HiveBoxes.getOfflinePinStock()
        .values
        .where((element) =>
            element.isSold == false &&
            element.denominationId == widget.voucher.id)
        .toList();
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
      child: Scaffold(
        appBar: AppBarCommonWidget(),
        // appBar: AppBar(),
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 48,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Center(
                              child: Text(
                                widget.voucher.title,
                                style: TextStyle(
                                    fontFamily: RFontFamily.POPPINS,
                                    fontWeight: RFontWeight.SEMI_BOLD,
                                    fontSize: 18,
                                    color: kWhiteColor),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 2, right: 10, bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 150.0,
                                  child: AspectRatio(
                                    aspectRatio: 10 / 10,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.voucher.logo,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          DUMMY_BANNER,
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          DUMMY_BANNER,
                                          fit: BoxFit.cover,
                                        ),
                                      ) /*FadeInImage(
                                    image: NetworkImage(widget.voucher.logo),
                                    fit: BoxFit.fill,
                                    placeholder: AssetImage(DUMMY_BANNER),
                                    imageErrorBuilder:
                                        ((context, error, stackTrace) {
                                      return Image.asset(
                                        DUMMY_BANNER,
                                        fit: BoxFit.cover,
                                      );
                                    }),
                                  )*/
                                      ,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 24),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: kMainButtonColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(21))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: _decrement,
                                        child: Image.asset(
                                          IC_MINUS,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24),
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
                                          width: 40,
                                          height: 40,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.yourPrice!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: RFontFamily.POPPINS,
                                          fontWeight: RFontWeight.REGULAR,
                                          color: kWhiteColor),
                                    ),
                                    Text(
                                      "${_wallet?.currencySign}${widget.voucher.denomination}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: RFontFamily.POPPINS,
                                          fontWeight: RFontWeight.REGULAR,
                                          color: kWhiteColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .customerPrice!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: RFontFamily.POPPINS,
                                          fontWeight: RFontWeight.REGULAR,
                                          color: kWhiteColor),
                                    ),
                                    Text(
                                      "${_wallet?.currencySign}${widget.voucher.sellingPrice}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: RFontFamily.POPPINS,
                                          fontWeight: RFontWeight.REGULAR,
                                          color: kWhiteColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                    visible:
                                        mPreference.value.userData.posStatus,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .localPinStock!,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: RFontFamily.POPPINS,
                                              fontWeight: RFontWeight.REGULAR,
                                              color: kWhiteColor),
                                        ),
                                        Text(
                                          getLocalPinAvailableCount()
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: RFontFamily.POPPINS,
                                              fontWeight: RFontWeight.REGULAR,
                                              color: kWhiteColor),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Container(
                      width: 150,
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.buyNow!,
                        radius: BorderRadius.all(Radius.circular(34.0)),
                        padding: 0,
                        style: Theme.of(context).textTheme.button!.copyWith(
                            fontWeight: RFontWeight.LIGHT, fontSize: 14),
                        onPressed: () async {
                          if (mPreference.value.userData.posStatus &&
                              _count <= getLocalPinAvailableCount()) {
                            if (await Permission.storage.request().isGranted &&
                                await Permission.manageExternalStorage
                                    .request()
                                    .isGranted) {
                              if (await AppDevice.isAndroid11()) {
                                if (await Permission.manageExternalStorage
                                    .request()
                                    .isGranted) {
                                 await doOrderProcessWithLocal();
                                }
                              } else {
                                await doOrderProcessWithLocal();
                              }
                            } else if (await Permission
                                .storage.shouldShowRequestRationale) {
                            } else {
                              await openAppSettings();
                            }
                          } else {
                            doOrderProcessWithAPI();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  doOrderProcessWithLocal() async {
    List<VoucherDenomination> mPinsForSale = [];
    var json = List<Map<String, dynamic>>.empty(growable: true);
    var mOfflinePins = getUnSoldLocalPinAvailable();
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

    Navigator.pushNamedAndRemoveUntil(context, PageRoutes.voucherCheckOut,
        ModalRoute.withName(PageRoutes.bottomNavigation),
        arguments: {"operator": widget.operator, 'voucher': mPinsForSale});
  }

  doOrderProcessWithAPI() {
    viewModel.requestVoucherSell(
      mServiceId: widget.voucher.serviceId,
      mOperatorId: widget.voucher.operatorId,
      mDenominationId: widget.voucher.id,
      mDenominationCategoryId: widget.voucher.categoryId,
      mQuantity: _count,
      mAmount: widget.voucher.denomination,
    );
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
