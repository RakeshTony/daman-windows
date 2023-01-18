import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CableTvBrowsePlanAddonsDataModel.dart';
import 'package:daman/DataBeans/CableTvBrowsePlanDataModel.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/GetParamsDataModel.dart';
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
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/pair.dart';
import 'package:daman/Ux/Dialog/dialog_bill_details.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_cable_tv.dart';

class CableTvPage extends StatelessWidget {
  final Operator operator;

  CableTvPage(this.operator);

  @override
  Widget build(BuildContext context) {
    return CableTvPageBody(operator);
  }
}

class CableTvPageBody extends StatefulWidget {
  final Operator operator;

  CableTvPageBody(this.operator);

  @override
  State<StatefulWidget> createState() => _CableTvPageBodyState();
}

class _CableTvPageBodyState
    extends BasePageState<CableTvPageBody, ViewModelCableTv> {
  BrowsePlanData? mPlan;
  String customerName = "";
  List<BrowsePlanData> browsePlans = [];
  List<BrowsePlanAddonData> addonsPlans = [];
  List<BrowsePlanAddonData> mSelectedPlansAddons = [];
  var form = List<Widget>.empty(growable: true);

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
    return mPlan != null;
  }

  double getTotalAmount() {
    double mTotal = mPlan?.price ?? 0.0;
    mSelectedPlansAddons.forEach((plan) {
      mTotal += plan.price;
    });
    return mTotal;
  }

  _setSelectPlan() {
    var mField = getFieldAmount();
    mField?.setText(mPlan != null ? getTotalAmount().toString() : "");
    mField?.setReadOnly(_isReadOnlyUserInput());
    setState(() {});
  }

  _onTapBrowsePlan(String txt) async {
    viewModel.requestOperatorPlans(viewModel.operator?.id ?? "", txt);
  }

  _onTapFetchBill(String txt) async {
    viewModel.requestOperatorValidate(viewModel.operator?.id ?? "", txt);
  }

  _onTapBrowseAddOnPlan(BrowsePlanData plan) async {
    viewModel.requestOperatorPlanAddons(
        viewModel.operator?.id ?? "", plan.code);
  }

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);

    viewModel.formStream.listen((fields) {
      form.clear();
      fields.forEach((element) {
        switch (element.valueType) {
          case "consumer_number":
            {
              form.add(WidgetNumber(
                element,
                onTapBrowsePlan: _onTapBrowsePlan,
                onTapFetchBill: _onTapFetchBill,
              ));
              break;
            }
          case "is_amount":
            {
              form.add(WidgetAmount(element));
              break;
            }
          default:
            {
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

    viewModel.browsePlanStream.listen((event) {
      customerName = event.customerName;
      browsePlans = event.plans;
      setState(() {});
    });
    viewModel.browsePlanAddonStream.listen((event) {
      addonsPlans = event;
      mSelectedPlansAddons = [];
      setState(() {});
    });
    viewModel.fetchBillStream.listen((event) {
      if (mounted) {
        var dialog = DialogBillDetails(event);
        showDialog(context: context, builder: (context) => dialog);
      }
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
          args["subscriber_title"] = "Subscriber Number";
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
      // appBar: AppBar(),
      backgroundColor: kScreenBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: theme.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppImage(
                    widget.operator.logo,
                    30,
                  ),
                  Text(
                    widget.operator.name,
                    style: TextStyle(
                        color: kMainTextColor,
                        fontSize: 15,
                        fontFamily: RFontFamily.SOFIA_PRO,
                        fontWeight: RFontWeight.REGULAR),
                  ),
                ],
              ),
            ),
            _widgetFormView(),
            Visibility(
              visible: customerName.isNotEmpty,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Hi $customerName, Your available plans are below",
                  style: TextStyle(
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: browsePlans.length,
              itemBuilder: (BuildContext context, index) =>
                  _widgetPlan(browsePlans[index]),
            ),
          ],
        ),
      ),
    );
  }

  _doProcess(String number, double amount, List<Pair<String, dynamic>> params,
      {BrowsePlanData? plan, List<BrowsePlanAddonData> addons = const []}) {
    HashMap<String, dynamic>? planParams;
    if (plan != null) {
      planParams = HashMap();
      planParams["customerName"] = customerName;
      planParams["code"] = plan.code;
      planParams["period"] = plan.period;
      planParams["month"] = plan.month;
      planParams["name"] = plan.name;
      planParams["price"] = plan.price;
      planParams["addondetails"] = addons.map((e) => e.toHashMap()).toList();
    }
    viewModel.requestBulkTopUp(
      mServiceId: widget.operator.serviceId,
      operatorId: widget.operator.id,
      denominationId: "",
      amount: amount,
      amountOriginal: amount,
      amountReceiver: amount,
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

  _widgetPlan(BrowsePlanData plan) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: kTextColor4,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
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
                        "${viewModel.currency?.sign} ${plan.price}",
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
                          "${plan.name}",
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
                new Center(
                  child: InkWell(
                    child: Icon(
                      ((mPlan?.code ?? "") == plan.code)
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: kMainColor,
                    ),
                    onTap: () {
                      if (mPlan == plan) {
                        mPlan = null;
                      } else {
                        mPlan = plan;
                        _onTapBrowseAddOnPlan(plan);
                      }
                      _setSelectPlan();
                    },
                  ),
                )
              ],
            ),
          ),
          mPlan == plan
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: addonsPlans.length,
                  itemBuilder: (BuildContext context, index) =>
                      _widgetPlanAddon(addonsPlans[index]),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }

  _widgetPlanAddon(BrowsePlanAddonData plan) {
    return ListTile(
      selected: mSelectedPlansAddons.contains(plan),
      selectedColor: kTextColor3,
      onTap: () {
        if (mSelectedPlansAddons.contains(plan)) {
          mSelectedPlansAddons.remove(plan);
        } else {
          mSelectedPlansAddons.add(plan);
        }
        _setSelectPlan();
      },
      horizontalTitleGap: 8,
      minVerticalPadding: 0,
      minLeadingWidth: 24,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Icon(
          mSelectedPlansAddons.contains(plan)
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          color: kMainColor,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        "${plan.name}",
        style: TextStyle(
            fontSize: 12,
            fontWeight: RFontWeight.MEDIUM,
            color: kMainTextColor),
      ),
      subtitle: Text(
        "Month : ${plan.month}  |  Period : ${plan.period}",
        style: TextStyle(
            fontSize: 10,
            fontWeight: RFontWeight.REGULAR,
            color: kMainTextColor),
      ),
      trailing: Text(
        "${viewModel.currency?.code}\n${plan.price}",
        style: TextStyle(
            fontSize: 10, fontWeight: RFontWeight.BOLD, color: kMainTextColor),
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
          var isBrowsePlan = false;
          var error = "";
          var number = "";
          double amount = 0.0;
          var params = List<Pair<String, dynamic>>.empty(growable: true);
          for (var index = 0; index < form.length; index++) {
            Widget field = form[index];
            if (field is WidgetNumber) {
              isBrowsePlan = field.fieldModel.isBrowserPlan;
              number = field.getKeyValue().second;
              error = field.getErrorMessage();
            } else if (field is WidgetAmount) {
              amount = toDouble(field.getKeyValue().second);
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
            if (isBrowsePlan) {
              AppAction.showGeneralErrorMessage(context, "Please Choose Plan");
            } else {
              if (amount == 0.0) {
                AppAction.showGeneralErrorMessage(context, "Enter amount");
              } else {
                _doProcess(number, amount, params);
              }
            }
          } else {
            // HERE API PLAN SELECTED
            _doProcess(number, amount, params,
                plan: mPlan, addons: mSelectedPlansAddons);
          }
        },
      ),
    );
  }
}

