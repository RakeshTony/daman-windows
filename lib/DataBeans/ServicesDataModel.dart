import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Database/models/services_child.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class ServicesDataModel extends BaseDataModel {
  List<ServiceChildModel> _services = [];

  @override
  ServicesDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var list = result[AppRequestKey.RESPONSE_DATA] as List;
    this._services = list.map((e) => ServiceChildModel.fromJson(e)).toList();
    return this;
  }

  List<ServiceChildData> getServices() {
    return recursionListData(_services);
  }

  List<ServiceChildData> recursionListData(List<ServiceChildModel> data) {
    List<ServiceChildData> services = [];
    data.forEach((element) {
      services.add(element.service);
      services.addAll(recursionListData(element.children));
    });
    return services;
  }
}

class ServiceChildModel {
  ServiceChildData service;
  List<ServiceChildModel> children;

  ServiceChildModel({required this.service, required this.children});

  factory ServiceChildModel.fromJson(Map<dynamic, dynamic> json) {
    return ServiceChildModel(
      service: ServiceChildData.fromJson(json['Service']),
      children: toList(json['children'])
          .map((e) => ServiceChildModel.fromJson(e))
          .toList(),
    );
  }
}

class ServiceChildData {
  String id;
  String title;
  String parentId;
  String slug;
  String body;
  String type;
  bool status;
  bool comingSoon;
  String displayOrder;
  String modified;
  String created;
  String icon;

  ServiceChildData({
    this.id = "",
    this.title = "",
    this.parentId = "",
    this.slug = "",
    this.body = "",
    this.type = "",
    this.status = false,
    this.comingSoon = false,
    this.displayOrder = "",
    this.modified = "",
    this.created = "",
    this.icon = "",
  });

  factory ServiceChildData.fromJson(Map<dynamic, dynamic> json) {
    return ServiceChildData(
      id: toString(json["id"]),
      title: toString(json["title"]),
      parentId: toString(json["parent_id"]),
      slug: toString(json["slug"]),
      body: toString(json["body"]),
      type: toString(json["type"]),
      status: toBoolean(json["status"]),
      comingSoon: toBoolean(json["coming_soon"]),
      displayOrder: toString(json["display_order"]),
      modified: toString(json["modified"]),
      created: toString(json["created"]),
      icon: toString(json["icon"]),
    );
  }
}

extension ServiceChildDataExtension on ServiceChildData {
  ServiceChild get toServiceChild => ServiceChild()
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
