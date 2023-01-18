import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Utils/app_file_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:daman/NetworkRequest/network_request.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_request_code.dart';
import 'package:daman/Utils/app_request_key.dart';
import 'package:daman/Utils/app_string.dart';
import 'package:permission_handler/permission_handler.dart';

import '../DataBeans/PinsStatusUpdateDataModel.dart';

abstract class BaseViewModel {
  @protected
  NetworkRequest networkRequest = NetworkRequest.instance;

  final StreamController<Map<String, dynamic>> _errorStreamController =
      StreamController();

  Stream<Map<String, dynamic>> get errorStream => _errorStreamController.stream;

  final StreamController<String> _localSyncStreamController =
      StreamController();

  Stream<String> get localSyncStream => _localSyncStreamController.stream;

  final StreamController<Map<String, dynamic>> _requestTypeStreamController =
      StreamController();

  Stream<Map<String, dynamic>> get requestTypeStream =>
      _requestTypeStreamController.stream;

  @mustCallSuper
  void disposeStream() {
    _localSyncStreamController.close();
    _errorStreamController.close();
    _requestTypeStreamController.close();
  }

  @protected
  request(Future<Response> request, Function(Map<String, dynamic>) onSuccess,
      {RequestType requestType = RequestType.NONE,
      ErrorType errorType = ErrorType.NONE,
      bool isResponseStatus = false}) async {
    try {
      ConnectivityResult _connectivityResult =
          await Connectivity().checkConnectivity();
      if (_connectivityResult == ConnectivityResult.none) {
        return _throwError(AppRequestCode.SERVER_ERROR,
            AppString.no_internet_connection, errorType);
      } else {
        _handleProgress(true, requestType);
        Response<dynamic> response = await request;
        _handleProgress(false, requestType);
        AppLog.e("Result ${response.statusCode}", response.data);
        if (response.data != null && response.data.isNotEmpty) {
          String _decodeBody = Encoder.decode(response.data);
          AppLog.e("Result ${response.statusCode}", _decodeBody);
          var _resultBody = jsonDecode(_decodeBody);
          if (toInt(_resultBody[AppRequestKey.RESPONSE_CODE]) == 401) {
            return _throwError(401,
                toString(_resultBody[AppRequestKey.RESPONSE_MSG]), errorType);
          } else if (toBoolean(_resultBody[AppRequestKey.RESPONSE]) ||
              isResponseStatus) {
            onSuccess(_resultBody);
            return AppRequestCode.OK;
          } else {
            return _throwError(response.statusCode,
                toString(_resultBody[AppRequestKey.RESPONSE_MSG]), errorType);
          }
        } else {
          return _throwError(
              response.statusCode, response.statusMessage, errorType);
        }
      }
    } on DioError catch (dioError) {
      _handleProgress(false, requestType);
      if (dioError.type == DioErrorType.connectTimeout)
        return _throwError(AppRequestCode.SERVER_ERROR,
            AppString.connection_time_out, ErrorType.NONE);
      else if (dioError.type == DioErrorType.other) {
        AppLog.e("ERROR_OTHER", dioError.error.toString());
        var error = dioError.error.toString();
        if (error.contains("Network is unreachable")) {
          return _throwError(AppRequestCode.SERVER_ERROR,
              AppString.no_internet_connection, ErrorType.POPUP);
        } else {
          return _throwError(AppRequestCode.SERVER_ERROR,
              AppString.something_went_wrong, ErrorType.NONE);
        }
      } else {
        return _throwError(AppRequestCode.SERVER_ERROR, "", ErrorType.NONE);
      }
    } on Exception {
      _handleProgress(false, requestType);
      return _throwError(AppRequestCode.SERVER_ERROR,
          AppString.something_went_wrong, ErrorType.BANNER);
    }
  }

  int _throwError(int? statusCode, String? message, ErrorType errorType) {
    _errorStreamController.sink.add({
      AppRequestKey.RESPONSE_CODE: statusCode,
      AppRequestKey.RESPONSE_MSG: message,
      AppRequestKey.ERROR_TYPE: errorType,
    });
    return statusCode ?? 0;
  }

  void _handleProgress(bool status, RequestType type) {
    _requestTypeStreamController.sink.add({
      AppRequestKey.SHOW_PROGRESS: status,
      AppRequestKey.PROGRESS_TYPE: type,
    });
  }

  requestUpdatePinSoldStatus() async {
    var mSoldPins = await getSoldPinsForAPI();
    if (mSoldPins.isNotEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["string"] = Encoder.encode(mSoldPins);
      await request(
        networkRequest.doUpdatePinPrintStatus(requestMap),
        (map) {
          PinsStatusUpdateDataModel dataModel = PinsStatusUpdateDataModel();
          dataModel.parseData(map);
          _deleteItem(dataModel.data);
          _localSyncStreamController.sink.add("SKIP");
        },
        errorType: ErrorType.NONE,
        requestType: RequestType.NONE,
      );
    } else {
      _localSyncStreamController.sink.add("SKIP");
    }
  }

  Future<String> getSoldPinsForAPI() async {
    // FETCH PIN SOLD IN DATABASE
    var mSoldPins = HiveBoxes.getOfflinePinStock()
        .values
        .where((element) => element.isSold == true)
        .toList();
    var buffer = new StringBuffer();
    for (int i = 0; i < mSoldPins.length; i++) {
      DateTime dateTime = DateTime.parse(mSoldPins[i].usedDate);
      if (i > 0) {
        buffer.write(",");
      }
      buffer.write(mSoldPins[i].recordId);
      buffer.write("|");
      buffer.write(dateTime.millisecondsSinceEpoch);
      AppLog.e("DATABASE PINS SYNC", mSoldPins[i].recordId);
    }
    // FETCH PIN SOLD IN LOCAL FILE
    if (await Permission.storage.isGranted) {
      try {
        var mFile = await localFile();
        var mFilePins = jsonDecode(await readFile(mFile)) as List;
        mFilePins.forEach((element) {
          var map = element as Map;
          if (map.containsKey("recordId")) {
            if (!buffer.toString().contains(map["recordId"])) {
              if (buffer.toString().length > 0) buffer.write(",");
              DateTime dateTime = DateTime.parse(map["usedDate"]);
              buffer.write(map["recordId"]);
              buffer.write("|");
              buffer.write(dateTime.millisecondsSinceEpoch);
              AppLog.e("LOCAL PINS SYNC", map["recordId"]);
            }
          }
        });
      } catch (e) {
        AppLog.e("FILE READ ERROR", e.toString());
      }
    }
    AppLog.e("SOLD PINS ALL", buffer.toString());
    return buffer.toString();
  }

  Future<void> _deleteItem(List<PinsId> pinsData) async {
    var mPinDeleted = List.empty(growable: true);
    for (int j = 0; j < pinsData.length; j++) {
      AppLog.e("LOCAL PIN DELETE", pinsData[j].id);
      mPinDeleted.add(pinsData[j].id);
      await HiveBoxes.getOfflinePinStock().delete(pinsData[j].id);
    }
    // DELETE LOCAL FILE PINS
    if (await Permission.storage.isGranted) {
      var mPins = List.empty(growable: true);
      var mFile = await localFile();
      var mFilePins = jsonDecode(await readFile(mFile)) as List;
      mFilePins.forEach((element) {
        var map = element as Map;
        if (map.containsKey("recordId")) {
          if (!mPinDeleted.contains(map["recordId"])) {
            mPins.add(element);
          }
        }
      });
      await writerFile(mFile, mPins);
    }
  }
}
