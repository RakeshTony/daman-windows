import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/balance.dart';
import 'package:daman/Database/models/default_config.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/app_helper.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/preferences_handler.dart';
import 'package:daman/Ux/BottomNavigation/Home/home_page.dart';
import 'package:daman/Ux/BottomNavigation/ViewModel/view_model_bottom_navigation.dart';
import 'package:daman/Ux/Collection/remita_form_field.dart';
import 'package:daman/main.dart';

import '../../Locale/locales.dart';
import '../../Utils/app_decorations.dart';
import '../Dialog/dialog_change_language.dart';

class BottomNavigation extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage = Container();
  var page = BottomMenuItem.HOME;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState
    extends BasePageState<BottomNavigation, ViewModelBottomNavigation> {
  var configs = HiveBoxes.getDefaultConfig();

  DefaultConfig? getConfig() {
    return configs.values.isNotEmpty ? configs.values.first : null;
  }

  @override
  void initState() {
    _selectTab(widget.page);
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
    /*
    databaseReference
        .child(FirebaseNode.DEFAULT_CONFIG)
        .onValue
        .listen((event) async {
      if (event.snapshot.value is Map) {
        var configs = HiveBoxes.getDefaultConfig();
        if (configs.isNotEmpty) await configs.clear();
        DefaultConfigModel model =
            DefaultConfigModel.fromJson(toMaps(event.snapshot.value));
        configs.add(model.toDefaultConfig);

        var pages = HiveBoxes.getAppPages();
        if (pages.isNotEmpty) await pages.clear();
        pages.addAll(model.appPages.map((e) => e.toAppPages).toList());
      }
    });
*/
  }

  @override
  void didUpdateWidget(covariant BottomNavigation oldWidget) {
    _selectTab(oldWidget.page);
    super.didUpdateWidget(oldWidget);
  }

  _selectTab(BottomMenuItem page) {
    setState(() {
      widget.page = page;
      switch (widget.page) {
        case BottomMenuItem.HOME:
          widget.currentPage = HomePage(widget.scaffoldKey);
          break;
        case BottomMenuItem.REPORTS:
          widget.currentPage = Container();
          break;
        case BottomMenuItem.SCAN:
          widget.currentPage = Container();
          break;
        case BottomMenuItem.HISTORY:
          widget.currentPage = Container();
          break;
        case BottomMenuItem.LOGOUT:
          widget.currentPage = Container();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Container(
        decoration: decorationBackground,
        child: Scaffold(
          key: widget.scaffoldKey,
          backgroundColor: kTransparentColor,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFF531bcd),
                    const Color(0xFF8d0ec9),
                    const Color(0xFF8911c9),
                    const Color(0xFF0094f1),
                    const Color(0xFF00eaff),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [
                    0.1,
                    0.3,
                    0.2,
                    0.6,
                    0.9,
                  ],
                  tileMode: TileMode.clamp),
            ),
            child: BottomAppBar(
              color: kTransparentColor,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getMenuButton(
                    IC_HOME_ACTIVE,
                    IC_HOME_ACTIVE,
                    "Home",
                    widget.page == 0.page,
                    false,
                    onTap: () {
                      _selectTab(widget.page);
                    },
                  ),
                  _getMenuButton(
                    IC_MENU_REPORTS,
                    IC_MENU_REPORTS,
                    "Report",
                    widget.page == 1.page,
                    false,
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.transactions);
                    },
                  ),
                  _getMenuIcon(
                    IC_MENU_SCAN,
                    IC_MENU_SCAN,
                    widget.page == 2.page,
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.scanPay);
                    },
                  ),
                  _getMenuButton(
                    IC_TXN,
                    IC_TXN,
                    "Wallet",
                    widget.page == 3.page,
                    false,
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.wallet);
                    },
                  ),
                  _getMenuButton(
                    IC_LOGOUT_WHITE,
                    IC_LOGOUT_WHITE,
                    "Redeem",
                    widget.page == 4.page,
                    false,
                    onTap: () {
                      // Navigator.pushNamed(context, PageRoutes.redeemVoucher);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context)!.loggingOut!),
                              content: Text(
                                  AppLocalizations.of(context)!.areYouSure!),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actions: <Widget>[
                                Container(
                                  child: MaterialButton(
                                    child:
                                        Text(AppLocalizations.of(context)!.no!),
                                    textColor: kMainColor,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kMainColor)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                Container(
                                  child: MaterialButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.yes!),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kMainColor)),
                                    textColor: kMainColor,
                                    onPressed: () {
                                      viewModel.requestUpdatePinSoldStatus();
                                      // viewModel.requestLogout();
                                    },
                                  ),
                                )
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: widget.currentPage,
          ),
          drawer: Drawer(
            backgroundColor: kWhiteColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: Image.asset(
                                    ARROW_BACK_BLACK,
                                    width: 24,
                                    height: 24,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.popAndPushNamed(
                                          context, PageRoutes.profile);
                                    },
                                    child: ValueListenableBuilder(
                                      valueListenable: mPreference,
                                      builder: (context,
                                              PreferencesHandler data, _) =>
                                          Row(
                                        children: [
                                          AppImage(
                                            data.userData.icon,
                                            32,
                                            defaultImage: DEFAULT_PERSON,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    data.userData.name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          RFontWeight.REGULAR,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    data.userData.email,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          RFontWeight.LIGHT,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.edit,
                                            color: kMainColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                      context, PageRoutes.wallet);
                                },
                                child: new Container(
                                  decoration: BoxDecoration(
                                    color: kMainButtonColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ValueListenableBuilder(
                                                valueListenable:
                                                    HiveBoxes.getBalance()
                                                        .listenable(),
                                                builder: (context,
                                                    Box<Balance> data, _) {
                                                  var mWallet =
                                                      data.values.isNotEmpty
                                                          ? data.values.first
                                                          : null;
                                                  return Flexible(
                                                    child: Text(
                                                      "${mWallet?.currencySign ?? ""} ${(mWallet?.balance ?? 0.0).toSeparatorFormat()}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              RFontWeight
                                                                  .REGULAR,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              RFontFamily
                                                                  .POPPINS),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Flexible(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .walletBalance!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          RFontWeight.LIGHT,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          RFontFamily.POPPINS),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          IC_WALLET_WHITE,
                                          scale: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.wallet!),
                        leading: Image.asset(
                          IC_SCAN_DRAWER,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.walletTopUp);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: kTextInputInactive,
                        ),
                      ),
                      Visibility(
                          visible: mPreference.value.userData.posStatus,
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                  AppLocalizations.of(context)!.myOrderReport!),
                              leading: Image.asset(
                                IC_ADD_ORDER,
                                width: 24,
                                height: 24,
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.myOrderReport);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,
                                color: kTextInputInactive,
                              ),
                            ),
                          ])),
                      Visibility(
                          visible: mPreference.value.userData.posStatus,
                          child: Column(children: [
                            ListTile(
                              title: Text(AppLocalizations.of(context)!
                                  .addPurchaseOrder!),
                              leading: Image.asset(
                                IC_ADD_ORDER,
                                width: 24,
                                height: 24,
                              ),
                              onTap: () {
                                // Navigator.pushNamed(context, PageRoutes.addUserPurchaseOrder);
                                Navigator.pushNamed(context,
                                    PageRoutes.voucherPurchaseOrderPage);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,
                                color: kTextInputInactive,
                              ),
                            ),
                          ])),
                      Visibility(
                          visible: mPreference.value.userData.posStatus,
                          child: Column(children: [
                            ListTile(
                              title: Text(AppLocalizations.of(context)!
                                  .localPinsStock!),
                              leading: Image.asset(
                                IC_ADD_ORDER,
                                width: 24,
                                height: 24,
                              ),
                              onTap: () {
                                // Navigator.pushNamed(context, PageRoutes.addUserPurchaseOrder);
                                Navigator.pushNamed(context,
                                    PageRoutes.voucherLocalPinsStockPage);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,
                                color: kTextInputInactive,
                              ),
                            ),
                          ])),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.reports!),
                        leading: Image.asset(
                          IC_REPORTS,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.transactions);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: kTextInputInactive,
                        ),
                      ),
                      ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.synchronizeData!),
                        leading: Image.asset(
                          IC_SYNC,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, PageRoutes.sync);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: kTextInputInactive,
                        ),
                      ),
                      Visibility(
                        visible: !mPreference.value.userData.lastLevel,
                        child: ListTile(
                          title:
                              Text(AppLocalizations.of(context)!.myDownline!),
                          leading: Image.asset(
                            IC_USER,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageRoutes.downLineUsersList);
                          },
                        ),
                      ),
                      Visibility(
                        visible: !mPreference.value.userData.lastLevel,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 20,
                            endIndent: 0,
                            color: kTextInputInactive,
                          ),
                        ),
                      ),
                      ListTile(
                        title:
                            Text(AppLocalizations.of(context)!.changeLanguage!),
                        leading: Image.asset(
                          IC_CHANGE_LANGUAGE_MENU,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          var dialog = DialogChangeLanguage();
                          showDialog(
                              context: context, builder: (context) => dialog);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: kTextInputInactive,
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.setting!),
                        leading: Image.asset(
                          IC_SETTING,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.settings);
                        },
                      ),
                      /*Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: kTextInputInactive,
                      ),
                    ),
                    ListTile(
                      title: const Text('Help & Support'),
                      leading: Image.asset(
                        IC_HELP_SUPPORT,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutes.helpAndSupport);
                      },
                    ),*/
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: kTextInputInactive,
                        ),
                      ),

                      /* ListTile(
                      title: const Text('Refer & Earn'),
                      leading: Image.asset(
                        IC_REFER_EARN,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        //Navigator.pushNamed(context, PageRoutes.settings);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Coming Soon..."),
                        ));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: kTextInputInactive,
                      ),
                    ),
                    ListTile(
                      title: const Text('Terms & Conditions'),
                      leading: Image.asset(
                        IC_TERMS_CONDI,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        var config = getConfig();
                        if ((config?.tcUrl ?? "").isNotEmpty) {
                          AppAction.openWebPage(context, "Terms & Condition",
                              config?.tcUrl ?? "");
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: kTextInputInactive,
                      ),
                    ),
                    ListTile(
                      title: const Text('About Us'),
                      leading: Image.asset(
                        IC_ABOUT_MENU,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutes.aboutUs);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: kTextInputInactive,
                      ),
                    ),

                    ListTile(
                      title: const Text('Rate Us'),
                      leading: Image.asset(
                        IC_RATE_US,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        AppAction.rateUs();
                      },
                    ),
                     */
                      Visibility(
                        visible: false,
                        child: ListTile(
                          title: const Text('Remita Form Fields'),
                          leading: Image.asset(
                            IC_RATE_US,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RemitaFormField()));
                          },
                        ),
                      ),
                      /* Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: kTextInputInactive,
                      ),
                    ),*/
                      /* ListTile(
                        title: Text(AppLocalizations.of(context)!.loggingOut!),
                        leading: Image.asset(
                          IC_LOGOUT,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Logging out"),
                                  content: Text("Are you sure?"),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: <Widget>[
                                    Container(
                                      child: MaterialButton(
                                        child: Text("No"),
                                        textColor: kMainColor,
                                        shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: kMainColor)),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    Container(
                                      child: MaterialButton(
                                        child: Text("Yes"),
                                        shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: kMainColor)),
                                        textColor: kMainColor,
                                        onPressed: () {
                                          viewModel.requestLogout();
                                        },
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                      ),*/
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  decoration: BoxDecoration(color: kWhiteColor),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.version! +
                          " (${AppSettings.APP_VERSION})",
                      style: TextStyle(
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14,
                        color: kMainTextColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMenuButton(
      String icon, String iconActive, String label, bool isActive, bool isTitle,
      {GestureTapCallback? onTap}) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: kTransparentColor, // button color
          child: InkWell(
            splashColor: kMainColor, // splash color
            onTap: onTap, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  isActive ? iconActive : icon,
                  width: 24,
                  height: 24,
                ), // icon
                SizedBox(
                  height: 2,
                ),
                Visibility(
                  visible: isTitle,
                  child: Text(
                    label,
                    style: TextStyle(
                        fontFamily: RFontFamily.POPPINS,
                        color: isActive ? kMainButtonColor : kWhiteColor,
                        fontSize: 12),
                  ),
                ), // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMenuIcon(String icon, String iconActive, bool isActive,
      {GestureTapCallback? onTap}) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height

      child: ClipOval(
        child: Material(
          color: kTransparentColor, // button color
          child: InkWell(
            splashColor: kMainColor, // splash color
            onTap: onTap, // button pressed
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    isActive ? iconActive : icon,
                    width: 48,
                    height: 48,
                  ), // icon
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
