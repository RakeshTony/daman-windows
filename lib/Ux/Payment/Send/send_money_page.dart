import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../Utils/app_decorations.dart';
import 'ViewModel/view_model_send_money.dart';
class SendMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SendMoneyBody();
  }
}

class SendMoneyBody extends StatefulWidget {
  const SendMoneyBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SendMoneyBodyState();
}

class _SendMoneyBodyState
    extends BasePageState<SendMoneyBody, ViewModelSendMoney> {
  PhoneContact? _phoneContact;
  String? _contact;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var _wallet = HiveBoxes.getBalanceWallet();
  TextEditingController _numberController = TextEditingController();
  FocusNode _numberNode = FocusNode();
  bool isButtonClicked = true;

  @override
  void reassemble() {
    super.reassemble();
    /* if (Platform.isAndroid) {
      controller!.pauseCamera();
    }*/
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) {
      if (mounted) {
        Navigator.pushNamed(context, PageRoutes.payNow, arguments: map.userData);
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: decorationBackground,
      child: Scaffold(
      appBar: AppBarCommonWidget(
        title: "Wallet",
        isShowBalance: false,
        isShowUser: false,
      ),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                color: kTitleBackground,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Payments",
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
                child: ListView(
                  children: [
                    Visibility(
                        visible: isButtonClicked,
                        child: Container(
                          width: mediaQuery.size.width,
                          padding: const EdgeInsets.all(16.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: _buildQrView(context),
                            ),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 0),
                      child: Stack(
                        children: [
                          InputFieldWidget.number(
                            locale.mobileNumber ?? "",
                            padding: EdgeInsets.only(
                                top: 16, right: 48, left: 0, bottom: 16),
                            textEditingController: _numberController,
                            focusNode: _numberNode,
                          ),
                          Visibility(
                            visible: false,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Image.asset(
                                    IC_PHONE_BOOK,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                onTap: () async {
                                  try {
                                    final PhoneContact contact =
                                        await FlutterContactPicker
                                            .pickPhoneContact();
                                    print(contact);
                                    setState(() {
                                      _phoneContact = contact;
                                    });
                                    _numberController.text =
                                        "${_phoneContact!.phoneNumber!.number}";
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Checkout",
                            margin:
                                EdgeInsets.only(top: 16, left: 16, bottom: 16),
                            padding: 0,
                            radius: BorderRadius.all(Radius.circular(34.0)),
                            onPressed: () {
                              viewModel.requestUserWallet(_numberController);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: CustomButton(
                            onPressed: () => {
                              setState(() {
                                isButtonClicked = !isButtonClicked;
                              })
                            },
                            margin:
                            EdgeInsets.only(top: 16, left: 16, bottom: 16),
                            padding: 0,
                            color: kOTPBackground,
                            radius: BorderRadius.all(Radius.circular(34.0)),
                            text: "QR Scan",
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Recent Payments",
                        style: TextStyle(
                          color: kWhiteColor,
                          fontWeight: RFontWeight.REGULAR,
                          fontSize: 14,
                          fontFamily: RFontFamily.POPPINS,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable:
                            HiveBoxes.getRecentTransactions().listenable(),
                        builder: (context, Box<RecentTransaction> data, _) {
                          List<RecentTransaction> items =
                              data.values.take(5).toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) =>
                                _itemTransaction(items[index]),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _numberController.text = "${result!.code}";
        viewModel.requestUserWallet(_numberController);
        _numberController.text = "";
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<bool> _isdevicemodel() async {
    if (Platform.isAndroid) {
      var deviceInfo;
      AndroidDeviceInfo androidInfo = deviceInfo.androidInfo;
      print(androidInfo.model);
    }

    return true;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //
  _itemTransaction(RecentTransaction data) {
    var isCrDr = data.type.equalsIgnoreCases(["transfer", "received"]);
    var url = isCrDr ? data.consider : data.operatorLogo;
    var isCredit = data.consider.equalsIgnoreCase("cr");
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
              Flexible(
                child: Text(
                  data.narration,
                  //textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: isCredit ? kTextAmountCR : kTextAmountDR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${isCredit ? '+' : '-'} ${_wallet?.currencySign ?? ''} ${data.amount.toSeparatorFormat()}",
                    style: TextStyle(
                        color: kWhiteColor,
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
                  data.created.getDateFormat(),
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 14),
                ),
                Flexible(
                  child: Text(
                    "Balance: ${_wallet?.currencySign ?? ""} ${data.closeBal.toSeparatorFormat()}",
                    style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
