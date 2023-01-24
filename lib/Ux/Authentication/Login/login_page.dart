import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_helper.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_button.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Ux/Authentication/Login/ViewModel/view_model_login.dart';
import 'package:daman/Ux/Dialog/dialog_country_picker.dart';
import 'package:daman/main.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Utils/Widgets/input_field_widget_white_theme.dart';
import '../../../Utils/app_device.dart';
import '../../../Utils/app_encoder.dart';
import '../../../Utils/app_log.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBody();
  }
}

class LoginBody extends StatefulWidget {
  @override
  State createState() {
    return _LoginBodyState();
  }
}

class _LoginBodyState extends BasePageState<LoginBody, ViewModelLogin> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _numberNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  late GlobalKey<FormState> formState;
  List<CountryData> countries = [];
  CountryData? _countrySelected;

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else if (Platform.isWindows) {
        deviceData;
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    formState = GlobalKey<FormState>();
    viewModel.requestCountries();
    viewModel.countriesStream.listen((map) {
      if (mounted) {
        if (countries.isNotEmpty) countries.clear();
        countries.addAll(map);
        if (_countrySelected == null && countries.isNotEmpty) {
          var selected = countries.firstWhere(
              (element) => element.id.endsWith(AppSettings.COUNTRY_ID),
              orElse: null);
          if (selected == null)
            _countrySelected = countries.first;
          else
            _countrySelected = selected;
          setState(() {});
        }
      }
    }, cancelOnError: false);
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) async {
      if (mounted) {
        switch (map.second.getStatusCode) {
          case 200: // LOGIN SUCCESSFULLY
            {
              await mPreference.value.setUserLogin(map.second);
              Navigator.pushNamed(context, PageRoutes.sync);
              break;
            }
          case 201: // GO TO OTP VERIFICATION
            {
              Navigator.pushNamed(context, PageRoutes.verification,
                  arguments: map.first);
              break;
            }
        }
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Container(
        decoration: decorationBackground,
        alignment: Alignment.center,
        child: Container(
            margin: EdgeInsets.all(24),
            constraints: BoxConstraints(
              minHeight: 720,
              maxHeight: 720,
              maxWidth: 480,
              minWidth: 480,
            ),
            decoration: BoxDecoration(
                color: kScreenBackgroundNew,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTitleBackground, width: 2)),
            child: Scaffold(
              backgroundColor: kTransparentColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 52,
                        ),
                        Image.asset(
                          LOGO,
                          width: 192,
                          height: 90,
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        TextWidget.big(
                          locale.signIn!,
                          fontFamily: RFontWeight.REGULAR,
                          textAlign: TextAlign.center,
                          color: kColor_1,
                          fontSize: 27,
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 33, right: 33),
                          child: Stack(
                            children: [
                              InputFieldWidgetWhiteTheme.number(
                                locale.mobileNumber ?? "",
                                padding: EdgeInsets.only(
                                    top: 12, right: 10, left: 40, bottom: 12),
                                textEditingController: _numberController,
                                focusNode: _numberNode,

                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 8),
                                  child: Text(
                                    "+${_countrySelected?.phoneCode}",
                                    style: AppStyleText.inputFiledPrimaryText2,
                                  ),
                                ),
                                onTap: () {
                                  var dialogCountryPicker = DialogCountryPicker(
                                    data: countries,
                                    onTap: (country) {
                                      _countrySelected = country;
                                      setState(() {});
                                    },
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          dialogCountryPicker);
                                },
                              )
                            ],
                          ),
                        ),
                        InputFieldWidgetWhiteTheme.password(
                          locale.password ?? "",
                          margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                          textEditingController: _passwordController,
                          focusNode: _passwordNode,
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: mediaQuery.size.width,
                          child: CustomButton(
                            text: locale.signIn,
                            margin:
                                EdgeInsets.only(top: 14, left: 33, right: 33),
                            radius: BorderRadius.all(Radius.circular(30.0)),
                            onPressed: () async {
                              if (await Permission.storage
                                  .request()
                                  .isGranted) {
                                if (await AppDevice.isAndroid11()) {
                                  if (await Permission.manageExternalStorage
                                      .request()
                                      .isGranted) {
                                    viewModel.requestLogin(
                                        _numberController,
                                        _passwordController,
                                        _deviceData.toString());
                                  }
                                } else {
                                  viewModel.requestLogin(
                                      _numberController,
                                      _passwordController,
                                      _deviceData.toString());
                                }
                              } else if (await Permission
                                  .storage.shouldShowRequestRationale) {
                              } else {
                                await openAppSettings();
                              }
                            },
                          ),
                        ),
                        Container(
                          width: mediaQuery.size.width,
                          padding: EdgeInsets.only(top: 24),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.forgotPassword);
                              },
                              child: Text(
                                locale.forgotPassword!,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: RFontWeight.REGULAR,
                                    color: kColor_1,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 80),
                padding: EdgeInsets.symmetric(horizontal: 33),
                height: 66,
                /*decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kGradientEnd,
                  kGradientStart,
                ],
              ),
            ),*/
                child: Row(
                  children: [
                    Image.asset(
                      USER_ADD,
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontWeight: RFontWeight.REGULAR,
                              fontSize: 14,
                              color: kColor_1,
                            ),
                            children: [
                              TextSpan(
                                  text: "Signup",
                                  style: TextStyle(
                                    fontWeight: RFontWeight.BOLD,
                                    fontSize: 18,
                                    color: kColor_1,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, PageRoutes.signUp);
                                    })
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
