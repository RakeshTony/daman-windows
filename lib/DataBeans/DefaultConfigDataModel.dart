import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class DefaultConfigDataModel extends BaseDataModel {
  late DefaultConfigModel data;

  @override
  DefaultConfigDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    data = DefaultConfigModel.fromJson(
        toMaps(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class DefaultConfigModel {
  String balance;
  String complaint;
  String contactNo;
  String facebookUrl;
  String faq;
  String fundTransfer;
  String fUrl;
  String last5;
  String logoUrl;
  String longCode;
  String recharge;
  String register;
  String support;
  String tcUrl;
  String timeOut;
  String twitterUrl;
  String warehouse;
  String whatsAppNo;
  String website;
  String email;
  List<AppPagesModel> appPages;

  DefaultConfigModel({
    this.balance = "",
    this.complaint = "",
    this.contactNo = "",
    this.facebookUrl = "",
    this.faq = "",
    this.fundTransfer = "",
    this.fUrl = "",
    this.last5 = "",
    this.logoUrl = "",
    this.longCode = "",
    this.recharge = "",
    this.register = "",
    this.support = "",
    this.tcUrl = "",
    this.timeOut = "",
    this.twitterUrl = "",
    this.warehouse = "",
    this.whatsAppNo = "",
    this.website = "",
    this.email = "",
    this.appPages = const [],
  });

  factory DefaultConfigModel.fromJson(Map<dynamic, dynamic> json) {
    return DefaultConfigModel(
      balance: toString(json["BALANCE"]),
      complaint: toString(json["COMPLAINT"]),
      contactNo: toString(json["Contact_No"]),
      facebookUrl: toString(json["FACEBOOK_URL"]),
      faq: toString(json["FAQ"]),
      fundTransfer: toString(json["FUND_TRANSFER"]),
      fUrl: toString(json["FURL"]),
      last5: toString(json["LAST5"]),
      logoUrl: toString(json["LOGOURL"]),
      longCode: toString(json["LONGCODE"]),
      recharge: toString(json["RECHARGE"]),
      support: toString(json["SUPPORT"]),
      register: toString(json["REGISTER"]),
      tcUrl: toString(json["TCURL"]),
      timeOut: toString(json["TIMEOUT"]),
      twitterUrl: toString(json["TWITTER_URL"]),
      warehouse: toString(json["WAREHOUSE"]),
      whatsAppNo: toString(json["WhatsApp_No"]),
      website: toString(json["WEBSITE"]),
      email: toString(json["EMAIL"]),
      appPages: toList(json["APP_PAGES"])
          .map((e) => AppPagesModel.fromJson(toMaps(toMaps(e)["Content"])))
          .toList(),
    );
  }
}

class AppPagesModel {
  String content;
  String excerpt;
  String slug;
  String title;

  AppPagesModel({
    this.content = "",
    this.excerpt = "",
    this.slug = "",
    this.title = "",
  });

  factory AppPagesModel.fromJson(Map<dynamic, dynamic> json) {
    return AppPagesModel(
      content: toString(json["content"]),
      excerpt: toString(json["excerpt"]),
      slug: toString(json["slug"]),
      title: toString(json["title"]),
    );
  }
}
