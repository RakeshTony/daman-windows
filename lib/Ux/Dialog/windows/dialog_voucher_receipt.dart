import 'dart:io';
import 'dart:typed_data';

import 'package:daman/Database/models/balance.dart';
import 'package:daman/Ux/Wallet/ViewModel/view_model_wallet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_device.dart';
import 'package:daman/main.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Database/hive_boxes.dart';
import '../../../Database/models/default_config.dart';
import '../../../Utils/app_encoder.dart';
import 'package:pdf/widgets.dart' as pw;

class DialogVoucherReceipt extends StatefulWidget {
  final List<VoucherDenomination> data;
  final Operator operator;

  DialogVoucherReceipt(this.data, this.operator);

  @override
  State<StatefulWidget> createState() => _DialogVoucherReceiptState();
}

class _DialogVoucherReceiptState
    extends BasePageState<DialogVoucherReceipt, ViewModelWallet> {
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 360,
            minWidth: 360,
          ),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: InkWell(
                          child: Icon(Icons.close, color: kWhiteColor),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 48, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
/*
                        Expanded(
                          child: CustomButton(
                            text: AppLocalizations.of(context)!.share!,
                            radius: BorderRadius.all(Radius.circular(26.0)),
                            onPressed: () async {
                              */
/*screenShotAndShare(context);*/ /*

                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
*/
                        Expanded(
                            child: CustomButton(
                          text: AppLocalizations.of(context)!.getPrint!,
                          radius: BorderRadius.all(Radius.circular(26.0)),
                          onPressed: () async {
                            printDocument();
                          },
                        )),
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

  void printDocument() async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(widget.operator.logo))
            .load(widget.operator.logo))
        .buffer
        .asUint8List();
    var mConfig = getConfig();
    final doc = pw.Document();
    var font = await getFont();
    for (int index = 0; widget.data.length > index; index++) {
      var mData = VoucherPrintable(widget.data[index], deviceId,
          widget.operator, mConfig, _wallet, bytes, font);
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll57,
          build: (pw.Context context) {
            return mData.getPrintableReceiptPOS();
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
}

class VoucherPrint extends StatelessWidget {
  final VoucherDenomination data;
  final Operator operator;
  final String deviceId;
  final DefaultConfig? mConfig;
  final Balance? _wallet;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: kWhiteColor,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                AppImage(operator.logo, 90),
                _getRow_1("Terminal ID", "$deviceId", "انقضاء"),
                _getRow_1(
                    "Transaction ID", "${data.orderNumber}", "رقم المعاملة"),
                SizedBox(
                  height: 10,
                ),
                _getRow_4("Pin Code", "الرقم السري", 24),
                SizedBox(
                  height: 10,
                ),
                _getRow_2(
                    getFormattedString(data.pinNumber),
                    /*getFormattedString(
                        Encoder.decodeDefault("${data.pinNumber}")),*/
                    32),
                SizedBox(
                  height: 10,
                ),
                _getRow_4(
                    "Value" + "(" + "${_wallet?.currencySign ?? ""}" + ")",
                    "قيمة",
                    22),
                _getRow_2("${data.decimalValue}", 32),
                SizedBox(
                  height: 5,
                ),
                _getRow_2(_getFormattedDate("${data.assignedDate}"), 18),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                  child: Divider(
                    color: kBorder,
                    height: .5,
                  ),
                ),
                _getRow_4("Serial Number", "رقم سري", 24),
                SizedBox(
                  height: 5,
                ),
                _getRow_2("${data.serialNumber}", 22),
                SizedBox(
                  height: 10,
                ),
                _getRow_3("${operator.inst}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getRow_1(String label, String value, String ar_label) {
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

  _getRow_2(String value, double fontSizeLbl) {
    return FittedBox(
      child: Text(
        "$value",
        style: TextStyle(
          color: kMainTextColor,
          fontSize: fontSizeLbl,
          fontWeight: RFontWeight.BOLD,
        ),
      ),
    );
  }

  _getRow_3(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FittedBox(
        child: Text(
          "$label",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kMainTextColor,
            fontSize: 18,
            fontWeight: RFontWeight.REGULAR,
          ),
        ),
      ),
    );
  }

  _getRow_4(String label, String value, double fontSizeLbl) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label",
            style: TextStyle(
              color: kMainTextColor,
              fontSize: fontSizeLbl,
              fontWeight: RFontWeight.BOLD,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            "$value",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kMainTextColor,
              fontSize: fontSizeLbl,
              fontWeight: RFontWeight.BOLD,
            ),
          ),
        ],
      ),
    );
  }
}

