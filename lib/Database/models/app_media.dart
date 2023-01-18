import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/AppMediaDataModel.dart';
part 'app_media.g.dart';

@HiveType(typeId: 9)
class AppMedia extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late String backgroundColor;
  @HiveField(4)
  late String appAction;
  @HiveField(5)
  late String imageFor;
  @HiveField(6)
  late String rewardId;
  @HiveField(7)
  late String operatorId;
  @HiveField(8)
  late String serviceId;
  @HiveField(9)
  late String rewardTitle;
  @HiveField(10)
  late String operatorTitle;
  @HiveField(11)
  late String serviceTitle;
  @HiveField(12)
  late String image;
}

extension AppMediaExtension on AppMedia {
  AppMediaModel get toAppMediaModel => AppMediaModel()
    ..id = this.id
    ..title = this.title
    ..description = this.description
    ..backgroundColor = this.backgroundColor
    ..appAction = this.appAction
    ..imageFor = this.imageFor
    ..rewardId = this.rewardId
    ..operatorId = this.operatorId
    ..serviceId = this.serviceId
    ..rewardTitle = this.rewardTitle
    ..operatorTitle = this.operatorTitle
    ..serviceTitle = this.serviceTitle
    ..image = this.image;
}

extension AppMediaModelExtension on AppMediaModel {
  AppMedia get toAppMedia => AppMedia()
    ..id = this.id
    ..title = this.title
    ..description = this.description
    ..backgroundColor = this.backgroundColor
    ..appAction = this.appAction
    ..imageFor = this.imageFor
    ..rewardId = this.rewardId
    ..operatorId = this.operatorId
    ..serviceId = this.serviceId
    ..rewardTitle = this.rewardTitle
    ..operatorTitle = this.operatorTitle
    ..serviceTitle = this.serviceTitle
    ..image = this.image;
}
