import 'package:collection/src/iterable_extensions.dart';
import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class GetParamsDataModel extends BaseDataModel {
  GetParamsModel? paramsModel;

  @override
  GetParamsDataModel parseData(Map<String, dynamic> result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    if (getStatus && result.containsKey(AppRequestKey.RESPONSE_DATA)) {
      var data = result[AppRequestKey.RESPONSE_DATA];
      this.paramsModel = GetParamsModel.fromJson(data);
    }
    return this;
  }
}

class GetParamsModel {
  bool isBrowserPlan;
  bool isCustomPlanShow;
  ParamOperatorModel operator;
  CurrencyData currency;
  List<FormFieldModel> params;
  List<ApiPlanTypeModel> apiPlans;
  List<CustomPlanTypeModel> customPlans;

  GetParamsModel({
    this.isBrowserPlan = false,
    this.isCustomPlanShow = false,
    required this.operator,
    required this.currency,
    this.params = const [],
    this.apiPlans = const [],
    this.customPlans = const [],
  });

  factory GetParamsModel.fromJson(Map<String, dynamic> json) {
    var plans = toList(json['api_plans'])
        .map((e) => ApiPlanTypeModel.fromJson(e))
        .toList();
    var denominationId = plans.firstOrNull?.plans?.firstOrNull?.id ?? "";
    return GetParamsModel(
      isBrowserPlan: toIntBoolean(json['is_browser_plan']),
      isCustomPlanShow: toIntBoolean(json['is_range']),
      operator:
          ParamOperatorModel.fromJson(toMap(json['operator']), denominationId),
      currency: CurrencyData.fromJson(toMap(json['curreny'])),
      params: toList(json['params'])
          .map((e) => FormFieldModel.fromJson(e))
          .toList(),
      apiPlans: plans,
      customPlans: toList(json['custom_plans'])
          .map((e) => CustomPlanTypeModel.fromJson(e, denominationId))
          .toList(),
    );
  }
}

class FormFieldModel {
  String name;
  String keyName;
  String type;
  bool isRequired;
  bool isNumeric;
  bool isContact;
  bool isBrowserPlan;
  bool isRequiredForBillFetch;
  bool isPrefilledUserNumber;
  bool isCountrySelection;
  String valueType;
  int minLength;
  int maxLength;
  String specialComment;
  String defaultValue;
  List options;

  FormFieldModel({
    this.name = "",
    this.keyName = "",
    this.type = "",
    this.isRequired = false,
    this.isNumeric = false,
    this.isContact = false,
    this.isBrowserPlan = false,
    this.isPrefilledUserNumber = false,
    this.isRequiredForBillFetch = false,
    this.isCountrySelection = false,
    this.valueType = "",
    this.minLength = 0,
    this.maxLength = 0,
    this.specialComment = "",
    this.defaultValue = "",
    this.options = const [],
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      name: toString(json['name']),
      keyName: toString(json['keyname']),
      type: toString(json['type']),
      isRequired: toIntBoolean(json['required']),
      isNumeric: toIntBoolean(json['is_numeric']),
      isContact: toIntBoolean(json['is_contact']),
      isBrowserPlan: toIntBoolean(json['is_browser_plan']),
      isPrefilledUserNumber: toIntBoolean(json['is_prefilled_usernumber']),
      isRequiredForBillFetch: toIntBoolean(json['is_required_for_billfetch']),
      isCountrySelection: toBoolean(json['is_country_selection']),
      valueType: toString(json['value_type']),
      minLength: toInt(json['min_len']),
      maxLength: toInt(json['max_len']),
      specialComment: toString(json['special_comment']),
      defaultValue: toString(json['default_value']),
      options: toList(json['options']),
    );
  }
}

class ParamOperatorModel {
  String id;
  String title;
  String currencyId;
  String countryId;
  String serviceId;
  String operatorMainType;
  String operatorType;
  String defaultDiscountType;
  String defaultCommissionType;
  String operatorApiId;
  bool isMarkup;
  double markupValue;
  bool isRange;
  String denominationId;
  List<String> relatedOperatorIds;

  ParamOperatorModel({
    this.id = "",
    this.title = "",
    this.currencyId = "",
    this.countryId = "",
    this.serviceId = "",
    this.operatorMainType = "",
    this.operatorType = "",
    this.defaultDiscountType = "",
    this.defaultCommissionType = "",
    this.operatorApiId = "",
    this.isMarkup = false,
    this.markupValue = 0,
    this.isRange = false,
    this.denominationId = "",
    this.relatedOperatorIds = const [],
  });

  factory ParamOperatorModel.fromJson(
      Map<String, dynamic> json, String denominationId) {
    return ParamOperatorModel(
      id: toString(json['id']),
      title: toString(json['title']),
      currencyId: toString(json['currency_id']),
      countryId: toString(json['country_id']),
      serviceId: toString(json['service_id']),
      operatorMainType: toString(json['operator_maintype']),
      operatorType: toString(json['operator_type']),
      defaultDiscountType: toString(json['default_discount_type']),
      defaultCommissionType: toString(json['default_commission_type']),
      operatorApiId: toString(json['operator_api_id']),
      isMarkup: toIntBoolean(json['is_markup']),
      markupValue: toDouble(json['markup_value']),
      isRange: toIntBoolean(json['is_range']),
      relatedOperatorIds: toSplit(json['related_operator_id']),
      denominationId: denominationId,
    );
  }
}

class ApiPlanModel {
  String id;
  String title;
  String icon;
  String instructions;
  double denomination;
  double orgDenomination;
  double currencyAmount;
  String apiId;
  String minMax;
  double markupAmount;

