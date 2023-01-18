import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/DistrictDataModel.dart';
import 'package:daman/DataBeans/StateDataModel.dart';
import 'package:daman/DataBeans/UserRanksDataModel.dart';
import 'package:daman/DataBeans/UserRanksPlansDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Ux/Dialog/dialog_country_picker.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/DownLine/ViewModel/view_model_down_line.dart';

import '../../Utils/app_decorations.dart';

class DownLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DownLineBody();
  }
}

class DownLineBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DownLineBodyState();
}

class _DownLineBodyState
    extends BasePageState<DownLineBody, ViewModelDownLine> {
  RanksData rankData = RanksData(name: "Select Rank");
  PlansData plansData = PlansData(name: "Select Plan");
  StateData stateData = StateData(title: "Select State");
  DistrictData districtData = DistrictData(title: "Select Local Govt");

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _numberNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _passwordConfirmNode = FocusNode();

  List<CountryData> countries = [];
  CountryData? _countrySelected;

  RanksData? dropdownValueRanks;
  List<RanksData> spinnerItemsRanks = [];

  PlansData? dropdownValuePlans;
  List<PlansData> spinnerItemsPlans = [];

  StateData? dropdownValueState;
  List<StateData> spinnerItemsState = [];

  DistrictData? dropdownValueDistrict;
  List<DistrictData> spinnerItemsDistrict = [];

  @override
  void initState() {
    super.initState();
   /* RanksData rankData = RanksData(name: AppLocalizations.of(context)!.selectRank!);
    PlansData plansData = PlansData(name: AppLocalizations.of(context)!.selectPlan!);
    StateData stateData = StateData(title: AppLocalizations.of(context)!.selectState!);
    DistrictData districtData = DistrictData(title: AppLocalizations.of(context)!.selectLocalGovt!);*/
    if (spinnerItemsRanks.isEmpty) spinnerItemsRanks.add(rankData);
    if (spinnerItemsPlans.isEmpty) spinnerItemsPlans.add(plansData);
    if (spinnerItemsState.isEmpty) spinnerItemsState.add(stateData);
    if (spinnerItemsDistrict.isEmpty) spinnerItemsDistrict.add(districtData);
    viewModel.requestCountries();
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
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              Navigator.pop(context,"RELOAD");
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);

    /*Downline Ranks*/
    viewModel.requestRanksList();
    viewModel.requestStateList(AppSettings.COUNTRY_ID);
    viewModel.rankStream.listen((map) {
      if (spinnerItemsRanks.isNotEmpty) spinnerItemsRanks.clear();
      spinnerItemsRanks.add(rankData);
      spinnerItemsRanks.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);

    viewModel.plansStream.listen((map) {
      if (spinnerItemsPlans.isNotEmpty) spinnerItemsPlans.clear();
      spinnerItemsPlans.add(plansData);
      spinnerItemsPlans.addAll(map);
      if (mounted) {
        setState(() {});
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
    if (dropdownValueRanks == null) {
      dropdownValueRanks = rankData;
    }
    if (dropdownValuePlans == null) {
      dropdownValuePlans = plansData;
    }
    if (dropdownValueState == null) {
      dropdownValueState = stateData;
    }
    if (dropdownValueDistrict == null) {
      dropdownValueDistrict = districtData;
    }
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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: kWalletBackground,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.registerDownline!,
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
              Expanded(
                child: ListView(
                  children: [
                    /*Ranks Spinner*/
                    Visibility(
                      visible: true,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 33, right: 33, top: 16),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: kTextInputInactive),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<RanksData>(
                            value: dropdownValueRanks,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText,
                            onChanged: (data) {
                              setState(() {
                                dropdownValueRanks = data!;
                                spinnerItemsPlans.clear();
                                spinnerItemsPlans.add(plansData);
                                dropdownValuePlans = plansData;
                                var mRankId = dropdownValueRanks?.id ?? "";
                                if (mRankId.isNotEmpty) {
                                  viewModel.requestPlansList(
                                      dropdownValueRanks?.id ?? "");
                                }
                              });
                            },
                            items: spinnerItemsRanks
                                .map<DropdownMenuItem<RanksData>>(
                                    (RanksData value) {
                              return DropdownMenuItem<RanksData>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    /*Plans Spinner*/
                    Visibility(
                      visible: true,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 33, right: 33, top: 16),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: kTextInputInactive),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<PlansData>(
                            value: dropdownValuePlans,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText,
                            onChanged: (data) {
                              setState(() {
                                dropdownValuePlans = data!;
                              });
                            },
                            items: spinnerItemsPlans
                                .map<DropdownMenuItem<PlansData>>(
                                    (PlansData value) {
                              return DropdownMenuItem<PlansData>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
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
                                width: 1.0, color: kTextInputInactive),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<StateData>(
                            value: dropdownValueState,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText,
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
                                width: 1.0, color: kTextInputInactive),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DistrictData>(
                            value: dropdownValueDistrict,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText,
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
                                child: Text(value.title),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    InputFieldWidget.text(
                      AppLocalizations.of(context)!.name!,
                      margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                      textEditingController: _nameController,
                      focusNode: _nameNode,
                    ),
                    InputFieldWidget.email(
                      AppLocalizations.of(context)!.emailAddress!,
                      margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                      textEditingController: _emailController,
                      focusNode: _emailNode,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                      child: Stack(
                        children: [
                          InputFieldWidget.number(
                            locale.mobileNumber ?? "",
                            padding: EdgeInsets.only(
                              top: 12,
                              right: 0,
                              left: 40,
                              bottom: 12,
                            ),
                            textEditingController: _numberController,
                            focusNode: _numberNode,
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Text(
                                "+${_countrySelected?.phoneCode}",
                                style: AppStyleText.inputFiledPrimaryText,
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
                    InputFieldWidget.password(
                      locale.password ?? "",
                      margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                      textEditingController: _passwordController,
                      focusNode: _passwordNode,
                    ),
                    InputFieldWidget.password(
                      AppLocalizations.of(context)!.confirmPassword!,
                      margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                      textEditingController: _passwordConfirmController,
                      focusNode: _passwordConfirmNode,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: mediaQuery.size.width,
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.register!,
                        margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                        radius: BorderRadius.all(Radius.circular(34.0)),
                        onPressed: () async {
                          var countryId = _countrySelected?.id ?? "";
                          var stateId = dropdownValueState?.id ?? "";
                          var districtId = dropdownValueDistrict?.id ?? "";
                          var rankId = dropdownValueRanks?.id ?? "";
                          var planId = dropdownValuePlans?.id ?? "";

                          viewModel.requestRegister(
                            _nameController,
                            _emailController,
                            _numberController,
                            _passwordController,
                            _passwordConfirmController,
                            countryId.toString(),
                            stateId,
                            districtId,
                            rankId,
                            planId,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              )
            ],
          ),
    ),),),);
  }
}
