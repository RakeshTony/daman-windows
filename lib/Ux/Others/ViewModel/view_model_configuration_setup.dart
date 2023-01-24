import 'dart:async';
import 'dart:collection';

import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/AppMediaDataModel.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/DefaultConfigDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';
import 'package:daman/DataBeans/ServicesDataModel.dart';
import 'package:daman/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/app_media.dart';
import 'package:daman/Database/models/app_pages.dart';
import 'package:daman/Database/models/default_config.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';

import '../../../DataBeans/BulkOrderResponseDataModel.dart';

class ViewModelConfigurationSetup extends BaseViewModel {
  final StreamController<double> _progressStreamController = StreamController();

  Stream<double> get progressStream => _progressStreamController.stream;

  final StreamController<BulkOrderResponseDataModel>
      _responseStreamControllerSettlement = StreamController();

  Stream<BulkOrderResponseDataModel> get responseStreamSettlement =>
      _responseStreamControllerSettlement.stream;

  @override
  void disposeStream() {
    _responseStreamControllerSettlement.close();
    _progressStreamController.close();
    super.disposeStream();
  }

  void requestSync() async {
    await requestUpdatePinSoldStatus();
    await requestServices();
    await requestCurrencies();
    await requestBalanceEnquiry();
    await requestConfig();
    await requestAppMedia();
    await requestServiceOperatorsDenomination();
    await requestWallet();
    //await requestPinSettlementEnquiry();
  }

  requestServices() async {
    final box = HiveBoxes.getServicesChild();
    if (box.isNotEmpty) box.clear();
    await request(
      networkRequest.getServices(),
      (map) {
        ServicesDataModel dataModel = ServicesDataModel();
        dataModel.parseData(map);
        var countries = dataModel.getServices().map((element) {
          return element.toServiceChild;
        }).toList();
        box.addAll(countries);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.2);
  }

  requestCurrencies() async {
    final box = HiveBoxes.getCurrencies();
    if (box.isNotEmpty) box.clear();
    await request(
      networkRequest.getCurrencies(),
      (map) {
        CurrencyDataModel dataModel = CurrencyDataModel();
        dataModel.parseData(map);
        var currencies = dataModel.currencies.map((element) {
          return element.toCurrency;
        }).toList();
        box.addAll(currencies);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.5);
  }

  requestBalanceEnquiry() async {
    final box = HiveBoxes.getBalance();
    box.clear();
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["app_version"] = Encoder.encode(AppSettings.APP_VERSION);
    await request(
      networkRequest.getBalanceEnquiry(requestMap),
      (map) {
        BalanceDataModel dataModel = BalanceDataModel();
        dataModel.parseData(map);
        box.put("BAL", dataModel.balance.toBalance);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.6);
  }

  requestConfig() async {
    await request(
      networkRequest.getConfigData(),
      (map) async {
        DefaultConfigDataModel dataModel = DefaultConfigDataModel();
        dataModel.parseData(map);

        var configs = HiveBoxes.getDefaultConfig();
        if (configs.isNotEmpty) await configs.clear();
        configs.add(dataModel.data.toDefaultConfig);
        var pages = HiveBoxes.getAppPages();
        if (pages.isNotEmpty) await pages.clear();
        await pages
            .addAll(dataModel.data.appPages.map((e) => e.toAppPages).toList());
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.7);
  }

  requestAppMedia() async {
    final box = HiveBoxes.getAppMedia();
    box.clear();
    await request(
      networkRequest.getAppMedia(),
      (map) {
        AppMediaDataModel dataModel = AppMediaDataModel();
        dataModel.parseData(map);
        var medias = dataModel.data.map((element) {
          return element.toAppMedia;
        }).toList();
        box.addAll(medias);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.8);
  }

  requestServiceOperatorsDenomination() async {
    final boxService = HiveBoxes.getServices();
    final boxOperator = HiveBoxes.getOperators();
    final boxDenomination = HiveBoxes.getDenomination();
    if (boxService.isNotEmpty) boxService.clear();
    if (boxOperator.isNotEmpty) boxOperator.clear();
    if (boxDenomination.isNotEmpty) boxDenomination.clear();
    await request(
      networkRequest.getServiceOperatorDenomination(),
      (map) {
        ServiceOperatorDenominationDataModel dataModel =
            ServiceOperatorDenominationDataModel();
        dataModel.parseData(map);
        var services = dataModel.getServices().map((element) {
          return element.toService;
        }).toList();
        var operators = dataModel.getOperators().map((element) {
          return element.toOperator;
        }).toList();
        var denominations = dataModel.getDenominations().map((element) {
          return element.toDenomination;
        }).toList();
        boxService.addAll(services);
        boxOperator.addAll(operators);
        boxDenomination.addAll(denominations);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.9);
  }

  requestWallet() async {
    final box = HiveBoxes.getRecentTransactions();
    if (box.values.isNotEmpty) {
      box.clear();
    }
    var requestData = HashMap<String, dynamic>();
    requestData["consider_as"] = ""; // Cr  Dr
    requestData["from_date_time"] = "";
    requestData["to_date_time"] = "";
    requestData["offset"] = 0;
    requestData["type"] = ""; // recharge , transfer ,  etc.
    await request(
      networkRequest.getWalletStatements(requestData),
      (map) {
        WalletStatementResponseDataModel dataModel =
            WalletStatementResponseDataModel();
        dataModel.parseData(map);
        var data = dataModel.statements.map((e) => e.toTransaction).toList();
        box.addAll(data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(0.95);
  }

  requestPinSettlementEnquiry() async {
    HashMap<String, dynamic> requestMap = HashMap();
    await request(
      networkRequest.doPinSettlement(requestMap),
      (map) {
        AppLog.e("LIST DATA MAP", map);
        BulkOrderResponseDataModel dataModel = BulkOrderResponseDataModel();
        dataModel.parseDataSettlement(map);
        _responseStreamControllerSettlement.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
    _progressStreamController.sink.add(1.0);
  }
}
