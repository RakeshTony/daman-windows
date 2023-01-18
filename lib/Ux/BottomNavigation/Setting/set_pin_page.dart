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
import 'package:daman/main.dart';

import '../../../Utils/app_decorations.dart';
import '../../Dialog/dialog_success.dart';
import 'ViewModel/view_model_set_m_pin.dart';

class SetPinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetPinBody();
  }
}

class SetPinBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetPinBodyState();
}

class _SetPinBodyState extends BasePageState<SetPinBody, ViewModelSetMPin> {
  TextEditingController _newController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  FocusNode _newNode = FocusNode();
  FocusNode _confirmNode = FocusNode();

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
              mPreference.value.mPin = _newController.text.trim();
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
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child:Container(
            decoration: decorationBackground,
            child: Scaffold(
        extendBodyBehindAppBar: true,

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
                      mPreference.value.mPin.isEmpty ? AppLocalizations.of(context)!.resetMPin! : AppLocalizations.of(context)!.resetMPin!,
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

              InputFieldWidget.password(
                AppLocalizations.of(context)!.newPin!,
                disableSpace: true,
                maxLength: 4,
                inputType: RInputType.TYPE_NUMBER_PASSWORD,
                margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                textEditingController: _newController,
                focusNode: _newNode,
              ),
              InputFieldWidget.password(
                AppLocalizations.of(context)!.confirmPin!,
                disableSpace: true,
                maxLength: 4,
                inputType: RInputType.TYPE_NUMBER_PASSWORD,
                margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                textEditingController: _confirmController,
                focusNode: _confirmNode,
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                text: AppLocalizations.of(context)!.submit!,
                margin:
                    EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                radius: BorderRadius.all(Radius.circular(34.0)),
                onPressed: () {
                  var pin = _newController.text.trim();
                  var confirmPin = _confirmController.text.trim();
                  var error = "";
                  if (pin.isEmpty) {
                    error = AppLocalizations.of(context)!.pleaseEnterPin!;
                  } else if (pin.length != 4) {
                    error = AppLocalizations.of(context)!.pleaseEnter4DigitPin!;
                  } else if (confirmPin.isEmpty) {
                    error = AppLocalizations.of(context)!.pleaseEnterConfirmPin!;
                  } else if (confirmPin.length != 4) {
                    error = AppLocalizations.of(context)!.pleaseEnter4DigitConfirmPin!;
                  } else if (confirmPin != pin) {
                    error = AppLocalizations.of(context)!.pinNotMatch!;
                  }
                  if (error.isEmpty) {
                    viewModel.requestSetMPin(_newController);
                  } else {
                    AppAction.showGeneralErrorMessage(context, error);
                  }
                },
              ),
            ],
          ),
        ),
      ),),),),
    );
  }
}
