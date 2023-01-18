import 'package:daman/Ux/BottomNavigation/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:daman/DataBeans/BulkOrderResponseDataModel.dart';
import 'package:daman/DataBeans/BulkTopUpResponseDataModel.dart';
import 'package:daman/DataBeans/CurrencyDataModel.dart';
import 'package:daman/DataBeans/GetParamsDataModel.dart';
import 'package:daman/DataBeans/MyBankAccountDataModel.dart';
import 'package:daman/DataBeans/OperatorValidateDataModel.dart';
import 'package:daman/DataBeans/ReprintResponseDataModel.dart';
import 'package:daman/DataBeans/UserWalletDetailsData.dart';
import 'package:daman/Database/models/denomination.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Database/models/services_child.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Ux/Authentication/ForgotPassword/forgot_password_page.dart';
import 'package:daman/Ux/Authentication/Login/login_page.dart';
import 'package:daman/Ux/Authentication/Register/register_page.dart';
import 'package:daman/Ux/Authentication/Verification/verification_page.dart';
import 'package:daman/Ux/BottomNavigation/HelpSupport/help_and_support.dart';
import 'package:daman/Ux/BottomNavigation/Setting/about_us_page.dart';
import 'package:daman/Ux/BottomNavigation/Setting/change_password_page.dart';
import 'package:daman/Ux/BottomNavigation/Setting/set_pin_page.dart';
import 'package:daman/Ux/BottomNavigation/Setting/settings_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/recharge_reprint_page.dart';
import 'package:daman/Ux/Collection/services_page.dart';
import 'package:daman/Ux/DownLine/down_line_page.dart';
import 'package:daman/Ux/DownLine/my_down_line_users_page.dart';
import 'package:daman/Ux/Notification/notification_page.dart';
import 'package:daman/Ux/Payment/FundTransfer/fund_transfer_page.dart';
import 'package:daman/Ux/Profile/kyc_page.dart';
import 'package:daman/Ux/Payment/BankCard/add_beneficiary_page.dart';
import 'package:daman/Ux/Payment/BankCard/my_bank_account.dart';
import 'package:daman/Ux/Payment/BankCard/transfer_bank_card_page.dart';
import 'package:daman/Ux/Payment/BankCard/transfer_money_page.dart';
import 'package:daman/Ux/Payment/Request/fund_request_report_page.dart';
import 'package:daman/Ux/Payment/Request/request_money_page.dart';
import 'package:daman/Ux/Payment/Send/send_money_page.dart';
import 'package:daman/Ux/Topup/cable_tv_page.dart';
import 'package:daman/Ux/Topup/data_page.dart';
import 'package:daman/Ux/Topup/electricity_page.dart';
import 'package:daman/Ux/Topup/mobile_data_page.dart';
import 'package:daman/Ux/Topup/mobile_page.dart';
import 'package:daman/Ux/Topup/topup_page.dart';
import 'package:daman/Ux/Topup/recharge_status_page.dart';
import 'package:daman/Ux/Topup/topup_operator_page.dart';
import 'package:daman/Ux/Topup/topup_check_out_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/commision_report_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/custom_range_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/my_transaction_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/prefund_deposit_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/sales_filter_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/sales_report_page.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/transactions_page.dart';
import 'package:daman/Ux/Voucher/redeem_voucher.dart';
import 'package:daman/Ux/Voucher/voucher_checkout_page.dart';
import 'package:daman/Ux/Voucher/voucher_process_page.dart';
import 'package:daman/Ux/Voucher/voucher_search_page.dart';
import 'package:daman/Ux/Voucher/operator_page.dart';
import 'package:daman/Ux/BottomNavigation/bottom_navigation.dart';
import 'package:daman/Ux/Others/change_language_page.dart';
import 'package:daman/Ux/Others/configuration_setup_page.dart';
import 'package:daman/Ux/Others/page_not_found.dart';
import 'package:daman/Ux/Others/splash.dart';
import 'package:daman/Ux/Profile/profile_page.dart';
import 'package:daman/Ux/Payment/Request/add_bank_page.dart';
import 'package:daman/Ux/BottomNavigation/Setting/enter_pin_page.dart';
import 'package:daman/Ux/Payment/Send/pay_now_page.dart';
import 'package:daman/Ux/Payment/scan_pay_page.dart';
import 'package:daman/Ux/Wallet/wallet_page.dart';

import '../DataBeans/VoucherReprintResponseDataModel.dart';
import '../Ux/AddUserPurchaseOrder/add_user_purchase_order_page.dart';
import '../Ux/AddUserPurchaseOrder/pins_local_stock.dart';
import '../Ux/AddUserPurchaseOrder/voucher_purchase_order_page.dart';
import '../Ux/BottomNavigation/Transactions/my_order_report_page.dart';
import '../Ux/Payment/Request/wallet_request_filter_page.dart';
import '../Ux/Voucher/voucher_reprint.dart';
import '../Ux/Voucher/voucher_reprint_share_page.dart';

