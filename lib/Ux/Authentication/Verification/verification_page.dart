import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/otp_text_field.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Authentication/Verification/ViewModel/view_model_verification.dart';
import 'package:daman/main.dart';

class RedirectVerificationModel {
  String username;
  String password;
  String isSales;
  String deviceInfo;
  String deviceDetails;
  String fcmTokenKey;

  RedirectVerificationModel(
    this.username,
    this.password,
    this.isSales,
    this.deviceInfo,
    this.deviceDetails,
    this.fcmTokenKey,
  );
}

class VerificationPage extends StatelessWidget {
  final VoidCallback onVerificationDone;
  final RedirectVerificationModel data;

  VerificationPage(this.data, this.onVerificationDone);

  @override
  Widget build(BuildContext context) {
    return VerificationBody(data, onVerificationDone);
  }
}

class VerificationBody extends StatefulWidget {
  final VoidCallback onVerificationDone;
  final RedirectVerificationModel data;

  VerificationBody(this.data, this.onVerificationDone);

  @override
  State createState() {
    return _VerificationBodyState();
  }
}

class _VerificationBodyState
    extends BasePageState<VerificationBody, ViewModelVerification> {
  var _otp = "";
  var _isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.verifyLoginStream.listen((map) async {
      if (mounted) {
        await mPreference.value.setUserLogin(map);
        widget.onVerificationDone();
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Container(
      decoration: decorationBackground,
      child: Scaffold(
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    child: Image.asset(
                      ARROW_BACK_BLACK,
                      width: 24,
                      height: 36,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget.big(
                    "Confirm your OTP",
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kLightTextColor,
                    fontSize: 27,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget.big(
                    "Verification",
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kMainButtonColor,
                    fontSize: 27,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OTPTextField(
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
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
                    },
                  ),
                ),
                Container(
                  height: 80,
                  margin: EdgeInsets.only(top: 24),
                  color: kMainButtonColor,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: theme.backgroundColor,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: theme.primaryColor,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: mediaQuery.size.width,
                        child: CustomButton(
                          text: "Verification",
                          margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                          radius: BorderRadius.all(Radius.circular(34.0)),
                          onPressed: () async {
                            viewModel.requestVerify(_otp, widget.data);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 66,
          color: kGradientStart.withOpacity(.24),
          child: Center(
            child: InkWell(
              child: TextWidget.big(
                "Resend OTP",
                fontFamily: RFontWeight.REGULAR,
                textAlign: TextAlign.center,
                color: kWhiteColor,
                fontSize: 21,
              ),
              onTap: () {
                viewModel.requestVerify(_otp, widget.data, isResend: true);
              },
            ),
          ),
        ),
      ),
    );
  }
}
