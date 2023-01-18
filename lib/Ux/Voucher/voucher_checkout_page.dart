import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_device.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/main.dart';
import 'package:share_plus/share_plus.dart';

import '../../BluetoothPrinter/bluetooth_scan_print.dart';
import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Utils/app_encoder.dart';
import '../Wallet/ViewModel/view_model_wallet.dart';

class VoucherCheckOutPage extends StatelessWidget {
  final List<VoucherDenomination> data;
  final Operator operator;

  VoucherCheckOutPage(this.data, this.operator);

  @override
  Widget build(BuildContext context) {
    return VoucherCheckOutBody(data, operator);
  }
}

class VoucherCheckOutBody extends StatefulWidget {
  final List<VoucherDenomination> data;
  final Operator operator;

  VoucherCheckOutBody(this.data, this.operator);

  @override
  State<StatefulWidget> createState() => _VoucherCheckOutBodyState();
}

class _VoucherCheckOutBodyState
    extends BasePageState<VoucherCheckOutBody, ViewModelWallet> {
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
    viewModel.requestUpdatePinSoldStatus();
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: previewKey,
                child: Container(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => VoucherPrint(
                        widget.data[index],
                        deviceId,
                        widget.operator,
                        mConfig,
                        _wallet),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.share!,
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
                      text: AppLocalizations.of(context)!.getPrint!,
                      radius: BorderRadius.all(Radius.circular(26.0)),
                      onPressed: () async {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: kTransparentColor,
                          builder: (context) => BluetoothScanPrintBody(
                              data: widget.data,
                              dId: deviceId,
                              opInst: widget.operator.inst),
                        );
                        // Navigator.pushNamed(context, PageRoutes.bluetoothScanPrint,arguments: args);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherPrint extends StatelessWidget {
  VoucherDenomination data;
  Operator operator;
  String deviceId;
  var mConfig;
  var _wallet;

  VoucherPrint(
    this.data,
    this.deviceId,
    this.operator,
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
      margin: EdgeInsets.all(16),
      color: kWhiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          AppImage(operator.logo, 90),
          Column(
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
          _getRow("Customer Receipt", "${data.batchNumber}"),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
          _getRow(
              "Amount", "${_wallet?.currencySign ?? ""} ${data.decimalValue}"),
          // _getRow_4("${data.pinNumber.replaceAll(RegExp("[0-9]"), "#")}"),
          _getRow_4("Pin",
              getFormattedString(Encoder.decodeDefault("${data.pinNumber}"))),
          _getRow_5("${operator.inst}"),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
          _getRow_2("Serial", "${data.serialNumber}", "مسلسل"),
          _getRow_2("TxnID", "${data.orderNumber}", "رقم المعاملة"),
          _getRow_2("Expiry", "${data.expiryDate}", "انقضاء"),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
            child: Divider(
              color: kBorder,
              height: .5,
            ),
          ),
          _getRow_2(
              "Sold By", "${mPreference.value.userData.name}", "تممن قبل"),
          _getRow_2("Date", "${data.assignedDate}", "رقم المعاملة"),
          _getRow_2("Terminal", "$deviceId", "انقضاء"),
          SizedBox(
            height: 10,
          )
        ],
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
                fontSize: 14,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
          Expanded(
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

  _getRow_2(String label, String value, String ar_label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label",
            style: TextStyle(
              color: kMainTextColor,
              fontSize: 14,
              fontWeight: RFontWeight.BOLD,
            ),
          ),
          Expanded(
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
          /*Text(
            "$ar_label",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: kMainTextColor,
              fontSize: 14,
              fontWeight: RFontWeight.BOLD,
            ),
          ),*/
        ],
      ),
    );
  }

  _getRow_3(String label, String ar_label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$label",
              style: TextStyle(
                color: kMainTextColor,
                fontSize: 14,
                fontWeight: RFontWeight.BOLD,
              ),
            ),
          ),
          Expanded(
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

  _getRow_4(String label, String value) {
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
          Expanded(
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

  _getRow_5(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          Expanded(
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
