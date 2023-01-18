import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class AppMediaDataModel extends BaseDataModel {
  List<AppMediaModel> data = [];

  @override
  AppMediaDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    data = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => AppMediaModel.fromJson(e))
        .toList();
    return this;
  }
}

class AppMediaModel {
  String id;
  String title;
  String description;
  String backgroundColor;
  String appAction;
  String imageFor;
  String rewardId;
  String operatorId;
  String serviceId;
  String rewardTitle;
  String operatorTitle;
  String serviceTitle;
  String image;

  AppMediaModel({
    this.id = "",
    this.title = "",
    this.description = "",
    this.backgroundColor = "",
    this.appAction = "",
    this.imageFor = "",
    this.rewardId = "",
    this.operatorId = "",
    this.serviceId = "",
    this.rewardTitle = "",
    this.operatorTitle = "",
    this.serviceTitle = "",
    this.image = "",
  });

  factory AppMediaModel.fromJson(Map<dynamic, dynamic> json) {
    return AppMediaModel(
      id: toString(json["id"]),
      title: toString(json["title"]),
      description: toString(json["description"]),
      backgroundColor: toString(json["background_color"]),
      appAction: toString(json["app_action"]),
      imageFor: toString(json["image_for"]),
      rewardId: toString(json["reward_id"]),
      operatorId: toString(json["operator_id"]),
      serviceId: toString(json["service_id"]),
      rewardTitle: toString(json["reward_title"]),
      operatorTitle: toString(json["operator_title"]),
      image: toString(json["image"]),
      serviceTitle: toString(json["service_title"]),
    );
  }
}
