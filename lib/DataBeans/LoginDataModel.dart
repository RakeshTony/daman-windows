import 'dart:convert';

import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_request_key.dart';
import 'package:daman/Utils/app_extensions.dart';

class LoginDataModel extends BaseDataModel {
  late UserData userData;
  late AuthorizeData authorizeData;
  late GroupData groupData;
  late MembershipPlanData membershipPlanData;

  @override
  LoginDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var responseData = toMap(result[AppRequestKey.RESPONSE_DATA]);
    this.userData = UserData.formJson(toMap(responseData["User"]));
    this.authorizeData =
        AuthorizeData.formJson(toMap(responseData["authorize"]));
    this.groupData = GroupData.formJson(toMap(responseData["Group"]));
    this.membershipPlanData =
        MembershipPlanData.formJson(toMap(responseData["MembershipPlan"]));
    return this;
  }
}

class UserData {
  String id;
  String username;
  String membershipPlanId;
  String userParentId;
  String email;
  String name;
  String firmName;
  String icon;
  String posKey;
  String mobile;
  String address;
  String isPosUser;
  bool activeStatus;
  String otpCode;
  String walletId;
  bool isMobileVerified;
  bool isEmailVerified;
  String isKycVerified;
  String languageId;
  bool warehouseStatus;
  String shopCode;
  String terminalId;
  bool closedLoop;
  bool isCredit;
  bool posStatus;
  bool lastLevel;
  String customerStatus;
  String currency;
  String walletCode;
  String activationRequestStatus;
  String firebaseId;
  String firebasePlanId;
  String googleAuthKey;
  String mobilePin;

  UserData({
    required this.id,
    required this.username,
    required this.membershipPlanId,
    required this.userParentId,
    required this.email,
    required this.name,
    required this.firmName,
    required this.icon,
    required this.posKey,
    required this.mobile,
    required this.address,
    required this.isPosUser,
    required this.activeStatus,
    required this.otpCode,
    required this.walletId,
    required this.isMobileVerified,
    required this.isEmailVerified,
    required this.isKycVerified,
    required this.languageId,
    required this.warehouseStatus,
    required this.shopCode,
    required this.terminalId,
    required this.closedLoop,
    required this.isCredit,
    required this.posStatus,
    required this.lastLevel,
    required this.customerStatus,
    required this.currency,
    required this.walletCode,
    required this.activationRequestStatus,
    required this.firebaseId,
    required this.firebasePlanId,
    required this.googleAuthKey,
    required this.mobilePin,
  });

