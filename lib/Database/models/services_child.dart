import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:daman/DataBeans/ServicesDataModel.dart';

part 'services_child.g.dart';

@HiveType(typeId: 1)
class ServiceChild {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String parentId;
  @HiveField(3)
  late String slug;
  @HiveField(4)
  late String body;
  @HiveField(5)
  late String type;
  @HiveField(6)
  late bool status;
  @HiveField(7)
  late bool comingSoon;
  @HiveField(8)
  late String displayOrder;
  @HiveField(9)
  late String modified;
  @HiveField(10)
  late String created;
  @HiveField(11)
  late String icon;

  @override
  String toString() {
    var data = {};
    data["id"] = id;
    data["title"] = title;
    data["parentId"] = parentId;
    return jsonEncode(data);
  }
}

extension ServiceChildExtension on ServiceChild {
  ServiceChildData get toServiceChild => ServiceChildData()
    ..id = this.id
    ..title = this.title
    ..parentId = this.parentId
    ..slug = this.slug
    ..body = this.body
    ..type = this.type
    ..status = this.status
    ..comingSoon = this.comingSoon
    ..displayOrder = this.displayOrder
    ..modified = this.modified
    ..created = this.created
    ..icon = this.icon;
}
