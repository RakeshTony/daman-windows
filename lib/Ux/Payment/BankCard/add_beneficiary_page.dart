import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:collection/src/iterable_extensions.dart';

import '../../../DataBeans/DefaultBankDataModel.dart';
import '../../../DataBeans/MyBankAccountDataModel.dart';
import '../../../Utils/Enum/enum_baneficiary_type.dart';
import '../../../Utils/app_style_text.dart';
import 'ViewModel/view_model_add_beneficiary.dart';

class AddBeneficiaryPage extends StatelessWidget {
  MyBankAccount? account;
  int type;

  AddBeneficiaryPage(this.type, this.account);

  @override
  Widget build(BuildContext context) {
    return AddBeneficiaryBody(type, account);
  }
}

class AddBeneficiaryBody extends StatefulWidget {
  MyBankAccount? account;
  int type;

  AddBeneficiaryBody(this.type, this.account);

  @override
  State<StatefulWidget> createState() => _AddBeneficiaryBodyState();
}

class _AddBeneficiaryBodyState
    extends BasePageState<AddBeneficiaryBody, ViewModelAddBeneficiary> {
  TextEditingController _beneficiaryAccountNumber = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  DefaultBank defaultBank = DefaultBank(bankName: "Select Bank");
  TextEditingController _paymentMethod = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _emailAddress = TextEditingController();
  FocusNode _beneficiaryAccountNumberNode = FocusNode();
  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();
  FocusNode _paymentMethodNode = FocusNode();
  FocusNode _mobileNumberNode = FocusNode();
  FocusNode _emailAddressNode = FocusNode();

  @override
  void initState() {
    super.initState();
    mBeneficiaryType =
        widget.type == 1 ? BeneficiaryType.OTHER : BeneficiaryType.SELF;
    if (widget.account != null) {
      dropdownValueAccountType = widget.account?.accountType ?? "Account Type";
      _beneficiaryAccountNumber.text = widget.account?.number ?? "";
      _firstName.text = widget.account?.firstName ?? "";
      _lastName.text = widget.account?.lastName ?? "";
      _paymentMethod.text = widget.account?.paymentMethod ?? "";
      _mobileNumber.text = widget.account?.phone ?? "";
      _emailAddress.text = widget.account?.email ?? "";
    }
    viewModel.requestBankList();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.defaultBankStream.listen((map) {
      if (spinnerItemsBanks.isNotEmpty) spinnerItemsBanks.clear();
      spinnerItemsBanks.add(defaultBank);
      spinnerItemsBanks.addAll(map);
      dropdownValueBank = spinnerItemsBanks.firstWhereOrNull(
          (element) => (widget.account?.bankId ?? "") == element.id);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.validateStream.listen((event) {
      if (event.sourceAccountName.isNotEmpty) {
        var firstName = event.sourceAccountName;
        var lastName = "";
        if (event.sourceAccountName.contains(" ")) {
          var index = event.sourceAccountName.indexOf(" ");
          firstName = event.sourceAccountName.substring(0, index);
          lastName = event.sourceAccountName
              .substring(index, event.sourceAccountName.length);
        }
        _firstName.text = firstName;
        _lastName.text = lastName;
      }
    });
    viewModel.responseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              Navigator.pop(context, "RELOAD");
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
  }

  DefaultBank? dropdownValueBank;
  List<DefaultBank> spinnerItemsBanks = [];
  String dropdownValueAccountType = "Account Type";
  List<String> spinnerAccountType = ["Account Type", "Saving", "Current"];
  BeneficiaryType mBeneficiaryType = BeneficiaryType.SELF;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    if (dropdownValueAccountType.isEmpty)
      dropdownValueAccountType = "Account Type";
    if (dropdownValueBank == null) dropdownValueBank = defaultBank;
    if (spinnerItemsBanks.isEmpty) spinnerItemsBanks.add(defaultBank);
    return Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Add Beneficiary",
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
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Row(
                              children: [
                                Image.asset(
                                  mBeneficiaryType == BeneficiaryType.SELF
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
                                    "Self",
                                    style: TextStyle(
                                      color: kMainTextColor,
                                      fontSize: 14,
                                      fontWeight: RFontWeight.LIGHT,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                mBeneficiaryType = BeneficiaryType.SELF;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Row(
                              children: [
                                Image.asset(
                                  mBeneficiaryType == BeneficiaryType.OTHER
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
                                    "Other",
                                    style: TextStyle(
                                      color: kMainTextColor,
                                      fontSize: 14,
                                      fontWeight: RFontWeight.LIGHT,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                mBeneficiaryType = BeneficiaryType.OTHER;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: kTextInputInactive),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValueAccountType,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        isDense: true,
                        style: AppStyleText.inputFiledPrimaryText,
                        onChanged: (data) {
                          setState(() {
                            dropdownValueAccountType = data!;
                            setState(() {});
                          });
                        },
                        items: spinnerAccountType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: kTextInputInactive),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<DefaultBank>(
                        isExpanded: true,
                        value: dropdownValueBank,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        isDense: true,
                        style: AppStyleText.inputFiledPrimaryText,
                        onChanged: (data) {
                          setState(() {
                            dropdownValueBank = data!;
                            setState(() {});
                          });
                        },
                        items: spinnerItemsBanks
                            .map<DropdownMenuItem<DefaultBank>>(
                                (DefaultBank value) {
                          return DropdownMenuItem<DefaultBank>(
                            value: value,
                            child: Text(
                              value.bankName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 56,
                    child: Stack(
                      children: [
                        Container(
                          child: InputFieldWidget.number(
                            "Beneficiary Account number",
                            margin:
                                EdgeInsets.only(top: 14, left: 16, right: 16),
                            padding: EdgeInsets.only(
                                right: 100, top: 12, bottom: 12),
                            textEditingController: _beneficiaryAccountNumber,
                            focusNode: _beneficiaryAccountNumberNode,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              viewModel.validateBeneficiary(
                                _beneficiaryAccountNumber,
                                dropdownValueBank?.id ?? "",
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 16, top: 8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  color: kMainButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.security_sharp,
                                    color: kWhiteColor,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Validate",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kWhiteColor,
                                      fontWeight: RFontWeight.MEDIUM,
                                      fontFamily: RFontFamily.POPPINS,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InputFieldWidget.text(
                    "First Name",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _firstName,
                    focusNode: _firstNameNode,
                  ),
                  InputFieldWidget.text("Last Name",
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _lastName,
                      focusNode: _lastNameNode),
                  InputFieldWidget.text("Payment Method",
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _paymentMethod,
                      focusNode: _paymentMethodNode),
                  InputFieldWidget.number(
                    "Mobile Number",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _mobileNumber,
                    focusNode: _mobileNumberNode,
                  ),
                  InputFieldWidget.text("Email Address",
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _emailAddress,
                      focusNode: _emailAddressNode),
                  CustomButton(
                    text: "Submit",
                    margin: EdgeInsets.only(
                        top: 36, left: 56, right: 56, bottom: 14),
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    onPressed: () {
                      viewModel.requestAddBeneficiary(
                          mBeneficiaryType.value,
                          _beneficiaryAccountNumber,
                          _firstName,
                          _lastName,
                          _paymentMethod,
                          _mobileNumber,
                          _emailAddress,
                          dropdownValueAccountType,
                          dropdownValueBank?.id ?? "",
                          widget.account?.recordId ?? "");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