class PageRoutes {
  PageRoutes._();

  static const String languagePage = '/language_page';
  static const String sync = '/sync';
  static const String signInNavigator = '/signInNavigator';
  static const String bottomNavigation = '/home';
  static const String operator = '/operator';
  static const String services = '/services';
  static const String voucherSearch = '/voucher/operator/search';
  static const String voucherProcess = '/voucher/operator/search/process';
  static const String voucherCheckOut =
      '/voucher/operator/search/process/Checkout';

  static const String mobileData = '/mobileData/page';
  static const String mobile = '/mobile/page';
  static const String data = '/data/page';
  static const String electricity = '/electricity/page';
  static const String cableTv = '/cableTv/page';

  static const String topUpPage = '/topUp/page';
  static const String topUpOperator = '/topUp/operator';
  static const String topUpCheckOut = '/topUp/operator/browsePlans/checkOut';

  static const String rechargeStatus = '/recharge/status';
  static const String reprintPage = 'transaction/reprint';
  static const String settings = '/settings';
  static const String helpAndSupport = '/helpAndSupport';
  static const String changePassword = '/settings/changePassword';
  static const String setPin = '/settings/setPin';
  static const String redeemVoucher = '/voucher/redeemVoucher';
  static const String notificationPage = '/notification/notificationPage';
  static const String aboutUs = '/settings/aboutUs';
  static const String transactions = '/transactions';
  static const String commissionReport = '/transactions/commissionReport';
  static const String myOrderReport = '/transactions/myOrderReport';
  static const String addUserPurchaseOrder = '/addUserPurchaseOrder/addUserPurchaseOrder';
  static const String voucherPurchaseOrderPage = '/addUserPurchaseOrder/VoucherPurchaseOrderPage';
  static const String voucherLocalPinsStockPage = '/addUserPurchaseOrder/LocalPinsStockPage';
  static const String voucherReprintShare = '/voucher/voucherReprintShare';
  static const String voucherReprintPage = 'voucher/voucherReprint';
  static const String preFundDeposit = '/transactions/preFundDeposit';
  static const String salesReport = '/transactions/salesReport';
  static const String salesFilter = '/transactions/salesReport/salesFilter';
  static const String walletRequestFilter =
      '/payments/walletRequest/walletRequestFilter';
  static const String customRange = '/transactions/customRange';
  static const String myTransaction = '/transactions/customRange/myTransaction';
  static const String profile = '/profile';
  static const String kyc = '/kyc';
  static const String wallet = '/wallet';
  static const String walletTopUp = '/wallet/topUp';
  static const String scanPay = '/scanPay';
  static const String fundRequestReport = '/scanPay/fundRequestReport';
  static const String fundTransfer = '/scanPay/fundTransfer';
  static const String payNow = '/scanPay/payNow';
  static const String addBank = '/scanPay/addBank';
  static const String addMyBankAccount = '/scanPay/myBank';
  static const String addBeneficiary = '/scanPay/addBeneficiary';
  static const String transferMoney = '/scanPay/transferMoney';
  static const String transferBankCardPage = '/scanPay/static const String';
  static const String enterPin = '/scanPay/payNow/enterPin';
  static const String downLine = '/downLine/page';
  static const String downLineUsersList = '/downLine/users/page';

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/login/signUp';
  static const String verification = '/login/verification';
  static const String forgotPassword = '/login/forgot_password';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    AppLog.i("Route : ${routeSettings.name}");
    AppLog.i("Arguments : $args");

    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => Splash());
      case login:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => LoginPage());
      case signUp:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => RegisterPage());
      case verification:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (context) =>
                VerificationPage(args as RedirectVerificationModel, () {
                  Navigator.popAndPushNamed(context, PageRoutes.sync);
                }));
      case forgotPassword:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ForgotPasswordPage());
      case sync:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ConfigurationSetupPage());
      case bottomNavigation:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => DashboardPage());