  String toJson() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['username'] = username;
    map['membership_plan_id'] = membershipPlanId;
    map['user_parent_id'] = userParentId;
    map['email'] = email;
    map['name'] = name;
    map['firm_name'] = firmName;
    map['icon'] = icon;
    map['pos_key'] = posKey;
    map['mobile'] = mobile;
    map['address'] = address;
    map['is_pos_user'] = isPosUser;
    map['active_status'] = activeStatus;
    map['otp_code'] = otpCode;
    map['wallet_id'] = walletId;
    map['is_mobile_verified'] = isMobileVerified;
    map['is_email_verified'] = isEmailVerified;
    map['is_kyc_verified'] = isKycVerified;
    map['language_id'] = languageId;
    map['warehouse_status'] = warehouseStatus;
    map['shop_code'] = shopCode;
    map['terminal_id'] = terminalId;
    map['closed_loop'] = closedLoop;
    map['is_credit'] = isCredit;
    map['pos_status'] = posStatus;
    map['customer_status'] = customerStatus;
    map['currency'] = currency;
    map['wallet_code'] = walletCode;
    map['activation_request_status'] = activationRequestStatus;
    map['last_level'] = lastLevel ? 1 : 0;
    map['firebase_id'] = firebaseId;
    map['firebase_plan_id'] = firebasePlanId;
    map['google_auth_key'] = googleAuthKey;
    map['mobilepin'] = mobilePin;
    return jsonEncode(map);
  }
  UserData toUpdate(Map<dynamic, dynamic> json) {
    return UserData(
      id: json.containsKey("id") ? toString(json['id']) : id,
      username:
      json.containsKey("username") ? toString(json['username']) : username,
      membershipPlanId: json.containsKey("membership_plan_id")
          ? toString(json['membership_plan_id'])
          : membershipPlanId,
      userParentId: json.containsKey("user_parent_id")
          ? toString(json['user_parent_id'])
          : userParentId,
      email: json.containsKey("email") ? toString(json['email']) : email,
      name: json.containsKey("name") ? toString(json['name']) : name,
      firmName: json.containsKey("firm_name")
          ? toString(json['firm_name'])
          : firmName,
      icon: json.containsKey("icon") ? toString(json['icon']) : icon,
      posKey: json.containsKey("pos_key") ? toString(json['pos_key']) : posKey,
      mobile: json.containsKey("mobile") ? toString(json['mobile']) : mobile,
      address:
      json.containsKey("address") ? toString(json['address']) : address,
      isPosUser: json.containsKey("is_pos_user")
          ? toString(json['is_pos_user'])
          : isPosUser,
      activeStatus: json.containsKey("active_status")
          ? toBoolean(json['active_status'])
          : activeStatus,
      otpCode:
      json.containsKey("otp_code") ? toString(json['otp_code']) : otpCode,
      walletId: json.containsKey("wallet_id")
          ? toString(json['wallet_id'])
          : walletId,
      isMobileVerified: json.containsKey("is_mobile_verified")
          ? toBoolean(json['is_mobile_verified'])
          : isMobileVerified,
      isEmailVerified: json.containsKey("is_email_verified")
          ? toBoolean(json['is_email_verified'])
          : isEmailVerified,
      isKycVerified: json.containsKey("is_kyc_verified")
          ? toString(json['is_kyc_verified'])
          : isKycVerified,
      languageId: json.containsKey("language_id")
          ? toString(json['language_id'])
          : languageId,
      warehouseStatus: json.containsKey("warehouse_status")
          ? toBoolean(json['warehouse_status'])
          : warehouseStatus,
      shopCode: json.containsKey("shop_code")
          ? toString(json['shop_code'])
          : shopCode,
      terminalId: json.containsKey("terminal_id")
          ? toString(json['terminal_id'])
          : terminalId,
      closedLoop: json.containsKey("closed_loop")
          ? toBoolean(json['closed_loop'])
          : closedLoop,
      isCredit: json.containsKey("is_credit")
          ? toBoolean(json['is_credit'])
          : isCredit,
      posStatus: json.containsKey("pos_status")
          ? toBoolean(json['pos_status'])
          : posStatus,
      customerStatus: json.containsKey("customer_status")
          ? toString(json['customer_status'])
          : customerStatus,
      currency:
      json.containsKey("currency") ? toString(json['currency']) : currency,
      walletCode: json.containsKey("wallet_code")
          ? toString(json['wallet_code'])
          : walletCode,
      activationRequestStatus: json.containsKey("activation_request_status")
          ? toString(json['activation_request_status'])
          : activationRequestStatus,
      lastLevel: json.containsKey("last_level")
          ? toIntBoolean(json['last_level'])
          : lastLevel,
      firebaseId: json.containsKey("firebase_id")
          ? toString(json['firebase_id'])
          : firebaseId,
      firebasePlanId: json.containsKey("firebase_plan_id")
          ? toString(json['firebase_plan_id'])
          : firebasePlanId,
      googleAuthKey: json.containsKey("google_auth_key")
          ? toString(json['google_auth_key'])
          : googleAuthKey,
      mobilePin: json.containsKey("mobilepin")
          ? toString(json['mobilepin'])
          : mobilePin,
    );
  }

  factory UserData.formJson(Map<dynamic, dynamic> json) {
    return UserData(
      id: toString(json['id']),
      username: toString(json['username']),
      membershipPlanId: toString(json['membership_plan_id']),
      userParentId: toString(json['user_parent_id']),
      email: toString(json['email']),
      name: toString(json['name']),
      firmName: toString(json['firm_name']),
      icon: toString(json['icon']),
      posKey: toString(json['pos_key']),
      mobile: toString(json['mobile']),
      address: toString(json['address']),
      isPosUser: toString(json['is_pos_user']),
      activeStatus: toBoolean(json['active_status']),
      otpCode: toString(json['otp_code']),
      walletId: toString(json['wallet_id']),
      isMobileVerified: toBoolean(json['is_mobile_verified']),
      isEmailVerified: toBoolean(json['is_email_verified']),
      isKycVerified: toString(json['is_kyc_verified']),
      languageId: toString(json['language_id']),
      warehouseStatus: toBoolean(json['warehouse_status']),
      shopCode: toString(json['shop_code']),
      terminalId: toString(json['terminal_id']),
      closedLoop: toBoolean(json['closed_loop']),
      isCredit: toBoolean(json['is_credit']),
      posStatus: toBoolean(json['pos_status']),
      customerStatus: toString(json['customer_status']),
      currency: toString(json['currency']),
      walletCode: toString(json['wallet_code']),
      activationRequestStatus: toString(json['activation_request_status']),
      lastLevel: toIntBoolean(json['last_level']),
      firebaseId: toString(json['firebase_id']),
      firebasePlanId: toString(json['firebase_plan_id']),
      googleAuthKey: toString(json['google_auth_key']),
      mobilePin: toString(json['mobilepin']),
    );
  }
}

