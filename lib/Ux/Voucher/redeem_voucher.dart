import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';

import 'ViewModel/view_redeem_voucher.dart';

class RedeemVoucher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RedeemVoucherBody();
  }
}

class RedeemVoucherBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RedeemVoucherBodyState();
}

class _RedeemVoucherBodyState
    extends BasePageState<RedeemVoucherBody, ViewModelRedeemVoucher> {
  TextEditingController _newController = TextEditingController();
  FocusNode _newNode = FocusNode();

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
        child: ListView(
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Redeem Voucher",
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            /* InputFieldWidget.text(
              "Enter voucher code",
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _newController,
              focusNode: _newNode,
            ),*/
            Container(
                margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                child: TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(hintText: "Enter voucher code"),
                  controller: _newController,
                  focusNode: _newNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    new CustomInputFormatter()
                  ],
                ))
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: "Submit",
        margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        radius: BorderRadius.all(Radius.circular(34.0)),
        onPressed: () {
          viewModel.requestRedeemVoucher(_newController);
        },
      ),
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