/*
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => BottomNavigation());
*/

      case languagePage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ChangeLanguagePage());

      case topUpPage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => TopUpPage(args as ServiceChild));

      case operator:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => OperatorPage(args as ServiceChild));

      case services:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ServicesPage(args as ServiceChild));

      case voucherSearch:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => VoucherSearchPage(args as Operator));

      case voucherProcess:
        {
          var data = args as Map;
          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => VoucherProcessPage(
                data['denomination'] as Denomination,
                data['operator'] as Operator),
          );
        }
      case voucherCheckOut:
        {
          var data = args as Map;
          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => VoucherCheckOutPage(
                data['voucher'] as List<VoucherDenomination>,
                data['operator'] as Operator),
          );
        }

      case topUpOperator:
        {
          String mobile = "";
          String countryId = "";
          String countryCode = "";
          String countryFlag = "";
          String operatorId = "";
          String circleCode = "";
          if (args is Map) {
            mobile = args["mobile"];
            countryId = args["countryId"];
            countryCode = args["countryCode"];
            countryFlag = args["countryFlag"];
            operatorId = args["operatorId"];
            circleCode = args["circleCode"];
          }
          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => TopUpOperatorPage(
              mobileNumber: mobile,
              countryId: countryId,
              countryCode: countryCode,
              countryFlag: countryFlag,
              operatorId: operatorId,
              circleCode: circleCode,
            ),
          );
        }

      case mobileData:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => MobileDataPage(args as Operator));
        }
      case mobile:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => MobilePage(args as Operator));
        }
      case data:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => DataPage(args as Operator));
        }
      case cableTv:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => CableTvPage(args as Operator));
        }
      case electricity:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => ElectricityPage(args as Operator));
        }
      case topUpCheckOut:
        {
          var data = args as Map<String, dynamic>;
          String mobile = data["mobile"].toString();
          String mobileCountryId = data["mobileCountryId"].toString();
          String mobileCountryCode = data["mobileCountryCode"].toString();
          String operatorIcon = data["operatorIcon"].toString();
          CurrencyData currency = data["currency"] as CurrencyData;
          ParamOperatorModel operator = data["operator"] as ParamOperatorModel;
          UserPlanModel plan = data["plan"] as UserPlanModel;
          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => TopUpCheckOutPage(
              mobile: mobile,
              mobileCountryId: mobileCountryId,
              mobileCountryCode: mobileCountryCode,
              currency: currency,
              operator: operator,
              operatorIcon: operatorIcon,
              plan: plan,
            ),
          );
        }
      case rechargeStatus:
        {
          var data = args as Map<String, dynamic>;
          String receiptNo = data["receiptNo"].toString();
          TopUpDenomination status = data["status"] as TopUpDenomination;
          ParamOperatorModel operator = data["operator"] as ParamOperatorModel;
          CurrencyData currency = data["currency"] as CurrencyData;
          String subscriberTitle = data["subscriber_title"] ?? "Number";

          /*---------  FOR  BILL EKEDC OPERATOR ----------*/
          OperatorValidateData? operatorInfo =
              data["operator_info"] as OperatorValidateData?;

          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => RechargeStatusPage(
              data: status,
              operator: operator,
              currency: currency,
              receiptNo: receiptNo,
              subscriberTitle: subscriberTitle,
              operatorInfo: operatorInfo,
            ),
          );
        }

      case reprintPage:
        {
          var data = args as Map<String, dynamic>;
          ReprintData status = data["status"] as ReprintData;
          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => RechargeReprintPage(
              data: status,
            ),
          );
        }

      case settings:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => SettingsPage());
      case helpAndSupport:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => HelpAndSupportPage());

      case fundTransfer:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => FundTransferPage());
      case downLine:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => DownLinePage());
      case downLineUsersList:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => MyDownLineUsersPage());

      case addMyBankAccount:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => MyBankAccountPage());

      case addBeneficiary:
        {
          var data = args as Map;
          int type = data["type"] as int;
          MyBankAccount? account = data["account"] as MyBankAccount?;
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => AddBeneficiaryPage(type, account));
        }
      case fundRequestReport:
        {
          var data = args as Map;
          String isCredit = data["isCredit"] as String;
          String paymentType = data["paymentType"] as String;

          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => FundRequestReportPage(isCredit, paymentType));
        }
      case transferMoney:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => TransferMoneyPage(args as MyBankAccount));

      case transferBankCardPage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => TransferBankCardPage());
      case changePassword:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ChangePasswordPage());
      case setPin:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => SetPinPage());
      case redeemVoucher:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => RedeemVoucher());
      case notificationPage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => NotificationPage());
      case aboutUs:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => AboutUsPage());
      case transactions:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => TransactionsPage());
      case customRange:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => CustomRangePage());
      case myTransaction:
        {
          var data = args as Map<String, dynamic>;
          DateTime fromDateTime = data["from_date_time"] as DateTime;
          DateTime toDateTime = data["to_date_time"] as DateTime;
          String type = data["type"] as String;
          String number = data["number"] as String;
          String txnId = data["transaction_id"] as String;
          return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => MyTransactionPage(
              fromDateTime: fromDateTime,
              toDateTime: toDateTime,
              type: type,
              number: number,
              txnID: txnId,
            ),
          );
        }
      case salesReport:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => SalesReportPage());
        }

      case voucherReprintShare:
        {
          var data = args as Map;
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => VoucherReprintSharePage(
                data['voucher'] as List<VoucherReprintData>,
              ));
        }
      case voucherReprintPage:
        var data = args as Map<String, dynamic>;
        String orderNumbers = data["orderNumber"] as String;
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => VoucherReprintPage(orderNumber: orderNumbers,));
      case salesFilter:
        {
          var data = args as Map<String, dynamic>;
          List<UserItem> users = data["users"] as List<UserItem>;
          UserItem selectedUser = data["selectedUser"] as UserItem;
          bool? filter_from = data["filter_from"] as bool;

          Service? selectedService = data["selectedService"] as Service?;
          Operator? selectedOperator = data["selectedOperator"] as Operator?;

          DateTime? fromDateTime = data["from_date_time"] as DateTime?;
          DateTime? toDateTime = data["to_date_time"] as DateTime?;

          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => SalesFilterPage(
                    users: users,
                    selectedUser: selectedUser,
                    selectedService: selectedService,
                    selectedOperator: selectedOperator,
                    toDate: toDateTime,
                    fromDate: fromDateTime,
                    filter_from: filter_from,
                  ));
        }
      case walletRequestFilter:
        {
          var data = args as Map<String, dynamic>;
          DateTime? fromDateTime = data["from_date_time"] as DateTime?;
          DateTime? toDateTime = data["to_date_time"] as DateTime?;
          String? status = data["status"] as String;
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => WalletRequestPage(
                    toDate: toDateTime,
                    fromDate: fromDateTime,
                    status_type: status,
                  ));
        }

      case commissionReport:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => CommissionReportPage());

      case addUserPurchaseOrder:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => AddUserPurchaseOrderPage());
      case voucherPurchaseOrderPage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => VoucherPurchaseOrderPage());
      case myOrderReport:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => MyOrderReportPage());
      case voucherLocalPinsStockPage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) =>PinsLocalStockPage());
      case preFundDeposit:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => PreFundDepositPage());
      case profile:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ProfilePage());

      case kyc:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => KYCPage());
      case walletTopUp:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => RequestMoneyPage());
        }
      case scanPay:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => SendMoneyPage());
        }
      case payNow:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => PayNowPage(users: args as UserData));
      case enterPin:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => EnterPinPage());
      case addBank:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => AddBankPage());
      case wallet:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => WalletPage());
      default:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => PageNotFound());
    }
  }

