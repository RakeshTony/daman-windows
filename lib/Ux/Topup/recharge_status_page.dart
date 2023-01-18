import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:daman/DataBeans/OperatorValidateDataModel.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Widgets/SeparatorDot.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/BulkTopUpResponseDataModel.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/GetParamsDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/main.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Database/models/operator.dart';
import '../../Utils/app_settings.dart';

class RechargeStatusPage extends StatelessWidget {
  TopUpDenomination data;
  ParamOperatorModel operator;
  CurrencyData currency;
  String receiptNo;
  String subscriberTitle;
  OperatorValidateData? operatorInfo;

  RechargeStatusPage({
    required this.data,
    required this.operator,
    required this.currency,
    required this.receiptNo,
    required this.subscriberTitle,
    this.operatorInfo,
  });

  @override
  Widget build(BuildContext context) {
    return RechargeStatusBody(
      data: data,
      operator: operator,
      currency: currency,
      receiptNo: receiptNo,
      subscriberTitle: subscriberTitle,
      operatorInfo: operatorInfo,
    );
  }
}

class RechargeStatusBody extends StatefulWidget {
  TopUpDenomination data;
  ParamOperatorModel operator;
  CurrencyData currency;
  String receiptNo;
  String subscriberTitle;
  OperatorValidateData? operatorInfo;

  RechargeStatusBody({
    required this.data,
    required this.operator,
    required this.currency,
    required this.receiptNo,
    required this.subscriberTitle,
    this.operatorInfo,
  });

  @override
  State<StatefulWidget> createState() => _RechargeStatusBodyState();
}