String _getFormattedDate(String dateStr) {
  var inputDate = DateTime.parse(dateStr);
  var outputFormat = DateFormat('dd-MM-yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

getFont() async {
  final font = await rootBundle.load("fonts/NotoSansArabic-Regular.ttf");
  return pw.Font.ttf(font);
}

class VoucherPrintable {
  VoucherDenomination data;
  Operator operator;
  String deviceId;
  DefaultConfig? mConfig;
  Balance? _wallet;
  Uint8List image;
  pw.Font font;

  VoucherPrintable(
    this.data,
    this.deviceId,
    this.operator,
    this.mConfig,
    this._wallet,
    this.image,
    this.font,
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

  getPrintableReceiptPOS() {
    return pw.Container(
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            color: PDF_WHITE,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.SizedBox(
                  height: 10,
                ),
                pw.Container(
                  height: 48,
                  width: 48,
                  child: pw.ClipRRect(
                    horizontalRadius: 24,
                    verticalRadius: 24,
                    child: pw.Image(
                      pw.MemoryImage(image),
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
                pw.SizedBox(
                  height: 8,
                ),
                _getRow_1("Terminal ID", "$deviceId", "انقضاء"),
                _getRow_1(
                    "Transaction ID", "${data.orderNumber}", "رقم المعاملة"),
                _getRow_4("Pin Code", "الرقم السري", 9),
                pw.SizedBox(
                  height: 4,
                ),
                _getRow_2(
                    getFormattedString(
                        Encoder.decodeDefault("${data.pinNumber}")),
                    14),
                _getRow_4(
                    "Value" + "(" + "${_wallet?.currencySign ?? ""}" + ")",
                    "قيمة",
                    10),
                _getRow_2("${data.decimalValue}", 14),
                pw.SizedBox(
                  height: 5,
                ),
                _getRow_2(_getFormattedDate("${data.assignedDate}"), 8),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 6),
                  child: pw.Divider(
                    color: PDF_BORDER,
                    height: .5,
                  ),
                ),
                _getRow_4("Serial Number", "رقم سري", 9),
                _getRow_2("${data.serialNumber}", 9),
                pw.SizedBox(height: 5),
                _getRow_3("${operator.inst}"),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 32),
                  child: pw.Divider(
                    color: PDF_BORDER,
                    height: .5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getRow_1(String label, String value, String ar_label) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
              child: pw.Text(
            "$label: $value",
            textAlign: pw.TextAlign.justify,
            style: pw.TextStyle(
              color: PDF_MAIN_TEXT_COLOR,
              fontSize: 8,
            ),
          ))
        ]);
  }

  _getRow_2(String value, double fontSizeLbl) {
    return pw.FittedBox(
      child: pw.Text(
        "$value",
        style: pw.TextStyle(
          color: PDF_MAIN_TEXT_COLOR,
          fontSize: fontSizeLbl,
        ),
      ),
    );
  }

  _getRow_3(String label) {
    return pw.FittedBox(
      child: pw.Text(
        "$label",
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PDF_MAIN_TEXT_COLOR,
          fontSize: 12,
          fontBold: font,
        ),
      ),
    );
  }

  _getRow_4(String label, String value, double fontSizeLbl) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            "$label",
            textAlign: pw.TextAlign.justify,
            style: pw.TextStyle(
              color: PDF_MAIN_TEXT_COLOR,
              fontSize: fontSizeLbl,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            " $value",
            textAlign: pw.TextAlign.justify,
            style: pw.TextStyle(
              color: PDF_MAIN_TEXT_COLOR,
              fontSize: fontSizeLbl,
              font: font,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  var PDF_MAIN_TEXT_COLOR = PdfColor.fromInt(kMainTextColor.value);
  var PDF_BORDER = PdfColor.fromInt(kBorder.value);
  var PDF_WHITE = PdfColor.fromInt(kWhiteColor.value);
}
