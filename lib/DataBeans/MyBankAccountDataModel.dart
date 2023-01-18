import 'package:daman/BaseClasses/base_data_model.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_request_key.dart';

class MyBankAccountDataModel extends BaseDataModel {
  List<MyBankAccount> data = [];

  @override
  MyBankAccountDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => MyBankAccount.fromJson(e)).toList();
    return this;
  }
}

class MyBankAccount {
  String recordId;
  String accountName;
  String number;
  String ifsc;
  String micr;
  String bankName;
  String branchName;
  String branchAddress;
  String aadhar;
  String phone;
  String email;
  String bankId;
  String paymentMethod;
  String firstName;
  String lastName;
  String accountType;
  String bankLogo;

  MyBankAccount({
    this.recordId="",
    this.accountName="",
    this.number="",
    this.ifsc="",
    this.micr="",
    this.bankName="",
    this.branchName="",
    this.branchAddress="",
    this.aadhar="",
    this.phone="",
    this.email="",
    this.bankId="",
    this.paymentMethod="",
    this.firstName="",
    this.lastName="",
    this.accountType="",
    this.bankLogo="",
  });

  factory MyBankAccount.fromJson(Map<String, dynamic> json) {
    return MyBankAccount(
      recordId: toString(json["RECORDID"]),
      accountName: toString(json["ACCNAME"]),
      number: toString(json["NUMBER"]),
      ifsc: toString(json["IFSC"]),
      micr: toString(json["MICR"]),
      bankName: toString(json["BANKNAME"]),
      branchName: toString(json["BRANCHNAME"]),
      branchAddress: toString(json["BRANCHADDRESS"]),
      aadhar: toString(json["AADHAAR"]),
      phone: toString(json["phone"]),
      email: toString(json["email"]),
      bankId: toString(json["bank_id"]),
      paymentMethod: toString(json["payment_method"]),
      firstName: toString(json["f_name"]),
      lastName: toString(json["l_name"]),
      accountType: toString(json["acc_type"]),
      bankLogo: toString(json["BANKLOGO"]),
    );
  }
}
