import 'package:encrypt/encrypt.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/main.dart';

class Encoder {
  static String encode(String params) {
    if (params.isEmpty) return "";
    final key = Key.fromUtf8(mPreference.value.userToken);
    final iv = IV.fromUtf8(mPreference.value.userIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(params, iv: iv);
    return encrypted.base64;
  }

  static String decode(String data, {bool isLocalIv = false}) {
    if (data.isEmpty) return "";
    final key = Key.fromUtf8(mPreference.value.userToken);
    final iv =
        IV.fromUtf8(isLocalIv ? AppSettings.USER_IV : mPreference.value.userIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted.from64(data);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  static String decodeDefault(String data) {
    if (data.isEmpty) return "";
    final key = Key.fromUtf8(AppSettings.USER_TOKEN);
    final iv = IV.fromUtf8(AppSettings.USER_IV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted.from64(data);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
