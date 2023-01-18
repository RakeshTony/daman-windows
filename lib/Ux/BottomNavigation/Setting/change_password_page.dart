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
import 'package:daman/Ux/BottomNavigation/Setting/ViewModel/view_model_register.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';

import '../../../Routes/routes.dart';
import '../../../Utils/app_decorations.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangePasswordBody();
  }
}

class ChangePasswordBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends BasePageState<ChangePasswordBody, ViewModelChangePassword> {
  TextEditingController _oldController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  FocusNode _oldNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _passwordConfirmNode = FocusNode();

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

    return  WillPopScope(
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
    color: kMainColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: kTitleBackground, width: 2)),
    child:Container(
    decoration: decorationBackground,
    child: Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kWalletBackground,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.changePassword!,
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
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
            SizedBox(
              height: 16,
            ),
            InputFieldWidget.password(
              AppLocalizations.of(context)!.oldPassword!,
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _oldController,
              focusNode: _oldNode,
            ),
            InputFieldWidget.password(
              AppLocalizations.of(context)!.newPassword!,
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _passwordController,
              focusNode: _passwordNode,
            ),
            InputFieldWidget.password(
              AppLocalizations.of(context)!.confirmPassword!,
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _passwordConfirmController,
              focusNode: _passwordConfirmNode,
            ),
            CustomButton(
              text: AppLocalizations.of(context)!.submit!,
              margin: EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 14),
              radius: BorderRadius.all(Radius.circular(34.0)),
              onPressed: () {
                viewModel.requestChangePassword(_oldController,
                    _passwordController, _passwordConfirmController);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: locale.forgotPassword!,
        color: kMainColor,
        radius: BorderRadius.all(Radius.circular(0.0)),
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    ),),),));
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () async {
        viewModel
            .requestForgotPasswordInside();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue reset password?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
