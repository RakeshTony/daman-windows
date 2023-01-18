import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_device.dart';
import 'package:daman/main.dart';
import 'package:share_plus/share_plus.dart';

import '../../BluetoothPrinter/bluetooth_scan_print.dart';
import '../../DataBeans/VoucherReprintResponseDataModel.dart';
import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Utils/app_decorations.dart';
import '../../Utils/app_encoder.dart';

class VoucherReprintSharePage extends StatelessWidget {
  final List<VoucherReprintData> data;

  VoucherReprintSharePage(this.data);

  @override
  Widget build(BuildContext context) {
    return VoucherReprintShareBody(data);
  }
}

class VoucherReprintShareBody extends StatefulWidget {
  final List<VoucherReprintData> data;

  VoucherReprintShareBody(this.data);

  @override
  State<StatefulWidget> createState() => _VoucherReprintShareBodyState();
}

class _VoucherReprintShareBodyState
    extends BasePageState<VoucherReprintShareBody, ViewModelCommon> {
  final GlobalKey previewKey = new GlobalKey();
  String deviceId = "";
  var _wallet = HiveBoxes.getBalanceWallet();
  var configs = HiveBoxes.getDefaultConfig();

  DefaultConfig? getConfig() {
    return configs.values.isNotEmpty ? configs.values.first : null;
  }

  @override
  void initState() {
    AppDevice.getDeviceId().then((value) {
      deviceId = value;
      setState(() {});
    });
    super.initState();
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
              subject: 'Voucher',
              text: 'Voucher Successfully',
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          Navigator.pop(context);
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

    return Container(
        decoration: decorationBackground,
        child: Scaffold(
          appBar: AppBarCommonWidget(),
          // appBar: AppBar(),
          backgroundColor: kTransparentColor,
          body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(10),
                color: kWhiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RepaintBoundary(
                      key: previewKey,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => VoucherPrint(
                            widget.data[index], deviceId, mConfig, _wallet),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Share",
                              radius: BorderRadius.all(Radius.circular(26.0)),
                              onPressed: () async {
                                screenShotAndShare(context);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: CustomButton(
                            text: "Get Print",
                            radius: BorderRadius.all(Radius.circular(26.0)),
                            onPressed: () async {
                              List<VoucherDenomination> voucherDenomination =
                                  [];

                              for (int i = 0; i < widget.data.length; i++) {
                                voucherDenomination.insert(
                                    i,
                                    VoucherDenomination(
                                      recordId:
                                          widget.data[i].recordId.toString(),
                                      operatorId: widget.data[i].operatorId,
                                      operatorTitle:
                                          widget.data[i].operatorTitle,
                                      batchNumber: widget.data[i].batchNumber,
                                      pinNumber: widget.data[i].pinNumber,
                                      denominationTitle:
                                          widget.data[i].denominationTitle,
                                      serialNumber: widget.data[i].serialNumber,
                                      decimalValue: widget.data[i].decimalValue,
                                      sellingPrice: widget.data[i].decimalValue,
                                      faceValue: widget.data[i].faceValue,
                                      voucherValidityInDays:
                                          widget.data[i].voucherValidityInDays,
                                      expiryDate:
                                          widget.data[i].voucherValidityInDays,
                                      assignedDate: widget.data[i].assignedDate,
                                      orderNumber: widget.data[i].orderNumber,
                                      usedDate: widget.data[i].used_datetime,
                                      denominationCurrency: "",
                                      denominationCurrencySign: "",
                                      decimalValueConversionPrice:
                                          widget.data[i].decimalValue,
                                      sellingPriceConversionPrice:
                                          widget.data[i].decimalValue,
                                      receiptData: widget.data[i].printData,
                                    ));
                              }
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: kTransparentColor,
                                builder: (context) => BluetoothScanPrintBody(
                                    data: voucherDenomination,
                                    dId: deviceId,
                                    opInst: widget.data[0].printData),
                              );
                              // Navigator.pushNamed(context, PageRoutes.bluetoothScanPrint,arguments: args);
                            },
                          )),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}

class VoucherPrint extends StatelessWidget {
  VoucherReprintData data;
  String deviceId;
  var mConfig;
  var _wallet;

  VoucherPrint(
    this.data,
    this.deviceId,
    this.mConfig,
    this._wallet,
  );

  String getFormattedString(String pinNumber) {
    var buffer = new StringBuffer();
    for (int i = 0; i < pinNumber.length; i++) {
      buffer.write(pinNumber[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != pinNumber.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          AppImage(data.operatorLogo, 90),
          Visibility(
            visible: false,
            child: Column(
              children: [
                Text(
                  "${mConfig?.website}",
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.BOLD,
                  ),
                ),
                Text(
                  "Customer Care Email: " + "${mConfig?.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.BOLD,
                  ),
                ),
                Text(
                  "Customer Care Line: " + "${mConfig?.contactNo}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.BOLD,
                  ),
                ),
                Text(
                  "WhatsApp Care Line:" + "${mConfig?.whatsAppNo}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.BOLD,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "${data.denominationTitle}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kMainTextColor,
              fontSize: 18,
              fontWeight: RFontWeight.BOLD,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          _getRow_2("Date", "${data.assignedDate}", "رقم المعاملة", context),
          //_getRow("Shop Name", mPreference.value.userData.shopCode, context),
          // _getRow("Customer Receipt", "${data.batchNumber}"),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
          _getRow("Amount ",
              "${_wallet?.currencySign ?? ""} ${data.decimalValue}", context),
          // _getRow_4("${data.pinNumber.replaceAll(RegExp("[0-9]"), "#")}"),
          _getRow_4(
              "Pin",
              getFormattedString(Encoder.decodeDefault("${data.pinNumber}")),
              context),
          _getRow_5("${data.printData}", context),

          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
          _getRow_2("Serial", "${data.serialNumber}", "مسلسل", context),
          _getRow_2(
              "Order Number", "${data.orderNumber}", "رقم المعاملة", context),
          _getRow_2(
              "Expiry", "${data.voucherValidityInDays}", "انقضاء", context),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
          _getRow_2("Sold By", "${mPreference.value.userData.name}", "تممن قبل",
              context),
          _getRow_2("Terminal", "$deviceId", "انقضاء", context),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
        ],
      ),
    );
  }

  _getRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          LimitedBox(
            child: Text(
              "$label",
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 14,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
          LimitedBox(
            child: Text(
              "$value",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 14,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getRow_2(String label, String value, String ar_label, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: LimitedBox(
          maxWidth: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "$label",
                    style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 14,
                      fontWeight: RFontWeight.BOLD,
                    ),
                  )),
              LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "$value",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 14,
                      fontWeight: RFontWeight.BOLD,
                    ),
                  )),
              /*LimitedBox(
              maxWidth: MediaQuery.of(context).size.width,
              child:Text(
            "$ar_label",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: kMainTextColor,
              fontSize: 14,
              fontWeight: RFontWeight.BOLD,
            ),
          )),*/
            ],
          ),
        ));
  }

  _getRow_3(String label, String ar_label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LimitedBox(
            child: Text(
              "$label",
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 14,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
          LimitedBox(
            child: Text(
              "$ar_label",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 14,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getRow_4(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label",
            style: TextStyle(
              color: kMainTextColor,
              fontSize: 18,
              fontWeight: RFontWeight.BOLD,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          LimitedBox(
            child: Text(
              "$value",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 18,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getRow_5(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          LimitedBox(
            child: Text(
              "$label",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 12,
                fontWeight: RFontWeight.REGULAR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
