import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_string.dart';
import 'package:daman/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DioBuilder {
  static late Dio _dio;

  DioBuilder._() {
    _buildDioInstanceWithOptions().then((value) {
      _dio = value;
      _dio.interceptors.add(_AuthInterceptor());
      _dio.interceptors.add(_NetWorkInterceptor());
    });
  }

  static DioBuilder _dioBuilder = DioBuilder._();

  static DioBuilder get instance => _dioBuilder;

  Dio get dio => _dio;

  Future<Dio> _buildDioInstanceWithOptions() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    String _deviceId;

    if (Platform.isAndroid)
      _deviceId = (await _deviceInfo.androidInfo).androidId ?? "";
    else if (Platform.isWindows)
      _deviceId = (await _deviceInfo.windowsInfo).computerName;
    else
      _deviceId = (await _deviceInfo.iosInfo).identifierForVendor ?? "";

    AppLog.i("TOKEN DEVICE ID : " + _deviceId);

    BaseOptions _baseOptions = BaseOptions();
    _baseOptions.baseUrl = AppSettings.BASE_URL + "apis2/";
    _baseOptions.connectTimeout = 100000;
    _baseOptions.receiveTimeout = 100000;
    _baseOptions.validateStatus = (_) => true;
    _baseOptions.contentType = Headers.jsonContentType;
    _baseOptions.headers["accept"] = Headers.jsonContentType;
    _baseOptions.headers["Accept-Language"] = "en";
    _baseOptions.headers["accept-version"] = _packageInfo.buildNumber;
    _baseOptions.headers["deviceid"] = _deviceId;
    _baseOptions.headers["device-os"] = Platform.isAndroid
        ? "android"
        : Platform.isWindows
            ? "windows"
            : "ios";
    return Dio(_baseOptions);
  }
}

class _NetWorkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    ConnectivityResult _connectivityResult =
        await Connectivity().checkConnectivity();
    if (_connectivityResult == ConnectivityResult.none)
      throw NetworkException(AppString.no_internet_connection);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["token"] = mPreference.value.userToken;
    if (mPreference.value.authToken.isNotEmpty)
      options.headers["authtoken"] = mPreference.value.authToken;

    AppLog.e("URL ${options.method}", options.uri.toString());
    AppLog.e("Header", options.headers.toString());
    if (options.data is FormData) {
      var form = options.data as FormData;
      AppLog.e("Request", form.fields);
    } else {
      AppLog.e("Request", options.data.toString());
    }
    AppLog.e("Query Parameters", options.queryParameters.toString());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class NetworkException implements Exception {
  final dynamic message;

  NetworkException(this.message);
}
