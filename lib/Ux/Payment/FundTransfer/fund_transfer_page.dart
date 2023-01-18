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
import 'package:daman/Ux/Dialog/dialog_success.dart';

import '../../../DataBeans/DefaultBankDataModel.dart';
import '../../../Utils/Enum/enum_baneficiary_type.dart';
import '../../../Utils/app_style_text.dart';
import 'ViewModel/view_model_fund_transfer.dart';

class FundTransferPage extends StatelessWidget {
  FundTransferPage();

  @override
  Widget build(BuildContext context) {
    return FundTransferBody();
  }
}

class FundTransferBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FundTransferBodyState();
}

class _FundTransferBodyState
    extends BasePageState<FundTransferBody, ViewModelFundTransfer> {
  TextEditingController _senderAccountNumber = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  DefaultBank defaultBank = DefaultBank(bankName: "Select Sender Bank");
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
  BeneficiaryType mBeneficiaryType = BeneficiaryType.SELF;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
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
                    "Fund Transfer",
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
                            "Sender Account Number",
                            margin:
                                EdgeInsets.only(top: 14, left: 16, right: 16),
                            padding: EdgeInsets.only(
                                right: 100, top: 12, bottom: 12),
                            textEditingController: _senderAccountNumber,
                            focusNode: _beneficiaryAccountNumberNode,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              viewModel.validateBeneficiary(
                                _senderAccountNumber,
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
                      /*viewModel.bankTransferDirect(
                          mBeneficiaryType.value,
                          _beneficiaryAccountNumber,
                          _firstName,
                          _lastName,
                          _paymentMethod,
                          _mobileNumber,
                          _emailAddress,
                          dropdownValueAccountType,
                          dropdownValueBank?.id ?? "",
                          );*/
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
