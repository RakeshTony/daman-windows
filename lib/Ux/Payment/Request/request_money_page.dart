import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/SystemBankDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_fund_type.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Utils/pair.dart';
import 'package:daman/Ux/Dialog/dialog_image_picker.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Payment/Request/ViewModel/view_model_fund_request.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../Utils/app_decorations.dart';
import '../../../Utils/app_log.dart';
import '../../../main.dart';

class RequestMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RequestMoneyBody();
  }
}

class RequestMoneyBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestMoneyBodyState();
}

class _RequestMoneyBodyState
    extends BasePageState<RequestMoneyBody, ViewModelFundRequest> {
  SystemBankData bankSystem = SystemBankData(bankName: "Select Bank");
  SystemBankData bankUser = SystemBankData(bankName: "Select User Bank");
  Pair<String, String> paymentType = Pair("Payment Type", "");
  FundType mFundType = FundType.ADD_MONEY;
  TextEditingController _settleCreditController = TextEditingController();
  FocusNode _settleCreditNode = FocusNode();
  TextEditingController _amountController = TextEditingController();
  FocusNode _amountNode = FocusNode();
  TextEditingController _remarkController = TextEditingController();
  FocusNode _remarkNode = FocusNode();
  var user = mPreference.value.userData;

  TextEditingController _paymentDateController = TextEditingController();
  FocusNode _paymentDateNode = FocusNode();

  var _paymentDate = DateTime.now();
  var _initialDate = DateTime.now();
  late String deviceId;

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.systemBankStream.listen((map) {
      if (spinnerItemsSystemBanks.isNotEmpty) spinnerItemsSystemBanks.clear();
      spinnerItemsSystemBanks.add(bankSystem);
      spinnerItemsSystemBanks.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.userBankStream.listen((map) {
      if (spinnerItemsUserBanks.isNotEmpty) spinnerItemsUserBanks.clear();
      spinnerItemsUserBanks.add(bankUser);
      spinnerItemsUserBanks.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);

    viewModel.responseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              Navigator.pop(context);
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
    viewModel.requestSystemBank();
  }

  _setInitialDate() {
    if (_initialDate.isBefore(_paymentDate)) {
      _initialDate = _paymentDate;
      _initialDate.add(Duration(days: 1));
    }
  }

  _setDateTime() {
    _setInitialDate();
    _paymentDateController.text = _paymentDate.getDate();
  }

  SystemBankData? dropdownValueSystemBank;
  SystemBankData? dropdownValueUserBank;

  //'Select System Bank'
  List<SystemBankData> spinnerItemsSystemBanks = [];
  List<SystemBankData> spinnerItemsUserBanks = [];

  Pair<String, String>? dropdownValuePaymentType;
  List<Pair<String, String>> spinnerPaymentType = [];

  /*
    Pair("Payment Type", ""),
    Pair("Payment Type", "Bank"),
    Pair("Payment Type", "Cash")
*/

  final ImagePicker _picker = ImagePicker();
  File? _mSelectedReceipt;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    if (dropdownValuePaymentType == null)
      dropdownValuePaymentType = paymentType;
    if (spinnerPaymentType.isEmpty) {
      spinnerPaymentType.add(paymentType);
      spinnerPaymentType.add(Pair("Bank Transfer", "Bank"));
      spinnerPaymentType.add(Pair("Cash Deposit", "Cash"));
    }

    if (dropdownValueSystemBank == null) {
      dropdownValueSystemBank = bankSystem;
    }

    if (spinnerItemsSystemBanks.isEmpty)
      spinnerItemsSystemBanks.add(bankSystem);

    if (dropdownValueUserBank == null) {
      dropdownValueUserBank = bankUser;
    }
    if (spinnerItemsUserBanks.isEmpty) spinnerItemsUserBanks.add(bankUser);

    return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
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
                color: kColor_1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTitleBackground, width: 2)),
            child: Container(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kMainButtonColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.walletTopup!,
                            style: TextStyle(
                                fontSize: 14,
                                color: kWhiteColor,
                                fontWeight: RFontWeight.LIGHT,
                                fontFamily: RFontFamily.POPPINS),
                          ),
                          Visibility(
                              visible: false,
                              child: Container(
                                width: 120,
                                height: 36,
                                child: CustomButton(
                                  text: "Topup Report",
                                  radius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  padding: 0,
                                  style: TextStyle(
                                      fontFamily: RFontFamily.POPPINS,
                                      fontWeight: RFontWeight.LIGHT,
                                      fontSize: 14,
                                      color: kWhiteColor),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, PageRoutes.fundRequestReport);
                                  },
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: InkWell(
                              child: Icon(Icons.close, color: kWhiteColor),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: Text(
                              AppLocalizations.of(context)!.paymentMode!,
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 16,
                                fontWeight: RFontWeight.LIGHT,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: Row(
                              children: [
                                /*Expanded(
                            child: InkWell(
                              child: Row(
                                children: [
                                  Image.asset(
                                    mFundType == FundType.BANK_CARD
                                        ? IC_RADIO_ACTIVE
                                        : IC_RADIO,
                                    width: 32,
                                    height: 32,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Wallet Topup - Bank Card",
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 14,
                                        fontWeight: RFontWeight.LIGHT,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                deviceId = await getDeviceID();
                                AppAction.openWebPage(context, "Wallet Topup - Bank Card",
                                    "${AppSettings.BASE_URL}payments/manual_refill_wallet");
                              },
                            ),
                          ),*/
                                Expanded(
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          mFundType == FundType.ADD_MONEY
                                              ? IC_RADIO_ACTIVE
                                              : IC_RADIO,
                                          width: 32,
                                          height: 32,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .walletTransferTopupRequest!,
                                            style: TextStyle(
                                              color: kWhiteColor,
                                              fontSize: 14,
                                              fontWeight: RFontWeight.LIGHT,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        mFundType = FundType.ADD_MONEY;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: user.isCredit,
                                  child: Expanded(
                                    child: InkWell(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            mFundType == FundType.CREDIT_MONEY
                                                ? IC_RADIO_ACTIVE
                                                : IC_RADIO,
                                            width: 32,
                                            height: 32,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .creditRequest!,
                                              style: TextStyle(
                                                color: kWhiteColor,
                                                fontSize: 14,
                                                fontWeight: RFontWeight.LIGHT,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          mFundType = FundType.CREDIT_MONEY;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(color: kWhiteColor),
                          ),
                          Visibility(
                            visible: mFundType == FundType.ADD_MONEY,
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: 16, right: 16, top: 16),
                              padding: EdgeInsets.only(top: 14, bottom: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: kTextInputInactive),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SystemBankData>(
                                  value: dropdownValueSystemBank,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  isDense: true,
                                  style: AppStyleText.inputFiledPrimaryText,
                                  onChanged: (data) {
                                    setState(() {
                                      dropdownValueSystemBank = data!;
                                    });
                                  },
                                  items: spinnerItemsSystemBanks
                                      .map<DropdownMenuItem<SystemBankData>>(
                                          (SystemBankData value) {
                                    return DropdownMenuItem<SystemBankData>(
                                      value: value,
                                      child: Text(value.bankName),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            //visible: mFundType == FundType.ADD_MONEY,
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: 16, right: 16, top: 16),
                              padding: EdgeInsets.only(top: 14, bottom: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: kTextInputInactive),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(right: 30),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<SystemBankData>(
                                        value: dropdownValueUserBank,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        isDense: true,
                                        style:
                                            AppStyleText.inputFiledPrimaryText,
                                        onChanged: (data) {
                                          setState(() {
                                            dropdownValueUserBank = data!;
                                          });
                                        },
                                        items: spinnerItemsUserBanks.map<
                                                DropdownMenuItem<
                                                    SystemBankData>>(
                                            (SystemBankData value) {
                                          return DropdownMenuItem<
                                              SystemBankData>(
                                            value: value,
                                            child: Text(value.bankName),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, PageRoutes.addBank);
                                      },
                                      child: Image.asset(
                                        IC_BANK,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: mFundType == FundType.ADD_MONEY,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              margin:
                                  EdgeInsets.only(top: 12, left: 16, right: 16),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: kTextInputInactive),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Pair<String, String>>(
                                  value: dropdownValuePaymentType,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  isDense: true,
                                  style: AppStyleText.inputFiledPrimaryText,
                                  onChanged: (data) {
                                    setState(() {
                                      dropdownValuePaymentType = data!;
                                      setState(() {});
                                    });
                                  },
                                  items: spinnerPaymentType.map<
                                          DropdownMenuItem<
                                              Pair<String, String>>>(
                                      (Pair<String, String> value) {
                                    return DropdownMenuItem<
                                        Pair<String, String>>(
                                      value: value,
                                      child: Text(value.first),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: mFundType == FundType.ADD_MONEY,
                            child: GestureDetector(
                              onTap: () async {
                                var dateTime = await _pickPaymentDate(context);
                                _paymentDate = dateTime ?? _paymentDate;
                                _setDateTime();
                              },
                              child: AbsorbPointer(
                                child: InputFieldWidget.text(
                                  AppLocalizations.of(context)!.paymentDate!,
                                  margin: EdgeInsets.only(
                                      top: 14, left: 16, right: 16),
                                  textEditingController: _paymentDateController,
                                  focusNode: _paymentDateNode,
                                  readOnly: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: user.isCredit,
                            child: InputFieldWidget.number(
                              AppLocalizations.of(context)!.settleCredits!,
                              margin:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              textEditingController: _settleCreditController,
                              focusNode: _settleCreditNode,
                            ),
                          ),
                          InputFieldWidget.number(
                            AppLocalizations.of(context)!.enterAmount!,
                            margin:
                                EdgeInsets.only(top: 16, left: 16, right: 16),
                            textEditingController: _amountController,
                            focusNode: _amountNode,
                          ),
                          InputFieldWidget.text(
                            AppLocalizations.of(context)!.remark!,
                            margin: EdgeInsets.only(
                                top: 16, left: 16, right: 16, bottom: 24),
                            textEditingController: _remarkController,
                            focusNode: _remarkNode,
                          ),
                          Visibility(
                            visible: mFundType == FundType.ADD_MONEY,
                            child: Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      var dialogImagePicker = DialogImagePicker(
                                        (source) {
                                          _doPickImage(source);
                                        },
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              dialogImagePicker);
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .uploadReceipt!),
                                  ),
                                  Expanded(
                                      child: _mSelectedReceipt != null
                                          ? Container(
                                              child: Image.file(
                                                  _mSelectedReceipt!),
                                              height: 56,
                                            )
                                          : Container(
                                              width: 0,
                                            ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: mediaQuery.size.width,
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.makeRequest!,
                        margin: EdgeInsets.only(
                            top: 12, left: 16, right: 16, bottom: 16),
                        radius: BorderRadius.all(Radius.circular(34.0)),
                        onPressed: () {
                          viewModel.requestFundRequest(
                            _amountController,
                            _remarkController,
                            _settleCreditController,
                            mFundType,
                            dropdownValueSystemBank,
                            dropdownValueUserBank,
                            dropdownValuePaymentType,
                            _paymentDateController,
                            _mSelectedReceipt,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<Null> _doPickImage(ImageSource source) async {
    XFile? pickedImage =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedImage != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                ]
              : [
                  CropAspectRatioPreset.square,
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: kMainColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Cropper',
          ));
      if (croppedFile != null) {
        _mSelectedReceipt = croppedFile;
        if (mounted) setState(() {});
      }
    }
  }

  Future<DateTime?> _pickPaymentDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }

  Future<String> getDeviceID() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    String _deviceId;
    if (Platform.isAndroid)
      _deviceId = (await _deviceInfo.androidInfo).androidId ?? "";
    else
      _deviceId = (await _deviceInfo.iosInfo).identifierForVendor ?? "";
    AppLog.i("TOKEN DEVICE ID : " + _deviceId);
    return _deviceId;
  }
}
