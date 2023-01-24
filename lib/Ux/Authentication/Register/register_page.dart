import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/DistrictDataModel.dart';
import 'package:daman/DataBeans/StateDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Ux/Authentication/Register/ViewModel/view_model_register.dart';
import 'package:daman/Ux/Dialog/dialog_country_picker.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';

import '../../../Utils/Widgets/input_field_widget_white_theme.dart';
import '../../../main.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RegisterBody();
  }
}

class RegisterBody extends StatefulWidget {
  @override
  State createState() {
    return _RegisterBodyState();
  }
}

class _RegisterBodyState
    extends BasePageState<RegisterBody, ViewModelRegister> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  StateData stateData = StateData(title: "Select State");
  DistrictData districtData = DistrictData(title: "Select Local Govt");

  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _numberNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _passwordConfirmNode = FocusNode();

  List<CountryData> countries = [];
  CountryData? _countrySelected;

  StateData? dropdownValueState;
  List<StateData> spinnerItemsState = [];

  DistrictData? dropdownValueDistrict;
  List<DistrictData> spinnerItemsDistrict = [];

  @override
  void initState() {
    super.initState();
    viewModel.requestCountries();
    viewModel.requestStateList(AppSettings.COUNTRY_ID);
    if (spinnerItemsState.isEmpty) spinnerItemsState.add(stateData);
    if (spinnerItemsDistrict.isEmpty) spinnerItemsDistrict.add(districtData);
    viewModel.countriesStream.listen((map) {
      if (mounted) {
        if (countries.isNotEmpty) countries.clear();
        countries.addAll(map);
        var selected = countries.firstWhere(
            (element) => element.id.endsWith(AppSettings.COUNTRY_ID),
            orElse: null);
        if (selected == null)
          _countrySelected = countries.first;
        else
          _countrySelected = selected;
        setState(() {});
      }
    }, cancelOnError: false);
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
    viewModel.stateStream.listen((map) {
      if (spinnerItemsState.isNotEmpty) spinnerItemsState.clear();
      spinnerItemsState.add(stateData);
      spinnerItemsState.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.districtStream.listen((map) {
      if (spinnerItemsDistrict.isNotEmpty) spinnerItemsDistrict.clear();
      spinnerItemsDistrict.add(districtData);
      spinnerItemsDistrict.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);

  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    if (dropdownValueState == null) {
      dropdownValueState = stateData;
    }
    if (dropdownValueDistrict == null) {
      dropdownValueDistrict = districtData;
    }

    return Container(
      alignment: Alignment.center,
      decoration: decorationBackground,
      child:Container(
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
          child:
      Scaffold(
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Image.asset(
                    LOGO,
                    width: 192,
                    height: 90,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  TextWidget.big(
                    "Signup",
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kColor_1,
                    fontSize: 27,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  /*State Spinner*/
                  Visibility(
                    visible: true,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 33, right: 33, top: 16),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: kMainTextColor),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<StateData>(
                          value: dropdownValueState,
                          icon: Icon(Icons.arrow_drop_down,color: kColor_1,),
                          iconSize: 24,
                          elevation: 16,
                          isDense: true,
                          style: AppStyleText.inputFiledPrimaryText2,
                          onChanged: (data) {
                            setState(() {
                              dropdownValueState = data!;
                              spinnerItemsDistrict.clear();
                              spinnerItemsDistrict.add(districtData);
                              dropdownValueDistrict = districtData;
                              var mStateId = dropdownValueState?.id ?? "";
                              if (mStateId.isNotEmpty) {
                                viewModel.requestDistrictList(mStateId);
                              }
                            });
                          },
                          items: spinnerItemsState
                              .map<DropdownMenuItem<StateData>>(
                                  (StateData value) {
                                return DropdownMenuItem<StateData>(
                                  value: value,
                                  child: Text(value.title),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                  /*Local Govt Spinner*/
                  Visibility(
                    visible: true,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 33, right: 33, top: 16),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: kMainTextColor),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<DistrictData>(
                          value: dropdownValueDistrict,
                          icon: Icon(Icons.arrow_drop_down,color: kColor_1),
                          iconSize: 24,
                          elevation: 16,
                          isDense: true,
                          style: AppStyleText.inputFiledPrimaryText2,
                          onChanged: (data) {
                            setState(() {
                              dropdownValueDistrict = data!;
                            });
                          },
                          items: spinnerItemsDistrict
                              .map<DropdownMenuItem<DistrictData>>(
                                  (DistrictData value) {
                                return DropdownMenuItem<DistrictData>(
                                  value: value,
                                  child: Text(value.title,style:TextStyle(color: kMainTextColor),),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                  InputFieldWidgetWhiteTheme.text(
                    "Name",
                    margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                    textEditingController: _nameController,
                    focusNode: _nameNode,
                  ),
                  InputFieldWidgetWhiteTheme.email(
                    "Email Address",
                    margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                    textEditingController: _emailController,
                    focusNode: _emailNode,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                    child: Stack(
                      children: [
                        InputFieldWidgetWhiteTheme.number(
                          locale.mobileNumber ?? "",
                          padding: EdgeInsets.only(
                              top: 12, right: 0, left: 40, bottom: 12),
                          textEditingController: _numberController,
                          focusNode: _numberNode,
                        ),
                        InkWell(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                                builder: (context) => dialogCountryPicker);
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
                  InputFieldWidgetWhiteTheme.password(
                    "Confirm Password",
                    margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                    textEditingController: _passwordConfirmController,
                    focusNode: _passwordConfirmNode,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: mediaQuery.size.width,
                    child: CustomButton(
                      text: "${mPreference.value.userData.name.isEmpty?"Signup":"Register"}",
                      margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                      radius: BorderRadius.all(Radius.circular(34.0)),
                      onPressed: () async {
                        var countryId = _countrySelected != null
                            ? _countrySelected?.id.toString()
                            : "";
                        var stateId = dropdownValueState?.id ?? "";
                        var districtId = dropdownValueDistrict?.id ?? "";

                        viewModel.requestRegister(
                          _nameController,
                          _emailController,
                          _numberController,
                          _passwordController,
                          _passwordConfirmController,
                          countryId.toString(),
                          stateId,
                          districtId,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
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
          color: kGradientStart.withOpacity(.24),
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
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14,
                        color: kColor_1,
                      ),
                      children: [
                        TextSpan(
                            text: "Login",
                            style: TextStyle(
                              fontWeight: RFontWeight.BOLD,
                              fontSize: 18,
                              color: kColor_1,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              })
                      ]),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
