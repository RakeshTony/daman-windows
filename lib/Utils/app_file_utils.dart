import 'dart:convert';
import 'dart:io';

import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:daman/DataBeans/RemitaCustomFieldModel.dart';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';

Future<List<RemitaCustomFieldModel>> getRemitaCustomFields() async {
  //read json file
  final jsonData =
      await rootBundle.rootBundle.loadString('assets/remita_field.json');
  //decode json data as list
  final list = json.decode(jsonData) as List<dynamic>;
  //map json and initialize using DataModel
  return list.map((e) => RemitaCustomFieldModel.fromJson(e)).toList();
}

Future<String> get _localPath async {
/*
  return await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOCUMENTS);
*/
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  return appDocumentsDirectory.path;
}

Future<File> localFile(
    {String fileName = "${AppSettings.APP_NAME}.txt"}) async {
  final path = await _localPath;
  AppLog.e("FILE PATH", path);
  return File('$path/$fileName');
}

Future<File> writerFile(File file, List json) async {
  return file.writeAsString(jsonEncode(json));
}

Future<String> readFile(File file) async {
  try {
    return file.readAsString();
  } catch (e) {
    return "[]";
  }
}
