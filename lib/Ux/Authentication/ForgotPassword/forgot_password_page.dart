import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Authentication/ForgotPassword/ViewModel/view_model_forgot_password.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';

import '../../../Utils/Widgets/input_field_widget_white_theme.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordBody();
  }
}

class ForgotPasswordBody extends StatefulWidget {
  @override
  State createState() {
    return _ForgotPasswordBodyState();
  }
}

class _ForgotPasswordBodyState
    extends BasePageState<ForgotPasswordBody, ViewModelForgotPassword> {
  TextEditingController _numberController = TextEditingController();

  FocusNode _numberNode = FocusNode();

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
            actionText: "Go To Login",
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
    return Container(
      alignment: Alignment.center,
      decoration: decorationBackground,
      child: Container(
        margin: EdgeInsets.all(24),
    constraints: BoxConstraints(
    minHeight: 720,
    maxHeight: 720,
    maxWidth: 480,
    minWidth: 480,
    ),
    decoration: BoxDecoration(
    color: kMainColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: kTitleBackground, width: 2)),
    child: Scaffold(
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 48,
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: Image.asset(LOGO),
              ),
              SizedBox(
                height: 100,
              ),
              TextWidget.big(
                "Forgot Password",
                fontFamily: RFontWeight.REGULAR,
                textAlign: TextAlign.center,
                color: kColor_1,
                fontSize: 27,
              ),
              SizedBox(
                height: 27,
              ),
              InputFieldWidgetWhiteTheme.number(
                "User ID / Mobile Number",
                margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                textEditingController: _numberController,
                focusNode: _numberNode,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                width: mediaQuery.size.width,
                child: CustomButton(
                  text: "Submit",
                  margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                  radius: BorderRadius.all(Radius.circular(34.0)),
                  onPressed: () async {
                    viewModel.requestForgotPassword(_numberController);
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 66,

          child: Center(
            child: RichText(
              text: TextSpan(
                  text: "Back To ",
                  style: TextStyle(
                      fontWeight: RFontWeight.LIGHT,
                      fontSize: 17,
                      color: kColor_1),
                  children: [
                    TextSpan(
                        text: "Login",
                        style: TextStyle(
                            fontWeight: RFontWeight.REGULAR,
                            fontSize: 17,
                            color: kColor_1),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          })
                  ]),
            ),
          ),
        )),
      ),
    );
  }
}
