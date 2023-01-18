import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'Languages/arabic.dart';
import 'Languages/english.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': english(),
    'ar': arabic(),
    //'ku': kurdish(),
  };

  String? get changeLanguage {
    return _localizedValues[locale.languageCode]!['changeLanguage'];
  }

  String? get signIn {
    return _localizedValues[locale.languageCode]!['signIn'];
  }

  String? get password {
    return _localizedValues[locale.languageCode]!['password'];
  }

  String? get mobileNumber {
    return _localizedValues[locale.languageCode]!['mobileNumber'];
  }

  String? get forgotPassword {
    return _localizedValues[locale.languageCode]!['forgotPassword'];
  }

  String? get languageSelected {
    return _localizedValues[locale.languageCode]!['languageSelected'];
  }

  String? get currentBalance {
    return _localizedValues[locale.languageCode]!['currentBalance'];
  }

  String? get transactions {
    return _localizedValues[locale.languageCode]!['transactions'];
  }

  String? get synchronizeData {
    return _localizedValues[locale.languageCode]!['synchronizeData'];
  }

  String? get setting {
    return _localizedValues[locale.languageCode]!['setting'];
  }

  String? get aboutUs {
    return _localizedValues[locale.languageCode]!['aboutUs'];
  }

  String? get walletBalance {
    return _localizedValues[locale.languageCode]!['walletBalance'];
  }

  String? get version {
    return _localizedValues[locale.languageCode]!['version'];
  }

  String? get selectOperator {
    return _localizedValues[locale.languageCode]!['selectOperator'];
  }

  String? get searchByName {
    return _localizedValues[locale.languageCode]!['searchByName'];
  }

  String? get buyNow {
    return _localizedValues[locale.languageCode]!['buyNow'];
  }

  String? get loggingOut {
    return _localizedValues[locale.languageCode]!['loggingOut'];
  }

  String? get areYouSure {
    return _localizedValues[locale.languageCode]!['areYouSure'];
  }

  String? get yes {
    return _localizedValues[locale.languageCode]!['yes'];
  }

  String? get no {
    return _localizedValues[locale.languageCode]!['no'];
  }

  String? get backPressAgainExit {
    return _localizedValues[locale.languageCode]!['backPressAgainExit'];
  }

  String? get profile {
    return _localizedValues[locale.languageCode]!['profile'];
  }

  String? get submit {
    return _localizedValues[locale.languageCode]!['submit'];
  }

  String? get fullName {
    return _localizedValues[locale.languageCode]!['fullName'];
  }

  String? get emailAddress {
    return _localizedValues[locale.languageCode]!['emailAddress'];
  }

  String? get address {
    return _localizedValues[locale.languageCode]!['address'];
  }

  String? get userName {
    return _localizedValues[locale.languageCode]!['userName'];
  }

  String? get wallet {
    return _localizedValues[locale.languageCode]!['wallet'];
  }

  String? get recentTransactions {
    return _localizedValues[locale.languageCode]!['recentTransactions'];
  }

  String? get opening {
    return _localizedValues[locale.languageCode]!['opening'];
  }

  String? get closing {
    return _localizedValues[locale.languageCode]!['closing'];
  }

  String? get redeemVoucher {
    return _localizedValues[locale.languageCode]!['redeemVoucher'];
  }

  String? get enterVoucherCode {
    return _localizedValues[locale.languageCode]!['enterVoucherCode'];
  }

  String? get notifications {
    return _localizedValues[locale.languageCode]!['notifications'];
  }

  String? get reports {
    return _localizedValues[locale.languageCode]!['reports'];
  }

  String? get salesReport {
    return _localizedValues[locale.languageCode]!['salesReport'];
  }

  String? get myTransactions {
    return _localizedValues[locale.languageCode]!['myTransactions'];
  }

  String? get operator {
    return _localizedValues[locale.languageCode]!['operator'];
  }

  String? get profit {
    return _localizedValues[locale.languageCode]!['profit'];
  }

  String? get sales {
    return _localizedValues[locale.languageCode]!['sales'];
  }

  String? get salesCount {
    return _localizedValues[locale.languageCode]!['salesCount'];
  }

  String? get openingBalance {
    return _localizedValues[locale.languageCode]!['openingBalance'];
  }

  String? get totalSales {
    return _localizedValues[locale.languageCode]!['totalSales'];
  }

  String? get refunded {
    return _localizedValues[locale.languageCode]!['refunded'];
  }

  String? get totalProfit {
    return _localizedValues[locale.languageCode]!['totalProfit'];
  }

  String? get totalWalletFunding {
    return _localizedValues[locale.languageCode]!['totalWalletFunding'];
  }

  String? get totalBalance {
    return _localizedValues[locale.languageCode]!['totalBalance'];
  }

  String? get closingBalance {
    return _localizedValues[locale.languageCode]!['closingBalance'];
  }

  String? get filter {
    return _localizedValues[locale.languageCode]!['filter'];
  }

  String? get search {
    return _localizedValues[locale.languageCode]!['search'];
  }

  String? get enterMPin {
    return _localizedValues[locale.languageCode]!['enterMPin'];
  }

  String? get resetMPin {
    return _localizedValues[locale.languageCode]!['resetMPin'];
  }

  String? get areYouSureYouWantToResetTheMPin {
    return _localizedValues[locale.languageCode]![
        'areYouSureYouWantToResetTheMPin'];
  }

  String? get reset {
    return _localizedValues[locale.languageCode]!['reset'];
  }

  String? get continueSubmit {
    return _localizedValues[locale.languageCode]!['continueSubmit'];
  }

  String? get donTHaveAnAccount {
    return _localizedValues[locale.languageCode]!['donTHaveAnAccount'];
  }

  String? get signUp {
    return _localizedValues[locale.languageCode]!['signUp'];
  }

  String? get userIDMobileNumber {
    return _localizedValues[locale.languageCode]!['userIDMobileNumber'];
  }

  String? get backTo {
    return _localizedValues[locale.languageCode]!['backTo'];
  }

  String? get login {
    return _localizedValues[locale.languageCode]!['login'];
  }

  String? get myDownline {
    return _localizedValues[locale.languageCode]!['myDownline'];
  }

  String? get addPurchaseOrder {
    return _localizedValues[locale.languageCode]!['addPurchaseOrder'];
  }

  String? get addMoney {
    return _localizedValues[locale.languageCode]!['addMoney'];
  }

  String? get chooseService {
    return _localizedValues[locale.languageCode]!['chooseService'];
  }

  String? get chooseOperator {
    return _localizedValues[locale.languageCode]!['chooseOperator'];
  }

  String? get localPinsStock {
    return _localizedValues[locale.languageCode]!['localPinsStock'];
  }

  String? get myOrderReport {
    return _localizedValues[locale.languageCode]!['myOrderReport'];
  }

  String? get dueCredit {
    return _localizedValues[locale.languageCode]!['dueCredit'];
  }

  String? get refillBalance {
    return _localizedValues[locale.languageCode]!['refillBalance'];
  }

  String? get commissionReport {
    return _localizedValues[locale.languageCode]!['commissionReport'];
  }

  String? get prefundDepositSummary {
    return _localizedValues[locale.languageCode]!['prefundDepositSummary'];
  }

  String? get walletTopupBankTransfer {
    return _localizedValues[locale.languageCode]!['walletTopupBankTransfer'];
  }

  String? get creditRequest {
    return _localizedValues[locale.languageCode]!['creditRequest'];
  }

  String? get setupBasicConfiguration {
    return _localizedValues[locale.languageCode]!['setupBasicConfiguration'];
  }

  String? get loading {
    return _localizedValues[locale.languageCode]!['loading'];
  }

  String? get enterServerPin {
    return _localizedValues[locale.languageCode]!['enterServerPin'];
  }

  String? get confirmResetPinMessage {
    return _localizedValues[locale.languageCode]!['confirmResetPinMessage'];
  }

  String? get cancel {
    return _localizedValues[locale.languageCode]!['cancel'];
  }

  String? get newPinsetPin {
    return _localizedValues[locale.languageCode]!['setPin'];
  }

  String? get newPin {
    return _localizedValues[locale.languageCode]!['newPin'];
  }

  String? get confirmPin {
    return _localizedValues[locale.languageCode]!['confirmPin'];
  }

  String? get pleaseEnterPin {
    return _localizedValues[locale.languageCode]!['pleaseEnterPin'];
  }

  String? get pleaseEnter4DigitPin {
    return _localizedValues[locale.languageCode]!['pleaseEnter4DigitPin'];
  }

  String? get pleaseEnterConfirmPin {
    return _localizedValues[locale.languageCode]!['pleaseEnterConfirmPin'];
  }

  String? get pleaseEnter4DigitConfirmPin {
    return _localizedValues[locale.languageCode]![
        'pleaseEnter4DigitConfirmPin'];
  }

  String? get pinNotMatch {
    return _localizedValues[locale.languageCode]!['pinNotMatch'];
  }

  String? get apply {
    return _localizedValues[locale.languageCode]!['apply'];
  }

  String? get fromDate {
    return _localizedValues[locale.languageCode]!['fromDate'];
  }

  String? get toDate {
    return _localizedValues[locale.languageCode]!['toDate'];
  }

  String? get depositDate {
    return _localizedValues[locale.languageCode]!['depositDate'];
  }

  String? get debitNote {
    return _localizedValues[locale.languageCode]!['debitNote'];
  }

  String? get amount {
    return _localizedValues[locale.languageCode]!['amount'];
  }

  String? get walletTopupReport {
    return _localizedValues[locale.languageCode]!['walletTopupReport'];
  }

  String? get creditReport {
    return _localizedValues[locale.languageCode]!['creditReport'];
  }

  String? get requestedBy {
    return _localizedValues[locale.languageCode]!['requestedBy'];
  }

  String? get requestedDate {
    return _localizedValues[locale.languageCode]!['requestedDate'];
  }

  String? get status {
    return _localizedValues[locale.languageCode]!['status'];
  }

  String? get yourPrice {
    return _localizedValues[locale.languageCode]!['yourPrice'];
  }

  String? get customerPrice {
    return _localizedValues[locale.languageCode]!['yourPrice'];
  }

  String? get localPinStock {
    return _localizedValues[locale.languageCode]!['localPinStock'];
  }

  String? get share {
    return _localizedValues[locale.languageCode]!['share'];
  }

  String? get getPrint {
    return _localizedValues[locale.languageCode]!['getPrint'];
  }

  String? get paymentMode {
    return _localizedValues[locale.languageCode]!['paymentMode'];
  }

  String? get walletTopup {
    return _localizedValues[locale.languageCode]!['walletTopup'];
  }

  String? get makeRequest {
    return _localizedValues[locale.languageCode]!['makeRequest'];
  }

  String? get walletTransferTopupRequest {
    return _localizedValues[locale.languageCode]!['walletTransferTopupRequest'];
  }

  String? get changePassword {
    return _localizedValues[locale.languageCode]!['changePassword'];
  }

  String? get mPin {
    return _localizedValues[locale.languageCode]!['mPin'];
  }

  String? get oldPassword {
    return _localizedValues[locale.languageCode]!['oldPassword'];
  }

  String? get newPassword {
    return _localizedValues[locale.languageCode]!['newPassword'];
  }

  String? get confirmPassword {
    return _localizedValues[locale.languageCode]!['confirmPassword'];
  }

  String? get addDownlineUser {
    return _localizedValues[locale.languageCode]!['addDownlineUser'];
  }

  String? get myDOwnlineUsers {
    return _localizedValues[locale.languageCode]!['myDOwnlineUsers'];
  }

  String? get sendMoney {
    return _localizedValues[locale.languageCode]!['sendMoney'];
  }

  String? get balance {
    return _localizedValues[locale.languageCode]!['balance'];
  }

  String? get registerDownline {
    return _localizedValues[locale.languageCode]!['registerDownline'];
  }

  String? get register {
    return _localizedValues[locale.languageCode]!['register'];
  }

  String? get total {
    return _localizedValues[locale.languageCode]!['total'];
  }

  String? get title {
    return _localizedValues[locale.languageCode]!['title'];
  }

  String? get mobileNumberAccountNumber {
    return _localizedValues[locale.languageCode]!['mobileNumberAccountNumber'];
  }

  String? get transactionsId {
    return _localizedValues[locale.languageCode]!['transactionsId'];
  }

  String? get selectMainType {
    return _localizedValues[locale.languageCode]!['selectMainType'];
  }

  String? get paymentDate {
    return _localizedValues[locale.languageCode]!['paymentDate'];
  }

  String? get settleCredits {
    return _localizedValues[locale.languageCode]!['settleCredits'];
  }

  String? get enterAmount {
    return _localizedValues[locale.languageCode]!['enterAmount'];
  }

  String? get remark {
    return _localizedValues[locale.languageCode]!['remark'];
  }

  String? get uploadReceipt {
    return _localizedValues[locale.languageCode]!['uploadReceipt'];
  }

  String? get rank {
    return _localizedValues[locale.languageCode]!['rank'];
  }

  String? get recentlyAdded {
    return _localizedValues[locale.languageCode]!['recentlyAdded'];
  }

  String? get recentWalletTopup {
    return _localizedValues[locale.languageCode]!['recentWalletTopup'];
  }

  String? get selectState {
    return _localizedValues[locale.languageCode]!['selectState'];
  }

  String? get selectPlan {
    return _localizedValues[locale.languageCode]!['selectPlan'];
  }

  String? get selectRank {
    return _localizedValues[locale.languageCode]!['selectRank'];
  }

  String? get lowWalletBalance {
    return _localizedValues[locale.languageCode]!['lowWalletBalance'];
  }

  String? get selectLocalGovt {
    return _localizedValues[locale.languageCode]!['selectLocalGovt'];
  }

  String? get name {
    return _localizedValues[locale.languageCode]!['name'];
  }

  String? get selectBank {
    return _localizedValues[locale.languageCode]!['selectBank'];
  }

  String? get selectUserBank {
    return _localizedValues[locale.languageCode]!['selectUserBank'];
  }

  String? get paymentType {
    return _localizedValues[locale.languageCode]!['paymentType'];
  }

  String? get fundRequest {
    return _localizedValues[locale.languageCode]!['fundRequest'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  static AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

//, 'ku'
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