class AuthorizeData {
  String userToken;
  String authToken;

  AuthorizeData({required this.userToken, required this.authToken});

  factory AuthorizeData.formJson(Map<String, dynamic> json) {
    return AuthorizeData(
      userToken: toString(json['user_token']),
      authToken: toString(json['auth_token']),
    );
  }

  String toJson() {
    var map = Map<String, dynamic>();
    map['user_token'] = userToken;
    map['auth_token'] = authToken;
    return jsonEncode(map);
  }
}

class GroupData {
  String id;
  bool isSalesManager;
  bool smsVerification;
  String groupType;
  bool emailVerification;
  bool kycVerification;

  GroupData({
    required this.id,
    required this.isSalesManager,
    required this.smsVerification,
    required this.groupType,
    required this.emailVerification,
    required this.kycVerification,
  });

  factory GroupData.formJson(Map<String, dynamic> json) {
    return GroupData(
      id: toString(json['id']),
      isSalesManager: toBoolean(json['is_sales_mngr']),
      smsVerification: toBoolean(json['sms_verification']),
      groupType: toString(json['group_type']),
      emailVerification: toBoolean(json['email_verification']),
      kycVerification: toBoolean(json['kyc_verification']),
    );
  }

  String toJson() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['is_sales_mngr'] = isSalesManager;
    map['sms_verification'] = smsVerification;
    map['email_verification'] = emailVerification;
    map['kyc_verification'] = kycVerification;
    return jsonEncode(map);
  }
}

class MembershipPlanData {
  String customerStatus;
  String id;

  MembershipPlanData({required this.customerStatus, required this.id});

  factory MembershipPlanData.formJson(Map<String, dynamic> json) {
    return MembershipPlanData(
      customerStatus: toString(json['customer_status']),
      id: toString(json['id']),
    );
  }

  String toJson() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['customer_status'] = customerStatus;
    return jsonEncode(map);
  }
}

class ProfileDataModel extends BaseDataModel {
  late UserData userData;

  @override
  ProfileDataModel parseData(result) {
    this.statusCode = result[AppRequestKey.RESPONSE_CODE] as int;
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    var responseData = result[AppRequestKey.RESPONSE_DATA];
    this.userData = UserData.formJson(responseData["User"]);
    return this;
  }
}
