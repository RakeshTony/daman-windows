import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Database/models/balance.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/preferences_handler.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/my_order_report_page.dart';
import 'package:daman/Ux/BottomNavigation/ViewModel/view_model_bottom_navigation.dart';
import 'package:daman/Ux/Dialog/windows/dialog_fund_request.dart';
import 'package:daman/Ux/Dialog/windows/dialog_logout.dart';
import 'package:daman/Ux/Dialog/windows/dialog_my_transaction.dart';
import 'package:daman/Ux/Dialog/windows/dialog_profile.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports.dart';
import 'package:daman/Ux/Dialog/windows/dialog_wallet.dart';
import 'package:flutter/material.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/main.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Ux/AddUserPurchaseOrder/pins_local_stock.dart';
import '../../Ux/AddUserPurchaseOrder/voucher_purchase_order_page.dart';
import '../../Ux/BottomNavigation/Setting/settings_page.dart';
import '../../Ux/DownLine/my_down_line_users_page.dart';
import '../../Ux/Payment/Request/request_money_page.dart';

class AppBarDashboardWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final GlobalKey<ScaffoldState> parentScaffoldState;
  final PreferredSizeWidget? bottom;
  final double elevation;

  AppBarDashboardWidget(
    this.parentScaffoldState, {
    Key? key,
    this.onTap,
    this.elevation = 3,
    this.bottom,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State createState() => AppBarDashboardWidgetState();
}

class AppBarDashboardWidgetState
    extends BasePageState<AppBarDashboardWidget, ViewModelBottomNavigation> {
  var wallet = HiveBoxes.getBalanceWallet();

  @override
  void initState() {
    super.initState();
    viewModel.localSyncStream.listen((event) {
      viewModel.requestLogout();
    });
    viewModel.responseStream.listen((event) {
      if (event.getStatus) {
        mPreference.value.clear();
        Phoenix.rebirth(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      SizedBox(
        height: widget.preferredSize.height,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            color: kMainColor,
            child: Container(
              height: widget.preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _getUser(),
                  ),
                  _getAppLogo(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _getWallet(),
                        SizedBox(
                          width: 10,
                        ),
                        //_getNotificationIcon(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];
    if (widget.bottom != null) {
      items.add(widget.bottom!);
    }
    return Material(
      elevation: widget.elevation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items,
      ),
    );
  }

  Widget _getAppLogo() {
    return Image.asset(
      LOGO,
      height: 36,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getWallet() {
    return InkWell(
      onTap: () {
        var dialog = DialogWallet();
        showDialog(
          context: context,
          builder: (context) => dialog,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            IC_WIN_WALLET,
            width: 32,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: HiveBoxes.getBalance().listenable(),
                builder: (context, Box<Balance> data, _) {
                  var mWallet =
                      data.values.isNotEmpty ? data.values.first : null;
                  return Flexible(
                    child: Text(
                      "${mWallet?.currencySign ?? ""} ${(mWallet?.balance ?? 0.0).toSeparatorFormat()}",
                      style: TextStyle(
                          color: kColor_1,
                          fontWeight: RFontWeight.BOLD,
                          fontSize: 16,
                          fontFamily: RFontFamily.POPPINS),
                    ),
                  );
                },
              ),
              Flexible(
                child: Text(
                  "Your Balance",
                  style: TextStyle(
                    color: kColor_1,
                    fontWeight: RFontWeight.BOLD,
                    fontSize: 12,
                    fontFamily: RFontFamily.POPPINS,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getUser() {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: mPreference,
          builder: (context, PreferencesHandler data, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton(
                color: kColor_1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  side: BorderSide(width: 1, color: kBorderColorActive),
                ),
                itemBuilder: (_) {
                  var list = List<PopupMenuItem>.empty(growable: true);
                  list.add(_buildPopupMenuUser(data));
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_6,
                      AppLocalizations.of(context)!.myDownline!, 6));
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_1,
                      AppLocalizations.of(context)!.myTransactions!, 1));
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_2,
                      AppLocalizations.of(context)!.sendMoney!, 2));
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_7,
                      AppLocalizations.of(context)!.fundRequest!, 7));
                  /*if (mPreference.value.userData.posStatus) {
                    list.add(_buildPopupMenuItem(IC_WIN_MENU_7,
                        AppLocalizations.of(context)!.addPurchaseOrder!, 9));
                    list.add(_buildPopupMenuItem(IC_WIN_MENU_7,
                        AppLocalizations.of(context)!.localPinsStock!, 10));
                    list.add(_buildPopupMenuItem(IC_WIN_MENU_7,
                        AppLocalizations.of(context)!.myOrderReport!, 11));
                  }*/
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_3,
                      AppLocalizations.of(context)!.reports!, 3));
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_4,
                      AppLocalizations.of(context)!.synchronizeData!, 4));
                  list.add(_buildPopupMenuItem(IC_SETTING_WHITE,
                      AppLocalizations.of(context)!.setting!, 8));
                  list.add(_buildPopupMenuItem(IC_WIN_MENU_5,
                      AppLocalizations.of(context)!.loggingOut!, 5));
                  return list;
                },
                child: AppImage(
                  data.userData.icon,
                  40,
                  defaultImage: DEFAULT_PERSON,
                ),
                offset: Offset(00, 48),
                onSelected: (index) async {
                  if (index == 0) {
                    var dialog = DialogProfile();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 1) {
                    var dialog = DialogMyTransactions();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 2) {
                    var dialog = DialogFundRequest();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 3) {
                    var dialog = DialogReports();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 4) {
                    Navigator.popAndPushNamed(context, PageRoutes.sync);
                  } else if (index == 5) {
                    var dialog = DialogLogout(() {
                      viewModel.requestUpdatePinSoldStatus();
                    });
                    showDialog(context: context, builder: (context) => dialog);
                  } else if (index == 6) {
                    var dialog = MyDownLineUsersPage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 7) {
                    var dialog = RequestMoneyPage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 8) {
                    var dialog = SettingsPage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 9) {
                    var dialog = VoucherPurchaseOrderPage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                    viewModel.requestBalanceEnquiry();
                  } else if (index == 10) {
                    var dialog = PinsLocalStockPage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  } else if (index == 11) {
                    var dialog = MyOrderReportPage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );

                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      data.userData.name,
                      style: TextStyle(
                        color:kColor_1,
                        fontWeight: RFontWeight.BOLD,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      data.userData.email,
                      style: TextStyle(
                        color: kColor_1,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getNotificationIcon() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PageRoutes.notificationPage);
      },
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: BUTTON_GRADIENT,
        ),
        child: Image.asset(IC_WIN_NOTIFICATION),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuUser(PreferencesHandler data) {
    return PopupMenuItem(
      value: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AppImage(
                data.userData.icon,
                40,
                defaultImage: DEFAULT_PERSON,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      data.userData.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      data.userData.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: RFontWeight.LIGHT,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildPopupDivider()
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String icon, String title, int index) {
    return PopupMenuItem(
      value: index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(icon, width: 24, height: 24, fit: BoxFit.fill),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(color: kWhiteColor, fontSize: 12),
              )
            ],
          ),
          _buildPopupDivider()
        ],
      ),
    );
  }

  _buildPopupDivider() {
    return Container(
      margin: EdgeInsets.all(10),
      color: kWhiteColor.withOpacity(.5),
      height: .2,
    );
  }
}
