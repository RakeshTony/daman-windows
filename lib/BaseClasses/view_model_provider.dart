import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Ux/Authentication/ForgotPassword/ViewModel/view_model_forgot_password.dart';
import 'package:daman/Ux/Authentication/Login/ViewModel/view_model_login.dart';
import 'package:daman/Ux/Authentication/Register/ViewModel/view_model_register.dart';
import 'package:daman/Ux/Authentication/Verification/ViewModel/view_model_verification.dart';
import 'package:daman/Ux/BottomNavigation/Setting/ViewModel/view_model_enter_m_pin.dart';
import 'package:daman/Ux/BottomNavigation/Setting/ViewModel/view_model_register.dart';
import 'package:daman/Ux/BottomNavigation/Setting/ViewModel/view_model_set_m_pin.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_prefund_deposit.dart';
import 'package:daman/Ux/Collection/ViewModel/view_model_collection.dart';
import 'package:daman/Ux/DownLine/ViewModel/view_model_down_line.dart';
import 'package:daman/Ux/DownLine/ViewModel/view_model_my_down_line_users.dart';
import 'package:daman/Ux/Notification/ViewModel/view_model_notification.dart';
import 'package:daman/Ux/Payment/BankCard/ViewModel/view_model_add_beneficiary.dart';
import 'package:daman/Ux/Payment/BankCard/ViewModel/view_model_my_my_bank_account.dart';
import 'package:daman/Ux/Payment/BankCard/ViewModel/view_model_transfer_money.dart';
import 'package:daman/Ux/Payment/FundTransfer/ViewModel/view_model_fund_transfer.dart';
import 'package:daman/Ux/Payment/Request/ViewModel/view_model_add_banks.dart';
import 'package:daman/Ux/Payment/Request/ViewModel/view_model_fund_request.dart';
import 'package:daman/Ux/Payment/Request/ViewModel/view_model_fund_request_report.dart';
import 'package:daman/Ux/Payment/Send/ViewModel/view_model_pay_now.dart';
import 'package:daman/Ux/Payment/Send/ViewModel/view_model_send_money.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_cable_tv.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_data.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_electricity.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_mobile_data.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_top_up.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_mobile.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_top_up_check_out.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_commission.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_reports.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_sales_report.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_transaction.dart';
import 'package:daman/Ux/BottomNavigation/ViewModel/view_model_bottom_navigation.dart';
import 'package:daman/Ux/Others/ViewModel/view_model_configuration_setup.dart';
import 'package:daman/Ux/Profile/ViewModel/view_model_profile.dart';
import 'package:daman/Ux/Voucher/ViewModel/view_model_voucher_check_out.dart';
import 'package:daman/Ux/Voucher/ViewModel/view_redeem_voucher.dart';
import 'package:daman/Ux/Wallet/ViewModel/view_model_wallet.dart';

import '../Ux/AddUserPurchaseOrder/ViewModel/view_model_adduser_purchase_order.dart';
import '../Ux/AddUserPurchaseOrder/ViewModel/view_model_pin_local_stock.dart';
import '../Ux/BottomNavigation/Transactions/ViewModel/view_model_my_order_report.dart';
import '../Ux/Voucher/ViewModel/view_model_voucher_reprint.dart';

class ViewModelProvider {
  ViewModelProvider._();

  static final ViewModelProvider _viewModelProvider = ViewModelProvider._();

  static ViewModelProvider instance() => _viewModelProvider;

  V getViewModel<V extends BaseViewModel>() {
    switch (V) {
      case ViewModelCommon:
        return ViewModelCommon() as V;
      case ViewModelLogin:
        return ViewModelLogin() as V;
      case ViewModelRegister:
        return ViewModelRegister() as V;
      case ViewModelDownLine:
        return ViewModelDownLine() as V;
      case ViewModelMyDownLineUsers:
        return ViewModelMyDownLineUsers() as V;
      case ViewModelVerification:
        return ViewModelVerification() as V;
      case ViewModelForgotPassword:
        return ViewModelForgotPassword() as V;
      case ViewModelChangePassword:
        return ViewModelChangePassword() as V;
      case ViewModelRedeemVoucher:
        return ViewModelRedeemVoucher() as V;
      case ViewModelNotification:
        return ViewModelNotification() as V;
      case ViewModelConfigurationSetup:
        return ViewModelConfigurationSetup() as V;
      case ViewModelBottomNavigation:
        return ViewModelBottomNavigation() as V;
      case ViewModelTopUp:
        return ViewModelTopUp() as V;
      case ViewModelMobile:
        return ViewModelMobile() as V;
      case ViewModelData:
        return ViewModelData() as V;
      case ViewModelMobileData:
        return ViewModelMobileData() as V;
      case ViewModelCableTv:
        return ViewModelCableTv() as V;
      case ViewModelTopUpCheckOut:
        return ViewModelTopUpCheckOut() as V;
      case ViewModelWallet:
        return ViewModelWallet() as V;
      case ViewModelTransaction:
        return ViewModelTransaction() as V;
      case ViewModelSalesReport:
        return ViewModelSalesReport() as V;
      case ViewModelReports:
        return ViewModelReports() as V;
      case ViewModelCommission:
        return ViewModelCommission() as V;
      case ViewModelProfile:
        return ViewModelProfile() as V;
      case ViewModelVoucherCheckOut:
        return ViewModelVoucherCheckOut() as V;
      case ViewModelPrefundDeposit:
        return ViewModelPrefundDeposit() as V;
      case ViewModelSendMoney:
        return ViewModelSendMoney() as V;
      case ViewModelFundRequestReport:
        return ViewModelFundRequestReport() as V;
      case ViewModelFundTransfer:
        return ViewModelFundTransfer() as V;
      case ViewModelPayNow:
        return ViewModelPayNow() as V;
      case ViewModelFundRequest:
        return ViewModelFundRequest() as V;
      case ViewModelAddBanks:
        return ViewModelAddBanks() as V;
      case ViewModelElectricity:
        return ViewModelElectricity() as V;
      case ViewModelMyBankAccount:
        return ViewModelMyBankAccount() as V;
      case ViewModelAddBeneficiary:
        return ViewModelAddBeneficiary() as V;
      case ViewModelTransferMoney:
        return ViewModelTransferMoney() as V;
      case ViewModelCollection:
        return ViewModelCollection() as V;
      case ViewModelSetMPin:
        return ViewModelSetMPin() as V;
      case ViewModelEnterMPin:
        return ViewModelEnterMPin() as V;
      case ViewModelAddUserPurchaseOrder:
        return ViewModelAddUserPurchaseOrder() as V;
      case ViewModelPinLocalStock:
        return ViewModelPinLocalStock() as V;
      case ViewModelMyOrderReport:
        return ViewModelMyOrderReport() as V;
      case ViewModelVoucherReprint:
        return ViewModelVoucherReprint() as V;
      default:
        throw Exception("ViewModel not attach...");
    }
  }
}