typedef GestureTapCallbackString = void Function(String txt);

class WidgetNumber extends StatelessWidget {
  FormFieldModel fieldModel;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  GestureTapCallbackString? onTapBrowsePlan;
  GestureTapCallbackString? onTapFetchBill;

  WidgetNumber(
    this.fieldModel, {
    this.onTapBrowsePlan,
    this.onTapFetchBill,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 6),
      child: Stack(
        children: [
          InputFieldWidget.number(
            fieldModel.name,
            padding: EdgeInsets.only(
                top: 12,
                right: fieldModel.isBrowserPlan ? 90 : 0,
                left: 0,
                bottom: 12),
            textEditingController: textEditingController,
            focusNode: focusNode,
            maxLength: fieldModel.maxLength,
            inputType: fieldModel.isNumeric
                ? RInputType.TYPE_NUMBER
                : RInputType.TYPE_TEXT,
          ),
          Visibility(
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
          ),
          Visibility(
            visible: fieldModel.isRequiredForBillFetch,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "Fetch Bill",
                  style: TextStyle(
                    fontFamily: RFontFamily.SOFIA_PRO,
                    fontWeight: RFontWeight.SEMI_BOLD,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  if (onTapFetchBill != null) {
                    var number = textEditingController.text.toString();
                    if (number.length
                        .isRange(fieldModel.minLength, fieldModel.maxLength)) {
                      onTapFetchBill!(number);
                    } else {
                      AppAction.showGeneralErrorMessage(
                          context, "Please Enter valid ${fieldModel.name}");
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
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

  WidgetAmount(this.fieldModel);

  String getErrorMessage() {
    var value = textEditingController.text.toString();
    if (value.isNotEmpty || fieldModel.isRequired) {
      var amount = toDouble(value);
      if (!amount.isRange(
          fieldModel.minLength.toDouble(), fieldModel.maxLength.toDouble())) {
        return "Enter ${fieldModel.name} (range : ${fieldModel.minLength} to ${fieldModel.maxLength})";
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
