import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class AppDevice {
  AppDevice._();

  static Future<String> getDeviceId() async {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    String _deviceId;
    if (Platform.isAndroid)
      _deviceId = (await _deviceInfo.androidInfo).androidId ?? "";
    else if (Platform.isWindows)
      _deviceId = (await _deviceInfo.windowsInfo).computerName;
    else
      _deviceId = (await _deviceInfo.iosInfo).identifierForVendor ?? "";
    return _deviceId;
  }

  static Future<bool> isAndroid11() async {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var version = (await _deviceInfo.androidInfo).version;
      return (version.sdkInt ?? 0) >= 30;
    }
    return false;
  }
}
