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
import 'ViewModel/view_model_add_beneficiary.dart';

class TransferBankCardPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return TransferBankCardBody();
  }
}

class TransferBankCardBody extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _TransferBankCardBodyState();
}

class _TransferBankCardBodyState
    extends BasePageState<TransferBankCardBody, ViewModelTransferMoney> {


  TextEditingController _amount = TextEditingController();
  TextEditingController _confirmAmount = TextEditingController();
  TextEditingController _remark = TextEditingController();
  FocusNode _amountNode = FocusNode();
  FocusNode _confirmAmountNode = FocusNode();
  FocusNode _remarkNode = FocusNode();


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


  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    color: theme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          "Wallet Topup - Bank Card",
                          style: TextStyle(
                              fontSize: 14,
                              color: kWhiteColor,
                              fontWeight: RFontWeight.LIGHT,
                              fontFamily: RFontFamily.POPPINS),
                        ),
                      ],
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
                    text: "Submit",
                    margin: EdgeInsets.only(
                        top: 36, left: 56, right: 56, bottom: 14),
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    onPressed: (){
                      /*ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Text("Coming Soon..."),
                      ));*/
                     viewModel.redirectBankCardPaymentMethod(_amount, _confirmAmount, _remark,context);
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
