import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';

part 'service.g.dart';

@HiveType(typeId: 4)
class Service {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String type;
  @HiveField(3)
  late bool comingSoon;
  @HiveField(4)
  late String slug;
  @HiveField(5)
  late String icon;

  @override
  String toString() {
    return jsonEncode({"name": title});
  }

  Service({
    this.id = "",
    this.title = "",
    this.type = "",
    this.comingSoon = false,
    this.icon = "",
  });
}

extension ServiceExtension on Service {
  ServiceData get toServiceChild => ServiceData()
    ..id = this.id
    ..title = this.title
    ..slug = this.slug
    ..type = this.type
    ..comingSoon = this.comingSoon
    ..icon = this.icon;
}