class _RechargeStatusBodyState
    extends BasePageState<RechargeStatusBody, ViewModelCommon> {
  final GlobalKey previewKey = new GlobalKey();
  var mOperators = HiveBoxes.getOperators();
  var mServices = HiveBoxes.getServices();

  Service getServiceName() {
    return mServices.values.singleWhere(
        (element) => element.id == widget.operator.serviceId,
        orElse: () => Service());
  }

  List<Operator> filterData = [];
  var config = HiveBoxes.getDefaultConfig();

  DefaultConfig? getConfig() {
    return config.values.isNotEmpty ? config.values.first : null;
  }

  @override
  void initState() {
    super.initState();
    filterData.addAll(mOperators.values
        .where((element) => element.id == widget.operator.id)
        .toList());
  }

  Future<Null> screenShotAndShare(BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary = previewKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage();
      if (image != null) {
        final directory = (await pathProvider.getTemporaryDirectory()).path;
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          File? imgFile = File('$directory/screenshot.png');
          imgFile.writeAsBytes(pngBytes);
          final RenderBox box = context.findRenderObject() as RenderBox;
          Share.shareFiles([File('$directory/screenshot.png').path],
              subject: 'Recharge',
              text: 'Recharge Successfully',
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        }
      }
    } on PlatformException catch (e) {
      print("Exception while taking screenshot:" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    var mConfig = getConfig();
    return Scaffold(
      appBar: AppBarCommonWidget(
        backgroundColor:
            widget.data.response ? theme.primaryColor : kColorFailed,
        isShowBalance: false,
        isShowUser: false,
        isShowShare: widget.data.response,
        doShare: () {
          screenShotAndShare(context);
        },
      ),
      // appBar: AppBar(),
      backgroundColor: kScreenBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: RepaintBoundary(
              key: previewKey,
              child: Stack(
                children: [
                  Container(
                    color: widget.data.response ? kTextAmountCR : kTextAmountDR,
                    height: 100,
                  ),
                  Container(
                    child: ListView(
                      shrinkWrap: true,
                      controller: ScrollController(),
                      children: [
                        Container(
                          color: kWhiteColor,
                          child: Text(
                            getServiceName().title + " Receipt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kMainTextColor,
                              fontSize: 14,
                              fontWeight: RFontWeight.BOLD,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              widget.data.response
                                  ? "Recharge Successfully"
                                  : "Recharge Failed",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 18,
                                fontWeight: RFontWeight.LIGHT,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 36),
                          child: Column(
                            children: [
                              Visibility(
                                visible: true,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  color: theme.backgroundColor,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _getRow('Receipt Number',
                                          widget.receiptNo, false),
                                      Container(
                                        color: kWhiteColor,
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 0, top: 0),
                                        child: _getRow(
                                            'Date & Time',
                                            DateTime.now().getDateTimeFormat(),
                                            false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      CARVE_LEFT,
                                      height: 48,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 48,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        color: kWhiteColor,
                                        child: SeparatorDot(),
                                      ),
                                    ),
                                    Image.asset(
                                      CARVE_RIGHT,
                                      height: 48,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: kWhiteColor,
                                height: 12,
                              ),
                              Container(
                                color: kWhiteColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: filterData.first.logo,
                                        fit: BoxFit.fill,
                                        width: 45,
                                        height: 45,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          DEFAULT_OPERATOR,
                                          width: 45,
                                          height: 45,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          DEFAULT_OPERATOR,
                                          width: 45,
                                          height: 45,
                                        ),
                                      )
                                      /*FadeInImage(
                                        image: NetworkImage(filterData.first.logo),
                                        fit: BoxFit.fill,
                                        width: 45,
                                        height: 45,
                                        placeholder: AssetImage(DEFAULT_OPERATOR),
                                        imageErrorBuilder:
                                            ((context, error, stackTrace) {
                                          return Image.asset(
                                            DEFAULT_OPERATOR,
                                            width: 45,
                                            height: 45,
                                          );
                                        }),
                                      )*/
                                      ,
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: kWhiteColor,
                                height: 12,
                              ),
                              Visibility(
                                visible: widget.operatorInfo == null,
                                child: _getRow(widget.subscriberTitle,
                                    "${widget.data.mobile}", false),
                              ),
                              Visibility(
                                visible: widget.operatorInfo != null,
                                child: Container(
                                  color: theme.backgroundColor,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _getRow(
                                          "Account Number",
                                          widget.operatorInfo?.accountNo ?? "",
                                          false),
                                      _getRow("Number", "${widget.data.mobile}",
                                          false),
                                      //widget.operatorInfo?.meterNo ?? "",
                                      _getRow(
                                          "Account Type",
                                          widget.operatorInfo?.type ?? "",
                                          false),
                                    ],
                                  ),
                                ),
                              ),
                              _getRow(
                                  'Operator', "${widget.operator.title}", true),
                              Visibility(
                                // visible: widget.data.response,
                                child: Container(
                                  color: theme.backgroundColor,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16, top: 8),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              _getRow_1("Txn ID",
                                                  "${widget.data.operatorsId}"),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              _getRow_1("OneCard Txn ID",
                                                  "${widget.data.txnId}"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        child: _getRow(
                                            'MID No.',
                                            mPreference.value.userData.shopCode,
                                            false),
                                        // visible: mPreference.value.userData.shopCode.isNotEmpty,
                                        visible: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _getRow(
                                  'Amount Paid',
                                  "${widget.currency.sign}${widget.data.amount.toSeparatorFormat()}",
                                  false),
                              /*_getRow(
                                  'Unit Receive',
                                  "${widget.currency.sign}${widget.data.recAmount.toSeparatorFormat()}",
                                  false),
                              _getRow(
                                  'Recharge Status',
                                  "${widget.data.response ? "Success" : "Failed"}",
                                  true,
                                  color: widget.data.response
                                      ? kTextAmountCR
                                      : kTextAmountDR),
                              */
                              Visibility(
                                visible: widget.data.response == false,
                                child: _getRow(
                                  'Failure Reason ',
                                  "${widget.data.mnoResponse}",
                                  false,
                                ),
                              ),
                              Visibility(
                                visible: widget.operatorInfo != null,
                                child: Container(
                                  color: theme.backgroundColor,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _getRow(
                                          'Customer Name',
                                          widget.operatorInfo?.customerName ??
                                              "",
                                          false),
                                      _getRow(
                                          'Customer Phone',
                                          widget.operatorInfo?.phoneNumber ??
                                              "",
                                          false),
                                      /* _getRow(
                                          'Customer Type',
                                          (widget.operatorInfo?.type ?? "")
                                              .replaceAll("OFFLINE_", "")),*/
                                      _getRow(
                                          'Customer Address',
                                          widget.operatorInfo
                                                  ?.customerAddress ??
                                              "",
                                          false),
                                    ],
                                  ),
                                ),
                              ),
                              _getRow('Merchant Name',
                                  mPreference.value.userData.name, false),
                              _getRow('Merchant Phone',
                                  mPreference.value.userData.mobile, false),
                              Visibility(
                                child: _getRow('Merchant Location',
                                    mPreference.value.userData.address, false),
                                visible: mPreference
                                    .value.userData.address.isNotEmpty,
                              ),
                              /*Visibility(
                                visible: widget.data.response == false,
                                child: Container(
                                  width: mediaQuery.size.width,
                                  color: theme.backgroundColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 40),
                                    child: Text(
                                      "${widget.data.status}",
                                      style: TextStyle(
                                        color: kMainTextColor,
                                        fontSize: 12,
                                        fontWeight: RFontWeight.LIGHT,
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/
                              Visibility(
                                child: Container(
                                  color: theme.backgroundColor,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8, left: 16, right: 16),
                                        child: Text(
                                          "${widget.data.printData}",
                                          style: TextStyle(
                                            color: kMainTextColor,
                                            fontSize: 12,
                                            fontWeight: RFontWeight.LIGHT,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: widget.data.printData.isNotEmpty,
                              ),
                              /*Visibility(
                                child: Container(
                                  color: theme.backgroundColor,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8, left: 16, right: 16),
                                        child: Text(
                                          "${widget.data.mnoResponse}",
                                          style: TextStyle(
                                            color: kMainTextColor,
                                            fontSize: 12,
                                            fontWeight: RFontWeight.LIGHT,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: widget.data.mnoResponse.isNotEmpty,
                              ),*/
                              Container(
                                color: theme.backgroundColor,
                                height: 12,
                              ),
                              Visibility(
                                  visible: widget.data.extraDetails.isNotEmpty,
                                  child: _getExtraDetails(
                                      widget.data.extraDetails)),
                              Container(
                                color: kWhiteColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Powered by",
                                        style: TextStyle(
                                            color: kMainTextColor,
                                            fontSize: 18,
                                            fontWeight: RFontWeight.REGULAR,
                                            fontFamily: RFontFamily.POPPINS),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: kWhiteColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        LOGO,
                                        height: 33,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: kWhiteColor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${mConfig?.website}",
                                          style: TextStyle(
                                            color: kMainTextColor,
                                            fontSize: 14,
                                            fontWeight: RFontWeight.BOLD,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                        visible: true,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Customer Care:",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize: 14,
                                                fontWeight: RFontWeight.BOLD,
                                              ),
                                            ),
                                            Text(
                                              "Email: " + "${mConfig?.email}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize: 14,
                                                fontWeight: RFontWeight.BOLD,
                                              ),
                                            ),
                                            Text(
                                              "Telephone: ${mConfig?.contactNo}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize: 14,
                                                fontWeight: RFontWeight.BOLD,
                                              ),
                                            ),
                                            Text(
                                              "WhatsApp: ${mConfig?.whatsAppNo}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize: 14,
                                                fontWeight: RFontWeight.BOLD,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                color: theme.backgroundColor,
                                height: 12,
                              ),
                              Image.asset(
                                widget.data.response
                                    ? VOUCHER_STRIP_SINGLE
                                    : VOUCHER_STRIP_SINGLE,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 48, vertical: 24),
                          child: CustomButton(
                            text: "Share",
                            radius: BorderRadius.all(Radius.circular(26.0)),
                            onPressed: () async {
                              screenShotAndShare(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getRow(String label, String value, bool isBold,
      {Color color = kMainTextColor}) {
    return Container(
      color: kWhiteColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "$label",
                style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 12,
                    fontWeight: isBold ? RFontWeight.BOLD : RFontWeight.REGULAR,
                    fontFamily: RFontFamily.POPPINS),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                ":",
                style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 12,
                    fontWeight: isBold ? RFontWeight.BOLD : RFontWeight.REGULAR,
                    fontFamily: RFontFamily.POPPINS),
              ),
            ),
            Expanded(
              child: Text(
                "$value",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isBold ? RFontWeight.BOLD : RFontWeight.REGULAR,
                    fontFamily: RFontFamily.POPPINS),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRow_1(String label, String value,
      {double textSize = 12, FontWeight fontWeight = RFontWeight.REGULAR}) {
    return Container(
      color: kWhiteColor,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "$label",
                style: TextStyle(
                  color: kMainTextColor,
                  fontSize: textSize,
                  fontWeight: fontWeight,
                  fontFamily: RFontFamily.POPPINS,
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
                fontFamily: RFontFamily.POPPINS,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getExtraDetails(List<ExtraDetails> extras) {
    List<Widget> widgets = [];
    extras.forEach((e) {
      widgets.add(_getRow(e.key, e.value, e.isBold));
    });
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: widgets),
    );
  }
}
