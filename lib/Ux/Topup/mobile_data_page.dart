import 'dart:collection';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/GetParamsDataModel.dart';
import 'package:daman/DataBeans/OperatorValidateDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Utils/pair.dart';
import 'package:daman/Ux/Dialog/dialog_country_picker.dart';
import 'package:daman/Ux/Dialog/dialog_operator_picker.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_mobile_data.dart';
import 'package:daman/main.dart';

class MobileDataPage extends StatelessWidget {
  final Operator operator;

  MobileDataPage(this.operator);

  @override
  Widget build(BuildContext context) {
    return MobileDataBody(operator);
  }
}

class MobileDataBody extends StatefulWidget {
  final Operator operator;

  MobileDataBody(this.operator);

  @override
  State<StatefulWidget> createState() => _MobileDataBodyState();
}

class _MobileDataBodyState
    extends BasePageState<MobileDataBody, ViewModelMobileData> {
  var mServices = HiveBoxes.getServices();
  var mOperators = HiveBoxes.getOperators();

  List<CountryData> countries = [];
  CountryData? _countrySelected;

  UserPlanModel? mPlan;

  var form = List<Widget>.empty(growable: true);
  var tabs = List<Widget>.empty(growable: true);
  var pages = List<Widget>.empty(growable: true);

  WidgetAmount? getFieldAmount() {
    for (var index = 0; index < form.length; index++) {
      if (form[index] is WidgetAmount) {
        return form[index] as WidgetAmount;
      }
    }
    return null;
  }

  WidgetNumber? getFieldNumber() {
    for (var index = 0; index < form.length; index++) {
      if (form[index] is WidgetNumber) {
        return form[index] as WidgetNumber;
      }
    }
    return null;
  }

  bool _isReadOnlyUserInput() {
    bool isRange = viewModel.operator?.isRange ?? false;
    if (isRange) {
      // IF PLAN SELECTED TRUE
      // IF PLAN NOT SELECTED FALSE
      return mPlan != null;
    } else {
      return true; // HARE API PLAN COMING
    }
  }

  _onTapBrowsePlan(String txt) async {
    viewModel.requestOperatorPlans(viewModel.operator?.id ?? "", txt);
  }

  _onTapFetchBill(String txt) async {
    var numberField = getFieldNumber();
    if (numberField != null) {
      numberField.notifierBill.value = null;
      var number = numberField.textEditingController.text.toString();
      if (number.length.isRange(
          numberField.fieldModel.minLength, numberField.fieldModel.maxLength)) {
        viewModel.requestOperatorValidate(viewModel.operator?.id ?? "", txt);
      } else {
        AppAction.showGeneralErrorMessage(
            context, "Please Enter valid ${numberField.fieldModel.name}");
      }
    }
  }

  _onTapCountryPicker() {
    var dialogCountryPicker = DialogCountryPicker(
      data: countries,
      onTap: (country) {
        _countrySelected = country;
        setState(() {});
      },
    );
    showDialog(context: context, builder: (context) => dialogCountryPicker);
  }

  _onTapContactPicker() async {
    try {
      if (await FlutterContactPicker.hasPermission()) {
        final PhoneContact contact =
            await FlutterContactPicker.pickPhoneContact();
        AppLog.e("CONTACT", contact);
        getFieldNumber()?.setText(contact.phoneNumber?.number ?? "");
      } else {
        final granted = await FlutterContactPicker.requestPermission();
      }
    } catch (e) {}
  }

  String _getServiceName(String serviceId) {
    return mServices.values
            .firstWhereOrNull((element) => element.id == serviceId)
            ?.title ??
        "";
  }

  String _getServiceType(String serviceId) {
    return mServices.values
            .firstWhereOrNull((element) => element.id == serviceId)
            ?.type ??
        "";
  }

  _getServiceId(String operatorId) {
    return mOperators.values
            .firstWhereOrNull((element) => element.id == operatorId)
            ?.serviceId ??
        "";
  }

  _getOperatorIcon(String operatorId) {
    return mOperators.values
            .firstWhereOrNull((element) => element.id == operatorId)
            ?.logo ??
        "";
  }

  List<Widget> _doGenerateServiceTabs() {
    var serviceTabs = List<Widget>.empty(growable: true);
    if (viewModel.operator != null) {
      var operatorId = viewModel.operator?.id ?? "";
      var serviceId = viewModel.operator?.serviceId ?? "";
      List<String> relatedOperatorIds =
          viewModel.operator?.relatedOperatorIds ?? [];
      if (relatedOperatorIds.isNotEmpty) {
        var serviceName = _getServiceName(serviceId);
        var operatorTab =
            _createServiceTabItem([operatorId], serviceId, serviceName);
        var serviceRelatedId = _getServiceId(relatedOperatorIds.first);
        var serviceRelatedName = _getServiceName(serviceRelatedId);
        var operatorRelatedTab = _createServiceTabItem(
            relatedOperatorIds, serviceRelatedId, serviceRelatedName);

        if (serviceId == widget.operator.serviceId) {
          serviceTabs.add(operatorTab);
          serviceTabs.add(operatorRelatedTab);
        } else {
          serviceTabs.add(operatorRelatedTab);
          serviceTabs.add(operatorTab);
        }
      }
    } else {}
    return serviceTabs;
  }

  Widget _createServiceTabItem(
      List<String> operatorIds, String serviceId, String serviceName) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (operatorIds.length > 1) {
            var dialog = DialogOperatorPicker(operatorIds);
            var result = await showDialog(
                context: context, builder: (context) => dialog);
            if (result != null && result.toString().isNotEmpty) {
              viewModel.requestParams(result);
            }
          } else {
            viewModel.requestParams(operatorIds.first);
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: 8),
          height: 36,
          decoration: BoxDecoration(
              color: viewModel.mServiceSelected == serviceId
                  ? kMainColor
                  : kWhiteColor,
              border: Border.all(color: kMainColor, width: .5)),
          child: Center(
            child: Text(
              serviceName,
              style: TextStyle(
                  color: viewModel.mServiceSelected == serviceId
                      ? kWhiteColor
                      : kMainColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.MEDIUM,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    countries =
        HiveBoxes.getCountries().values.map((e) => e.toCountryData).toList();
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

    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.fetchBillStream.listen((event) {
      getFieldNumber()?.notifierBill.value = event;
    });

    viewModel.formStream.listen((fields) {
      form.clear();
      print(fields.first);
      fields.second.forEach((element) {
        switch (element.valueType) {
          case "consumer_number":
            {
              form.add(WidgetNumber(
                element,
                country: _countrySelected,
                onTapCountry: _onTapCountryPicker,
                onTapContact: _onTapContactPicker,
                onTapBrowsePlan: _onTapBrowsePlan,
                onTapFetchBill: _onTapFetchBill,
              ));
              break;
            }
          case "is_amount":
            {
              var isDataService =
                  _getServiceType(viewModel.mServiceSelected).toUpperCase() ==
                          "INTERNET" &&
                      fields.first;
              form.add(WidgetAmount(element, isDataService));
              break;
            }
          default:
            {
              // form.add(_widgetAmount());
              form.add(WidgetOther(element));
              break;
            }
        }
      });
      if (form.isNotEmpty) {
        form.add(_widgetProcess());
      }
      setState(() {});
    });
    viewModel.userPlansTabsStream.listen((event) {
      tabs = List<Widget>.empty(growable: true);
      pages = List<Widget>.empty(growable: true);
      event.forEach((item) {
        if (item.second.isNotEmpty) {
          tabs.add(Tab(
            text: item.first,
          ));
          pages.add(_widgetPage(item.second));
        }
      });
      if (this.mounted) setState(() {});
    });
    viewModel.responseStream.listen((event) {
      if (mounted) {
        var message = event.second.getMessage;
        var data = event.second.getDenomination();
        if (data.isNotEmpty) {
          var args = HashMap<String, dynamic>();
          args["receiptNo"] = event.first;
          args["operator"] = viewModel.operator;
          args["currency"] = viewModel.currency;
          args["status"] = data.first;
          args["subscriber_title"] = "Mobile Number";
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageRoutes.rechargeStatus,
            ModalRoute.withName(PageRoutes.bottomNavigation),
            arguments: args,
          );
        } else {
          var dialog = DialogSuccess(
              title: "Recharge Failed",
              message: message,
              actionText: "Go Back",
              isCancelable: false,
              isErrorIcon: true,
              onActionTap: () {
                Navigator.pop(context);
              });
          showDialog(context: context, builder: (context) => dialog);
        }
      }
    });
    viewModel.requestParams(widget.operator.id);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kScreenBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: theme.backgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppImage(
                          _getOperatorIcon(viewModel.operator?.id ?? ""),
                          30,
                        ),
                        Text(
                          viewModel.operator?.title ?? "",
                          style: TextStyle(
                              color: kMainTextColor,
                              fontSize: 15,
                              fontFamily: RFontFamily.SOFIA_PRO,
                              fontWeight: RFontWeight.REGULAR),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: _doGenerateServiceTabs(),
                  ),
                ],
              ),
            ),
            _widgetFormView(),
            Expanded(
              child: _widgetPlanShow(),
            )
          ],
        ),
      ),
    );
  }

  _doProcess(UserPlanModel plan, String number, String amount,
      List<Pair<String, dynamic>> params) {
    HashMap<String, dynamic>? planParams;
    if (_getServiceType(viewModel.mServiceSelected).toUpperCase() ==
        "INTERNET") {
      planParams = HashMap<String, dynamic>();
      planParams["id"] = plan.planId;
      planParams["denomination"] = plan.planAmount;
      planParams["org_denomination"] = plan.planAmountOriginal;
      planParams["currency_amount"] = plan.planAmountReceiver;
      planParams["instructions"] = plan.planDescription;
    }
    viewModel.requestBulkTopUp(
      mServiceId: widget.operator.serviceId,
      operatorId: widget.operator.id,
      denominationId: plan.planId,
      amount: plan.planAmount,
      amountOriginal: plan.planAmountOriginal,
      amountReceiver: plan.planAmountReceiver,
      mobile: number,
      formFields: params,
      planParams: planParams,
    );
  }

  _widgetFormView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: form,
    );
  }

  _widgetPlanShow() {
    return tabs.length == 0
        ? Container(
            height: 0,
            width: 0,
          )
        : DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: kMainColor, //.withOpacity(0.73)
                  child: TabBar(
                    tabs: tabs,
                    isScrollable: true,
                    indicatorColor: kMainButtonColor,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: pages,
                  ),
                )
              ],
            ),
          );
  }

  _widgetPlan(UserPlanModel plan) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            ((mPlan?.planId ?? "") == plan.planId) ? kWhiteColor : kWhiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${viewModel.currency?.sign} ${plan.planAmount}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: RFontWeight.BOLD,
                      fontFamily: RFontFamily.POPPINS,
                      color: kMainTextColor),
                ),
                SizedBox(
                  height: 12,
                ),
                Flexible(
                  child: Text(
                    "${plan.planDescription}",
                    style: TextStyle(
                      fontWeight: RFontWeight.REGULAR,
                      fontFamily: RFontFamily.POPPINS,
                      fontSize: 12,
                      color: kMainTextColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 36,
            margin: EdgeInsets.only(left: 16),
            child: CustomButton(
              text: "Select",
              radius: BorderRadius.all(Radius.circular(34.0)),
              padding: 0,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.LIGHT,
                  color: kWhiteColor),
              onPressed: () {
                var mField = getFieldAmount();
                if (mPlan == plan) {
                  mPlan = null;
                  mField?.setText("");
                  mField?.setReadOnly(_isReadOnlyUserInput());
                } else {
                  mPlan = plan;
                  mField?.setText(plan.planAmount.toString());
                  mField?.setReadOnly(_isReadOnlyUserInput());
                }
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  _widgetProcess() {
    return Container(
      width: 200,
      height: 36,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: CustomButton(
        text: "Continue",
        radius: BorderRadius.all(Radius.circular(34.0)),
        padding: 0,
        onPressed: () {
          var isRange = viewModel.operator?.isRange ?? false;
          var error = "";
          var number = "";
          var amount = "";
          var params = List<Pair<String, dynamic>>.empty(growable: true);
          for (var index = 0; index < form.length; index++) {
            Widget field = form[index];
            if (field is WidgetNumber) {
              number = field.getKeyValue().second;
              error = field.getErrorMessage();
            } else if (field is WidgetAmount) {
              amount = field.getKeyValue().second;
              error = field.getErrorMessage();
            } else if (field is WidgetOther) {
              params.add(field.getKeyValue());
              error = field.getErrorMessage();
            }
            if (error.isNotEmpty) {
              break;
            }
          }
          AppLog.e("NUMBER", number);
          AppLog.e("AMOUNT", amount);
          AppLog.e("OTHERS", params);
          if (viewModel.operator == null) {
            AppAction.showGeneralErrorMessage(context, "Operator Not Found");
          } else if (viewModel.currency == null) {
            AppAction.showGeneralErrorMessage(context, "Currency Not Found");
          } else if (error.isNotEmpty) {
            AppAction.showGeneralErrorMessage(context, error);
          } else if (mPlan == null) {
/*
            if (_getServiceType(mServiceSelected).toUpperCase() == "INTERNET") {
              AppAction.showGeneralErrorMessage(context, "Please Choose Plan");
            } else {
*/
            if (isRange) {
              if (amount.isEmpty) {
                AppAction.showGeneralErrorMessage(
                    context, "Enter amount / Choose Plan");
              } else {
                var mPlanId = viewModel.operator?.denominationId ?? "";
                var mPlanAmountOriginal = 0.0;
                var mPlanAmountReceiver = 0.0;
                var data = getFieldAmount()?.calculationMarkup();
                if (data is Pair) {
                  mPlanAmountOriginal = data?.first ?? 0.0;
                  mPlanAmountReceiver = data?.second ?? 0.0;
                }
                // HERE USER INPUT MANUALLY
                UserPlanModel plan = UserPlanModel(
                  planId: mPlanId,
                  planAmount: toDouble(amount),
                  planAmountOriginal: mPlanAmountOriginal,
                  planAmountReceiver: mPlanAmountReceiver,
                  planDescription: "",
                );
                _doProcess(plan, number, amount, params);
              }
            } else {
              AppAction.showGeneralErrorMessage(context, "Please Choose Plan");
            }
            // }
          } else {
            // HERE API PLAN SELECTED
            _doProcess(mPlan!, number, amount, params);
          }
        },
      ),
    );
  }

  _widgetPage(List<UserPlanModel> plans) {
    return Container(
      child: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (BuildContext context, index) => _widgetPlan(plans[index]),
      ),
    );
  }
}

typedef GestureTapCallbackString = void Function(String txt);

class WidgetNumber extends StatelessWidget {
  FormFieldModel fieldModel;
  CountryData? country;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  GestureTapCallback? onTapCountry;
  GestureTapCallback? onTapContact;
  GestureTapCallbackString? onTapBrowsePlan;
  GestureTapCallbackString? onTapFetchBill;
  ValueNotifier<OperatorValidateData?> notifierBill =
      ValueNotifier<OperatorValidateData?>(null);

  WidgetNumber(
    this.fieldModel, {
    this.country,
    this.onTapCountry,
    this.onTapContact,
    this.onTapBrowsePlan,
    this.onTapFetchBill,
  });

  String getErrorMessage() {
    var value = textEditingController.text.toString();
    if (value.isNotEmpty || fieldModel.isRequired) {
      if (!value.length.isRange(fieldModel.minLength, fieldModel.maxLength)) {
        return "Enter ${fieldModel.name} (length : ${fieldModel.minLength} to ${fieldModel.maxLength})";
      }
      if (fieldModel.isRequiredForBillFetch && notifierBill.value == null)
        return "Please Validate ${fieldModel.name}";
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() =>
      Pair(fieldModel.keyName, textEditingController.text.toString());

  void setText(String text) {
    textEditingController.text = text;
  }

  TextStyle title() {
    return TextStyle(
        color: kMainTextColor,
        fontSize: 12,
        fontWeight: RFontWeight.REGULAR,
        fontFamily: RFontFamily.POPPINS);
  }

  TextStyle description() {
    return TextStyle(
        color: kMainTextColor,
        fontSize: 12,
        fontWeight: RFontWeight.REGULAR,
        fontFamily: RFontFamily.POPPINS);
  }

  @override
  Widget build(BuildContext context) {
    if (fieldModel.isPrefilledUserNumber) {
      setText(mPreference.value.userData.mobile);
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 6),
          child: Stack(
            children: [
              InputFieldWidget.number(
                fieldModel.name,
                padding: EdgeInsets.only(
                    top: 12,
                    right: fieldModel.isRequiredForBillFetch ? 90 : 0,
                    left: fieldModel.isCountrySelection ? 40 : 0,
                    bottom: 12),
                textEditingController: textEditingController,
                focusNode: focusNode,
                maxLength: fieldModel.maxLength,
                inputType: fieldModel.isNumeric
                    ? RInputType.TYPE_NUMBER
                    : RInputType.TYPE_TEXT,
                readOnly: fieldModel.isPrefilledUserNumber,
              ),
              Visibility(
                visible: fieldModel.isCountrySelection,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: Text(
                      "+${country?.phoneCode}",
                      style: AppStyleText.inputFiledPrimaryText,
                    ),
                  ),
                  onTap: onTapCountry,
                ),
              ),
              Visibility(
                visible: fieldModel.isContact,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      child: Image.asset(
                        IC_PHONE_BOOK,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    onTap: onTapContact,
                  ),
                ),
              ),
              Visibility(
                visible: fieldModel.isRequiredForBillFetch,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (onTapFetchBill != null) {
                        var number = textEditingController.text.toString();
                        onTapFetchBill!(number);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 0, top: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.security_sharp,
                            color: kWhiteColor,
                            size: 18,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Validate",
                            style: TextStyle(
                              fontSize: 12,
                              color: kWhiteColor,
                              fontWeight: RFontWeight.MEDIUM,
                              fontFamily: RFontFamily.POPPINS,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ), /* Visibility(
                visible: fieldModel.isBrowserPlan,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      "Browse Plan",
                      style: TextStyle(
                        fontFamily: RFontFamily.SOFIA_PRO,
                        fontWeight: RFontWeight.SEMI_BOLD,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      if (onTapBrowsePlan != null) {
                        var number = textEditingController.text.toString();
                        if (number.length
                            .isRange(fieldModel.minLength, fieldModel.maxLength)) {
                          onTapBrowsePlan!(number);
                        } else {
                          AppAction.showGeneralErrorMessage(
                              context, "Please Enter valid ${fieldModel.name}");
                        }
                      }
                    },
                  ),
                ),
              ),*/
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: notifierBill,
          builder: (context, OperatorValidateData? billDetails, _) {
            return Visibility(
              visible: billDetails != null,
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: (billDetails?.customerName ?? "").isNotEmpty,
                      child: Row(
                        children: [
                          Text(
                            "Account Owner:",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              billDetails?.customerName ?? "",
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (billDetails?.type ?? "").isNotEmpty,
                      child: Row(
                        children: [
                          Text(
                            "Account Type:",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              (billDetails?.type ?? "").toUpperCase(),
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      // visible: (billDetails?.customerAddress ?? "").isNotEmpty,
                      visible: false,
                      child: Row(
                        children: [
                          Text(
                            "Address       :",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              billDetails?.customerAddress ?? "",
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      // visible: (billDetails?.customerDistrict ?? "").isNotEmpty,
                      visible: false,
                      child: Row(
                        children: [
                          Text(
                            "District         :",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              billDetails?.customerDistrict ?? "",
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      // visible: (billDetails?.phoneNumber ?? "").isNotEmpty,
                      visible: false,
                      child: Row(
                        children: [
                          Text(
                            "Phone          :",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              billDetails?.phoneNumber ?? "",
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: false,
                      // visible: (billDetails?.disco ?? "").isNotEmpty,
                      child: Row(
                        children: [
                          Text(
                            "Discom         :",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              billDetails?.disco ?? "",
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Row(
                        children: [
                          Text(
                            "Min Payable :",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              (billDetails?.minimumPayable ?? 0.0)
                                  .toSeparatorFormat(),
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Row(
                        children: [
                          Text(
                            "Due Amount :",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              (billDetails?.outstandingAmount ?? 0.0)
                                  .toSeparatorFormat(),
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Row(
                        children: [
                          Text(
                            "Balance on Account:",
                            style: title(),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Text(
                              "${(billDetails?.outstandingAmount ?? 0.0).toSeparatorFormat()} / ${(billDetails?.minimumPayable ?? 0.0).toSeparatorFormat()}",
                              style: description(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class WidgetAmount extends StatefulWidget {
  ParamOperatorModel? operator;
  CurrencyData? currency;
  FormFieldModel fieldModel;
  String markupCalculationMessage = "";
  bool isReadOnly = false;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  WidgetAmount(this.fieldModel, this.isReadOnly);

  String getErrorMessage() {
    var value = textEditingController.text.toString();
    if (value.isNotEmpty || fieldModel.isRequired) {
      if (!value.length.isRange(fieldModel.minLength, fieldModel.maxLength)) {
        return "Enter ${fieldModel.name} (length : ${fieldModel.minLength} to ${fieldModel.maxLength})";
      }
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() =>
      Pair(fieldModel.keyName, textEditingController.text.toString());

  void setText(String text) {
    textEditingController.text = text;
  }

  void setReadOnly(bool status) {
    isReadOnly = status;
  }

  Pair<double, double> calculationMarkup() {
    markupCalculationMessage = "";
    if (operator?.isMarkup == true) {
      var input = textEditingController.text.toString();
      if (input.isNotEmpty) {
        var amount = toDouble(input);
        // MARKUP CALCULATION
        var markup = operator?.markupValue ?? 0.0;
        var commission = amount - (amount * markup) / 100;

        // CURRENCY CONVERSION
        var sellingRate = currency?.sellingRate ?? 0.0;
        var currencyAmount = commission / sellingRate;

        if (currencyAmount > 0) {
          markupCalculationMessage = "${currency?.sign} $currencyAmount";
        } else {
          markupCalculationMessage = "";
        }

        var apiId = operator?.operatorApiId ?? "";

        var mAmountOriginal = 0.0;
        var mAmountCurrency = 0.0;
        if (apiId == "18") {
          mAmountOriginal = commission;
          mAmountCurrency = currencyAmount;
        } else {
          mAmountOriginal = currencyAmount;
          mAmountCurrency = currencyAmount;
        }
        AppLog.e("MARKUP CALCULATE",
            " Original : $mAmountOriginal  , Currency : $mAmountCurrency");
        return Pair(mAmountOriginal, mAmountCurrency);
      } else {
        return Pair(0.0, 0.0);
      }
    } else {
      return Pair(0.0, 0.0);
    }
  }

  @override
  State<WidgetAmount> createState() => _WidgetAmountState();
}

class _WidgetAmountState extends State<WidgetAmount> {
  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      if (widget.operator?.isMarkup == true) {
        widget.calculationMarkup();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 10),
          child: InputFieldWidget.number(
            widget.fieldModel.name,
            padding: EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 12),
            textEditingController: widget.textEditingController,
            // focusNode: widget.focusNode,
            readOnly: widget.isReadOnly,
            maxLength: widget.fieldModel.maxLength,
            inputType: widget.fieldModel.isNumeric
                ? RInputType.TYPE_NUMBER
                : RInputType.TYPE_TEXT,
          ),
        ),
        Visibility(
          visible: widget.markupCalculationMessage.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
            child: Text(
              widget.markupCalculationMessage,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 10,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ),
      ],
    );
  }
}

class WidgetOther extends StatelessWidget {
  FormFieldModel fieldModel;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  WidgetOther(this.fieldModel);

  String getErrorMessage() {
    var value = textEditingController.text.toString();
    if (value.isNotEmpty || fieldModel.isRequired) {
      if (!value.length.isRange(fieldModel.minLength, fieldModel.maxLength)) {
        return "Enter ${fieldModel.name} (length : ${fieldModel.minLength} to ${fieldModel.maxLength})";
      }
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() =>
      Pair(fieldModel.keyName, textEditingController.text.toString());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Stack(
        children: [
          fieldModel.isNumeric
              ? InputFieldWidget.number(
                  fieldModel.name,
                  padding:
                      EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 12),
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  maxLength: fieldModel.maxLength,
                )
              : InputFieldWidget.text(
                  fieldModel.name,
                  padding:
                      EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 12),
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  maxLength: fieldModel.maxLength,
                )
        ],
      ),
    );
  }
}
