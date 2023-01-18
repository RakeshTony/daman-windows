import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/DefaultBankDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_baneficiary_type.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Ux/BottomNavigation/Setting/ViewModel/view_model_register.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Payment/BankCard/ViewModel/view_model_transfer_money.dart';

import '../../../DataBeans/MyBankAccountDataModel.dart';
import '../../../Utils/app_decorations.dart';
import 'ViewModel/view_model_add_beneficiary.dart';

class TransferMoneyPage extends StatelessWidget {
  final MyBankAccount account;

  TransferMoneyPage(this.account);

  @override
  Widget build(BuildContext context) {
    return TransferMoneyBody(account);
  }
}

class TransferMoneyBody extends StatefulWidget {
  final MyBankAccount account;

  TransferMoneyBody(this.account);

  @override
  State<StatefulWidget> createState() => _TransferMoneyBodyState();
}

class _TransferMoneyBodyState
    extends BasePageState<TransferMoneyBody, ViewModelTransferMoney> {
  MyBankAccount defaultBank = MyBankAccount(bankName: "Select Bank");

  TextEditingController _amount = TextEditingController();
  TextEditingController _confirmAmount = TextEditingController();
  TextEditingController _remark = TextEditingController();
  FocusNode _amountNode = FocusNode();
  FocusNode _confirmAmountNode = FocusNode();
  FocusNode _remarkNode = FocusNode();

  MyBankAccount? dropdownValueBank;
  List<MyBankAccount> spinnerItemsBanks = [];

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.banksStream.listen((map) {
      if (spinnerItemsBanks.isNotEmpty) spinnerItemsBanks.clear();
      spinnerItemsBanks.add(defaultBank);
      spinnerItemsBanks.addAll(map);
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
    viewModel.requestMyBankAccount(BeneficiaryType.SELF.value);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    if (dropdownValueBank == null) dropdownValueBank = defaultBank;
    if (spinnerItemsBanks.isEmpty) spinnerItemsBanks.add(defaultBank);

    return Container(
        decoration: decorationBackground,
        child: Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: _itemMyBankAccountTest(),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.only(top: 0, left: 16, right: 16),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: kTextInputInactive),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<MyBankAccount>(
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
                            .map<DropdownMenuItem<MyBankAccount>>(
                                (MyBankAccount value) {
                          return DropdownMenuItem<MyBankAccount>(
                            value: value,
                            child: Text(value.bankName),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  InputFieldWidget.number(
                    "Amount",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _amount,
                    focusNode: _amountNode,
                  ),
                  InputFieldWidget.number(
                    "Confirm Amount",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _confirmAmount,
                    focusNode: _confirmAmountNode,
                  ),
                  InputFieldWidget.text(
                    "Remark",
                    margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                    textEditingController: _remark,
                    focusNode: _remarkNode,
                  ),
                  CustomButton(
                    text: "Transfer Money",
                    margin: EdgeInsets.only(
                        top: 36, left: 56, right: 56, bottom: 14),
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    onPressed: () async {
                      var senderBankId = dropdownValueBank?.bankId ?? "";
                      var amount = _amount.text.trim();
                      var confirm = _confirmAmount.text.trim();
                      var remark = _remark.text.trim();
                      var error =
                          _validateDetails(senderBankId, amount, confirm,remark);
                      if (error.isNotEmpty) {
                        AppAction.showGeneralErrorMessage(context, error);
                      } else {
                        var status = await Navigator.pushNamed(
                            context, PageRoutes.enterPin);
                        if (status == "SUCCESS") {
                          viewModel.requestTransferMoney(
                              dropdownValueBank,
                              widget.account,
                              _amount,
                              _confirmAmount,
                              _remark);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }

  String _validateDetails(String senderBankId, String amount, String confirm, String remark) {
    if (senderBankId.isEmpty)
      return "Please Select Bank";
    else if (amount.isEmpty)
      return "Please Enter Amount";
    else if (confirm.isEmpty)
      return "Please Enter Confirm Amount";
    else if (!confirm.endsWith(amount))
      return "Amount Not Match";
    else if (remark.isEmpty)
      return "Please Enter Remark";
    else
      return "";
  }

  _itemMyBankAccountTest() {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 10),
        leading: AppImage(
          widget.account.bankLogo,
          50,
          borderColor: kWhiteColor,
          borderWidth: 2,
          backgroundColor: kWhiteColor,
          defaultImage: DEFAULT_PERSON,
        ),
        title: Text(
          widget.account.firstName + " " + widget.account.lastName,
          style: TextStyle(
              color: kWhiteColor,
              fontFamily: RFontFamily.POPPINS,
              fontWeight: RFontWeight.REGULAR,
              fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(widget.account.number,
            style: TextStyle(
              color: kWhiteColor,
              fontFamily: RFontFamily.POPPINS,
              fontWeight: RFontWeight.LIGHT,
              fontSize: 14,
            )),
        trailing: Text(
          "${widget.account.accountType}",
          style: TextStyle(
              color: kWhiteColor,
              fontFamily: RFontFamily.POPPINS,
              fontWeight: RFontWeight.REGULAR,
              fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
