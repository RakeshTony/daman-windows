import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/BulkTopUpResponseDataModel.dart';
import 'package:daman/DataBeans/CableTvBrowsePlanDataModel.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/GetParamsDataModel.dart';
import 'package:daman/DataBeans/OperatorValidateDataModel.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/pair.dart';

class ViewModelMobileData extends BaseViewModel {
  var mServiceSelected = "";
  CurrencyData? currency;
  ParamOperatorModel? operator;

  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<Pair<bool, List<FormFieldModel>>>
      _formStreamController = StreamController();

  Stream<Pair<bool, List<FormFieldModel>>> get formStream =>
      _formStreamController.stream;


  final StreamController<List<Pair<String, List<UserPlanModel>>>>
      _plansTabsStreamController = StreamController();

  Stream<List<Pair<String, List<UserPlanModel>>>> get userPlansTabsStream =>
      _plansTabsStreamController.stream;

  final StreamController<Pair<String, BulkTopUpResponseDataModel>>
      _responseStreamController = StreamController();

  Stream<Pair<String, BulkTopUpResponseDataModel>> get responseStream =>
      _responseStreamController.stream;
  final StreamController<OperatorValidateData> _fetchBillStreamController =
      StreamController();

  Stream<OperatorValidateData> get fetchBillStream =>
      _fetchBillStreamController.stream;

  @override
  void disposeStream() {
    _formStreamController.close();
    _responseStreamController.close();
    _plansTabsStreamController.close();
    _validationErrorStreamController.close();
    _fetchBillStreamController.close();
    super.disposeStream();
  }

  void requestOperatorValidate(
      String operatorId, String subscriberNumber) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["operator_id"] = Encoder.encode(operatorId);
    requestMap["subscriber"] = Encoder.encode(subscriberNumber);
    request(
      networkRequest.doOperatorValidate(requestMap),
      (map) {
        OperatorValidateDataModel dataModel = OperatorValidateDataModel();
        dataModel.parseData(map);
        _fetchBillStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestParams(String operatorId, {String circleCode = ""}) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["operator_id"] = Encoder.encode(operatorId);
    requestMap["version"] = Encoder.encode("2");
    request(
      networkRequest.getParams(requestMap),
      (map) {
        GetParamsDataModel dataModel = GetParamsDataModel();
        dataModel.parseData(map);
        if (dataModel.paramsModel != null) {
          var data = dataModel.paramsModel!;

          operator = data.operator;
          currency = data.currency;
          mServiceSelected = operator?.serviceId ?? "";


          var isPlansAvailable = false;
          if (data.isCustomPlanShow) {
            // CUSTOM PLAN
            var customPlans =
                List<Pair<String, List<UserPlanModel>>>.empty(growable: true);
            data.customPlans.forEach((e) {
              var plans =
                  e.plans.map((e) => UserPlanModel.fromCustomPlan(e)).toList();
              customPlans.add(Pair(e.title, plans));
            });
            _plansTabsStreamController.sink.add(customPlans);
            customPlans.forEach((element) {
              if (element.second.isNotEmpty) isPlansAvailable = true;
            });
          } else {
            //  API PLANS
            var apiPlans =
                List<Pair<String, List<UserPlanModel>>>.empty(growable: true);
            data.apiPlans.forEach((element) {
              var plans = element.plans
                  .map((e) => UserPlanModel.fromApiPlan(e))
                  .toList();
              apiPlans.add(Pair(element.title, plans));
            });
            _plansTabsStreamController.sink.add(apiPlans);
            apiPlans.forEach((element) {
              if (element.second.isNotEmpty) isPlansAvailable = true;
            });
          }
          _formStreamController.sink.add(Pair(isPlansAvailable, data.params));
        }
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestOperatorPlans(String operatorId, String subscriberNumber) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["operator_id"] = Encoder.encode(operatorId);
    requestMap["subscriber"] = Encoder.encode(subscriberNumber);
    request(
      networkRequest.doOperatorPlan(requestMap),
      (map) {
        CableTvBrowsePlanDataModel dataModel = CableTvBrowsePlanDataModel();
        dataModel.parseData(map);
        // _browsePlanStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestBulkTopUp({
    String mServiceId = "",
    String operatorId = "",
    String denominationId = "",
    String denominationCategoryId = "0",
    String mobile = "",
    double amount = 0.0,
    double amountOriginal = 0.0,
    double amountReceiver = 0.0,
    List<Pair<String, dynamic>> formFields = const [],
    HashMap<String, dynamic>? planParams,
  }) async {
    var min = 100000;
    var max = 999999;
    var requestNumber = min + Random.secure().nextInt(max - min);

    var mainJsonArray = [];
    var mainObject = HashMap();
    var operatorsArray = [];

    var operatorJsonObject = HashMap();
    operatorJsonObject["operator_id"] = operatorId;

    var denominationsArray = [];
    var denominationJsonObject = HashMap();

    denominationJsonObject["denomination_id"] = denominationId;
    denominationJsonObject["denomination_category_id"] = denominationCategoryId;

    denominationJsonObject["amount"] = amount;
    denominationJsonObject["mobile"] = mobile;

    if (amountOriginal == 0.0) {
      denominationJsonObject["org_amount"] = amount;
    } else {
      denominationJsonObject["org_amount"] = amountOriginal;
    }

    if (amountReceiver == 0.0) {
      denominationJsonObject["rec_amount"] = 0;
    } else {
      denominationJsonObject["rec_amount"] = amountReceiver;
    }

    // HERE ADDED DYNAMIC FORM KEYS
    var mParamArray = Map();
    formFields.forEach((element) {
      mParamArray[element.first] = element.second;
    });
    denominationJsonObject["params"] = mParamArray;
    if (planParams != null) {
      denominationJsonObject["plan_params"] = planParams;
    }
    denominationsArray.add(denominationJsonObject);
    operatorJsonObject["denominations"] = denominationsArray;
    operatorsArray.add(operatorJsonObject);

    mainObject["service_id"] = mServiceId;
    mainObject["operators"] = operatorsArray;

    mainJsonArray.add(mainObject);
    var requestData = jsonEncode(mainJsonArray);

    var params = HashMap();
    // HERE ADDED DYNAMIC FORM KEYS
    formFields.forEach((element) {
      params[element.first] = element.second;
    });
    var requestParamData = "";
    if (formFields.isNotEmpty) {
      requestParamData = jsonEncode(params);
    }

    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["request"] = Encoder.encode(requestData);
    requestMap["request_number"] = Encoder.encode(requestNumber.toString());
    AppLog.i("REQUEST BULK TOPUP DATA : " + requestData);
    AppLog.i("REQUEST BULK TOPUP PARAM : " + requestParamData);
    request(
      networkRequest.doBulkTopUp(requestMap),
      (map) {
        BulkTopUpResponseDataModel dataModel = BulkTopUpResponseDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink
            .add(Pair(requestNumber.toString(), dataModel));
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
      isResponseStatus: true,
    );
  }
}
