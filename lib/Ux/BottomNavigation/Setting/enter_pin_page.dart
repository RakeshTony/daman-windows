import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/otp_text_field.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Ux/BottomNavigation/Setting/ViewModel/view_model_enter_m_pin.dart';
import 'package:daman/main.dart';

import '../../../Utils/app_decorations.dart';

class EnterPinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnterPinBody();
  }
}

class EnterPinBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnterPinBodyState();
}

class _EnterPinBodyState
    extends BasePageState<EnterPinBody, ViewModelEnterMPin> {
  @override
  void initState() {
    super.initState();
    viewModel.responseStream.listen((event) {
      if (event.getStatus) {
        mPreference.value.clear();
        Phoenix.rebirth(context);
      }
    });
  }

  var _otp = "";
  var _isOtpComplete = false;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      alignment: Alignment.center,
      decoration: decorationBackground,
      child: Container(
        padding: EdgeInsets.only(top: 10),
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
          child:Scaffold(
        appBar: AppBarCommonWidget(
          isShowNotification: false,
        ),
        // appBar: AppBar(),
        backgroundColor: kTransparentColor,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kTitleBackground,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.enterServerPin!,
                      style: TextStyle(
                          fontSize: 14,
                          color: kWhiteColor,
                          fontWeight: RFontWeight.LIGHT,
                          fontFamily: RFontFamily.POPPINS),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!.resetMPin!),
                                content: Text(
                                    AppLocalizations.of(context)!.confirmResetPinMessage!),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: <Widget>[
                                  Container(
                                    child: MaterialButton(
                                      child: Text(AppLocalizations.of(context)!.no!),
                                      textColor: kMainColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: kMainColor)),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  Container(
                                    child: MaterialButton(
                                      child: Text(AppLocalizations.of(context)!.yes!),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: kMainColor)),
                                      textColor: kMainColor,
                                      onPressed: () {
                                        viewModel.requestResetMPin();
                                        //mPreference.value.clear();
                                        //Phoenix.rebirth(context);
                                      },
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            color: kMainButtonColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          AppLocalizations.of(context)!.reset!,
                          style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 12,
                            fontWeight: RFontWeight.MEDIUM,
                            fontFamily: RFontFamily.SOFIA_PRO,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Directionality(textDirection: TextDirection.ltr,
                    child:
                      OTPTextField(
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceBetween,
                        fieldWidth: 50,
                        fieldStyle: FieldStyle.oval,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: RFontWeight.REGULAR,
                            color: kWhiteColor),
                        onChanged: (pin) {
                          print("Changed: " + pin);
                          _otp = pin;
                          _isOtpComplete = false;
                        },
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                          _otp = pin;
                          _isOtpComplete = true;
                          checkPin(_otp);
                        },
                      )),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: mediaQuery.size.width,
                child: CustomButton(
                  text: AppLocalizations.of(context)!.continueSubmit!,
                  radius: BorderRadius.all(Radius.circular(34.0)),
                  onPressed: () {
                    checkPin(_otp);
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: InkWell(
                  child: TextWidget.big(
                    AppLocalizations.of(context)!.cancel!,
                    fontFamily: RFontWeight.LIGHT,
                    textAlign: TextAlign.center,
                    color: kMainColor,
                    fontSize: 20,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void checkPin(String pin) {
    if (mPreference.value.mPin == pin)
      Navigator.pop(context, "SUCCESS");
    else
      AppAction.showGeneralErrorMessage(context, "Invalid M-Pin");
  }
}