  ApiPlanModel({
    this.id = "",
    this.title = "",
    this.icon = "",
    this.instructions = "",
    this.denomination = 0.0,
    this.orgDenomination = 0.0,
    this.currencyAmount = 0.0,
    this.apiId = "",
    this.minMax = "",
    this.markupAmount = 0.0,
  });

  factory ApiPlanModel.fromJson(Map<String, dynamic> json) {
    return ApiPlanModel(
      id: toString(json['id']),
      title: toString(json['title']),
      icon: toString(json['icon']),
      instructions: toString(json['instructions']),
      denomination: toDouble(json['denomination']),
      orgDenomination: toDouble(json['org_denomination']),
      currencyAmount: toDouble(json['currency_amount']),
      apiId: toString(json['api_id']),
      minMax: toString(json['min_max']),
      markupAmount: toDouble(json['markup_amount']),
    );
  }
}

class ApiPlanTypeModel {
  String title;
  List<ApiPlanModel> plans;

  ApiPlanTypeModel({
    this.title = "",
    this.plans = const [],
  });

  factory ApiPlanTypeModel.fromJson(Map<String, dynamic> json) {
    return ApiPlanTypeModel(
      title: toString(json['title']),
      plans: toList(json['Plan']).map((e) => ApiPlanModel.fromJson(e)).toList(),
    );
  }
}

class CustomPlanTypeModel {
  String id;
  String title;
  String operatorId;
  String operatorCircleId;
  List<CustomPlanModel> plans;

  CustomPlanTypeModel({
    this.id = "",
    this.operatorId = "",
    this.title = "",
    this.operatorCircleId = "",
    this.plans = const [],
  });

  factory CustomPlanTypeModel.fromJson(
      Map<String, dynamic> json, String denominationId) {
    return CustomPlanTypeModel(
      id: toString(json['id']),
      title: toString(json['title']),
      operatorId: toString(json['operator_id']),
      operatorCircleId: toString(json['operatorcircle_id']),
      plans: toList(json['Plan'])
          .map((e) => CustomPlanModel.fromJson(e, denominationId))
          .toList(),
    );
  }
}

class CustomPlanModel {
  String id;
  String operatorId;
  String denominationId;
  String operatorCircleId;
  double plReceivedCommission;
  double plDeliverableCommission;
  double pbReceivedCommission;
  double pbDeliverableCommission;
  String plCommissionType;
  String pbCommissionType;
  double price;
  double buyingPrice;
  double currencyAmount;
  double denomination;
  double orgDenomination;
  String talkTime;
  String validity;
  String description;
  String planTypeId;
  bool isRecharge;
  bool isPin;

  CustomPlanModel({
    this.id = "",
    this.operatorId = "",
    this.denominationId = "",
    this.operatorCircleId = "",
    this.plReceivedCommission = 0.0,
    this.plDeliverableCommission = 0.0,
    this.pbReceivedCommission = 0.0,
    this.pbDeliverableCommission = 0.0,
    this.plCommissionType = "",
    this.pbCommissionType = "",
    this.price = 0.0,
    this.buyingPrice = 0.0,
    this.currencyAmount = 0.0,
    this.denomination = 0.0,
    this.orgDenomination = 0.0,
    this.talkTime = "",
    this.validity = "",
    this.description = "",
    this.planTypeId = "",
    this.isRecharge = false,
    this.isPin = false,
  });

  factory CustomPlanModel.fromJson(
      Map<String, dynamic> json, String denominationId) {
    return CustomPlanModel(
      id: toString(json['id']),
      denominationId: denominationId,
      operatorId: toString(json['operator_id']),
      operatorCircleId: toString(json['operatorcircle_id']),
      plReceivedCommission: toDouble(json['pl_recieved_commission']),
      plDeliverableCommission: toDouble(json['pl_deliverable_commission']),
      pbReceivedCommission: toDouble(json['pb_recieved_commission']),
      pbDeliverableCommission: toDouble(json['pb_deliverable_commission']),
      plCommissionType: toString(json['pl_commission_type']),
      pbCommissionType: toString(json['pb_commission_type']),
      price: toDouble(json['price']),
      buyingPrice: toDouble(json['buying_price']),
      currencyAmount: toDouble(json['currency_amount']),
      denomination: toDouble(json['denomination']),
      orgDenomination: toDouble(json['org_denomination']),
      talkTime: toString(json['talktime']),
      validity: toString(json['validity']),
      description: toString(json['description']),
      planTypeId: toString(json['plantype_id']),
      isRecharge: toBoolean(json['is_recharge']),
      isPin: toIntBoolean(json['is_pin']),
    );
  }
}

class UserPlanModel {
  String planId;
  String planDescription;
  double planAmount;
  double planAmountOriginal;
  double planAmountReceiver;

  UserPlanModel({
    this.planId = "",
    this.planDescription = "",
    this.planAmount = 0.0,
    this.planAmountOriginal = 0.0,
    this.planAmountReceiver = 0.0,
  });

  factory UserPlanModel.fromApiPlan(ApiPlanModel plan) {
    return UserPlanModel(
      planId: plan.id,
      planDescription: plan.instructions,
      planAmount: plan.denomination,
      planAmountOriginal: plan.orgDenomination,
      planAmountReceiver: plan.currencyAmount,
    );
  }

  factory UserPlanModel.fromCustomPlan(CustomPlanModel plan) {
    return UserPlanModel(
      planId: plan.denominationId,
      planDescription: plan.description,
      planAmount: plan.denomination,
      planAmountOriginal: plan.orgDenomination,
      planAmountReceiver: plan.currencyAmount,
    );
  }
}