/*
  Map<String, WidgetBuilder> routes() {
    return {
      login: (context) => LoginPage(),
      signUp: (context) => RegisterPage(),
      */
/*verification: (context) => VerificationPage(() {
            Navigator.popAndPushNamed(context, PageRoutes.sync);
          }),*/ /*

      forgotPassword: (context) => ForgotPasswordPage(),
      sync: (context) => ConfigurationSetupPage(),
      languagePage: (context) => ChangeLanguagePage(),
      signInNavigator: (context) => SignInNavigator(),
      bottomNavigation: (context) => BottomNavigation(),
      giftCardSearch: (context) => GiftCardSearchPage(),
      giftCardProcess: (context) => GiftCardProcessPage(),
      giftCardCheckOut: (context) => GiftCardCheckOutPage(),
      topUpOperator: (context) => TopUpOperatorPage(),
      topUpBrowsePlans: (context) => TopUpBrowsePlansPage(),
      topUpProcess: (context) => TopUpProcessPage(),
      topUpCheckOut: (context) => TopUpCheckOutPage(),
      settings: (context) => SettingsPage(),
      changePassword: (context) => ChangePasswordPage(),
      setPin: (context) => SetPinPage(),
      aboutUs: (context) => AboutUsPage(),
      transactions: (context) => TransactionsPage(),
      customRange: (context) => CustomRangePage(),
      myTransaction: (context) => MyTransactionPage(),
      salesReport: (context) => SalesReportPage(),
      salesFilter: (context) => SalesFilterPage(),
      commissionReport: (context) => CommissionReportPage(),
      preFundDeposit: (context) => PreFundDepositPage(),
      profile: (context) => ProfilePage(),
      scanPay: (context) => ScanPayPage(),
      payNow: (context) => PayNowPage(),
      enterPin: (context) => EnterPinPage(),
      addBank: (context) => AddBankPage(),
      wallet: (context) => WalletPage(),
    };
  }
*/
}
