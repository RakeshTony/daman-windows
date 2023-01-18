import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Utils/app_encoder.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/AppMediaDataModel.dart';
import 'package:daman/DataBeans/BalanceDataModel.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/app_media.dart';
import 'package:daman/Database/models/balance.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Database/models/services_child.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_dashboard_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/firebase_node.dart';
import 'package:daman/Ux/Wallet/ViewModel/view_model_wallet.dart';

import 'package:daman/main.dart';

import '../../../DataBeans/PinsStatusUpdateDataModel.dart';
import '../../../DataBeans/ServicesDataModel.dart';
import '../../../Database/models/offline_pin_stock.dart';
import '../../../Database/models/operator.dart';
import '../../../Utils/app_decorations.dart';
import '../../Dialog/dialog_success.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onTap;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomePage(this.parentScaffoldKey, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeBody(parentScaffoldKey, key: key, onTap: onTap);
  }
}

class HomeBody extends StatefulWidget {
  final VoidCallback? onTap;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeBody(this.parentScaffoldKey, {Key? key, this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeBodyState();
}

class _HomeBodyState extends BasePageState<HomeBody, ViewModelWallet> {
  var _wallet = HiveBoxes.getBalanceWallet();
  var _appMedia = HiveBoxes.getAppMedia();
  var _appServices = HiveBoxes.getServicesChild();
  Widget currentPage = Container();
  List<ServiceChild> serviceChild = [];

  List<AppMedia> getAppBanners() {
    return _appMedia.values
        .where((element) => element.imageFor == "Banner")
        .toList();
  }

  @override
  void initState() {
    super.initState();
    viewModel.requestUpdatePinSoldStatus();
    serviceChild = _appServices.values
        .where((element) =>
    element.parentId.isEmpty ||
        element.parentId.equalsIgnoreCase("null") ||
        element.parentId.equalsIgnoreCase("0"))
        .toList();
/*
    databaseReference
        .child(FirebaseNode.USERS)
        .child(mPreference.value.userData.firebaseId)
        .child(FirebaseNode.WALLET)
        .onValue
        .listen((data) {
      if (data.snapshot.value is Map) {
        var walletData = BalanceData.fromJson(toMaps(data.snapshot.value));
        final box = HiveBoxes.getBalance();
        box.put("BAL", walletData.toBalance);
        // AppLog.e("USERS HOME", data.snapshot.value ?? "");
      }
    });
    */
/*User Profile data Sync*//*

    databaseReference
        .child(FirebaseNode.USERS)
        .child(mPreference.value.userData.firebaseId)
        .onValue
        .listen((data) {
      if (data.snapshot.value is Map) {
        var mUserData = mPreference.value.userData;
        // AppLog.e("USER-OLD", mUserData.toJson());
        if (data.snapshot.value is Map) {
          var mUser = data.snapshot.value as Map;
          // AppLog.e("USER-NEW DATA", data.snapshot.value ?? "");
          var mUserDataNew = mUserData.toUpdate(toMaps(data.snapshot.value));
          // AppLog.e("USER-NEW", mUserDataNew.toJson());
          mPreference.value.userData = mUserDataNew;
        }
        // AppLog.e("USERS HOME", data.snapshot.value ?? "");
      }
    });

    databaseReference
        .child(FirebaseNode.MEDIA_LIST)
        .onValue
        .listen((data) async {
      // AppLog.e("MEDIA HOME", data.snapshot.value ?? "");
      if (data.snapshot.value is List) {
        var mAppMedia = toList(data.snapshot.value)
            .map((e) => AppMediaModel.fromJson(e))
            .toList();
        var medias = mAppMedia.map((element) {
          return element.toAppMedia;
        }).toList();
        final box = HiveBoxes.getAppMedia();
        await box.clear();
        box.addAll(medias);
      }
    });
    databaseReference.child(FirebaseNode.SERVICES).onValue.listen((data) async {
      if (data.snapshot.value is List) {
        final box = HiveBoxes.getServicesChild();
        await box.clear();
        var mService = toList(data.snapshot.value)
            .map((e) => ServiceChildModel.fromJson(e))
            .toList();
        var countries = recursionListData(mService).map((element) {
          return element.toServiceChild;
        }).toList();
        box.addAll(countries);
        serviceChild = countries;
        print("childServiceID: " + serviceChild.first.id);
      }
    });
    databaseReference
        .child(FirebaseNode.SERVICE_OPERATOR_DENOMINATION)
        .child(mPreference.value.userData.firebasePlanId)
        .onValue
        .listen((data) async {
      // AppLog.e("SERVICE OP DE HOME", data.snapshot.value ?? "");
      if (data.snapshot.value is List) {
        var mServiceOperator = toList(data.snapshot.value)
            .map((e) => ServiceOperatorModel.fromJson(e))
            .toList();
        var mServices = mServiceOperator.map((e) => e.service).toList();
        List<OperatorData> mOperators = [];
        mServiceOperator.forEach((element) {
          mOperators.addAll(element.operator);
        });
        List<DenominationData> mDenominations = [];
        mServiceOperator.forEach((element) {
          element.operator.forEach((element) {
            mDenominations.addAll(element.denominations);
          });
        });
        var services = mServices.map((element) {
          return element.toService;
        }).toList();
        final boxService = HiveBoxes.getServices();
        await boxService.clear();
        boxService.addAll(services);

        var operators = mOperators.map((element) {
          return element.toOperator;
        }).toList();
        final boxOperator = HiveBoxes.getOperators();
        await boxOperator.clear();
        boxOperator.addAll(operators);

        var denominations = mDenominations.map((element) {
          return element.toDenomination;
        }).toList();
        final boxDenomination = HiveBoxes.getDenomination();
        await boxDenomination.clear();
        boxDenomination.addAll(denominations);
        // AppLog.e("SERVICE", services);
      }
    });
*/
  }

  List<ServiceChildData> recursionListData(List<ServiceChildModel> data) {
    List<ServiceChildData> services = [];
    data.forEach((element) {
      services.add(element.service);
      services.addAll(recursionListData(element.children));
    });
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorationBackground,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarDashboardWidget(
          widget.parentScaffoldKey,
          elevation: 0,
        ),
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Stack(
                  children: [
                    Container(
                      color: kWalletBackground,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            IC_WALLET_WHITE,
                            width: 24,
                            fit: BoxFit.fitWidth,
                          ),
                          ValueListenableBuilder(
                              valueListenable:
                                  HiveBoxes.getBalance().listenable(),
                              builder: (context, Box<Balance> data, _) {
                                var mWallet = data.values.isNotEmpty
                                    ? data.values.first
                                    : null;
                                return Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                              .walletBalance! +
                                          " : ${mWallet?.currencySign ?? ""} ${(mWallet?.balance ?? 0.0).toSeparatorFormat()}",
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontFamily: RFontFamily.POPPINS,
                                        fontSize: 12,
                                        fontWeight: RFontWeight.LIGHT,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          CustomButton(
                            text: AppLocalizations.of(context)!.addMoney!,
                            radius: BorderRadius.all(Radius.circular(16)),
                            padding: 0,
                            style: TextStyle(
                                fontSize: 12,
                                color: kWhiteColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.LIGHT),
                            margin: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, PageRoutes.walletTopUp);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              /*appBanners.isNotEmpty
                      ? CarouselSlider(
                          options: CarouselOptions(
                            height: 130,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.9,
                          ),
                          items: appBanners.map((media) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 6),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: CachedNetworkImage(
                                      imageUrl: media.image,
                                      width: mediaQuery.size.width,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        ),*/
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    serviceChild.length > 1
                        ? AppLocalizations.of(context)!.chooseService!
                        : AppLocalizations.of(context)!.chooseOperator!,
                    style: TextStyle(
                      color: kWhiteColor,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 16,
                      fontFamily: RFontFamily.POPPINS,
                    ),
                  ),
                ),
              ),
              serviceChild.length > 1
                  ? Expanded(
                      child: ValueListenableBuilder(
                          valueListenable:
                              HiveBoxes.getServicesChild().listenable(),
                          builder: (context, Box<ServiceChild> data, _) {
                            var mService = data.values
                                .where((element) =>
                                    element.parentId.isEmpty ||
                                    element.parentId.equalsIgnoreCase("null") ||
                                    element.parentId.equalsIgnoreCase("0"))
                                .toList();
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: GridView.builder(
                                itemCount: mService.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1 / 1.5,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16),
                                itemBuilder: (context, index) =>
                                    _itemServices(mService[index]),
                              ),
                            );
                          }))
                  : Expanded(
                      child: ValueListenableBuilder(
                          valueListenable:
                              HiveBoxes.getOperators().listenable(),
                          builder: (context, Box<Operator> data, _) {
                            var mOperator = data.values
                                .where(
                                  (e) =>
                                      e.serviceId ==
                                      (serviceChild.length > 0
                                          ? serviceChild.first.id
                                          : "0"),
                                )
                                .toList(growable: true);
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: GridView.builder(
                                itemCount: mOperator.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1 / 1,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (context, index) =>
                                    _itemOperators(mOperator[index]),
                              ),
                            );
                          })),

              /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Recent Transaction",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14,
                        fontFamily: RFontFamily.POPPINS,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable:
                          HiveBoxes.getRecentTransactions().listenable(),
                      builder: (context, Box<RecentTransaction> data, _) {
                        List<RecentTransaction> items =
                            data.values.take(5).toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) =>
                              _itemTransaction(items[index]),
                        );
                      }),*/
            ],
          ),
        ),
      ),
    );
  }

  _itemServices(ServiceChild service) {
    return InkWell(
      onTap: () {
        switch (service.type.toUpperCase()) {
          case 'COLLECTION':
            {
              Navigator.pushNamed(context, PageRoutes.services,
                  arguments: service);
              break;
            }
          case 'FUND':
            {
              Navigator.pushNamed(context, PageRoutes.addMyBankAccount);
              // Navigator.pushNamed(context, PageRoutes.fundTransfer);
              break;
            }
          default:
            {
              AppLog.e("SERVICE TYPE", service.type);
              Navigator.pushNamed(context, PageRoutes.operator,
                  arguments: service);
            }
        }
      },
      splashColor: kMainColor,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhiteColor,
                border: Border.all(
                  width: 1,
                  color: kWhiteColor,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: CachedNetworkImage(
                imageUrl: service.icon,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(DEFAULT_OPERATOR),
                ),
                errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(DEFAULT_OPERATOR),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    service.title,
                    style: TextStyle(fontSize: 16, color: kWhiteColor),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /*Operator Widget*/
  _itemOperators(Operator operator) {
    //AppLog.e("operatorImage:- ", operator.logo);
    return InkWell(
      splashColor: kMainColor,
      onTap: () {
        /*switch (service.type.toUpperCase()) {
          case 'VOUCHER':
            {*/
        Navigator.pushNamed(context, PageRoutes.voucherSearch,
            arguments: operator);

        /*}
          case 'TOPUP':
            {
              Navigator.pushNamed(context, PageRoutes.mobileData,
                  arguments: operator);
              break;
            }
          case 'INTERNET':
            {
              Navigator.pushNamed(context, PageRoutes.mobileData,
                  arguments: operator);
              break;
            }
          case 'CABLETV':
            {
              Navigator.pushNamed(context, PageRoutes.cableTv,
                  arguments: operator);
              break;
            }
          case 'ELECTRICITY':
            {
              Navigator.pushNamed(context, PageRoutes.electricity,
                  arguments: operator);
              break;
            }
        }*/
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhiteColor,
                border: Border.all(
                  width: 1,
                  color: kWhiteColor,
                  style: BorderStyle.solid,
                ),
              ),
              height: 120,
              child: CachedNetworkImage(
                imageUrl: operator.logo,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(DEFAULT_OPERATOR),
                ),
                errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(DEFAULT_OPERATOR),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    operator.name,
                    style: TextStyle(fontSize: 16, color: kWhiteColor),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemTransaction(RecentTransaction data) {
    var isCrDr = data.type.equalsIgnoreCases(["transfer", "received"]);
    var url = isCrDr ? data.consider : data.operatorLogo;
    var isCredit = data.consider.equalsIgnoreCase("cr");
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PageRoutes.customRange);
      },
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    data.narration,
                    //textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: kMainTextColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: isCredit ? kTextAmountCR : kTextAmountDR,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${isCredit ? '+' : '-'} ${_wallet?.currencySign ?? ''}${data.amount.toSeparatorFormat()}",
                      style: TextStyle(
                          color: kWhiteColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.MEDIUM,
                          fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.created.getDateFormat(),
                    style: TextStyle(
                        color: kMainTextColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 14),
                  ),
                  Flexible(
                    child: Text(
                      "Opening: ${_wallet?.currencySign ?? ""}${data.openBal.toSeparatorFormat()}\nClosing: ${_wallet?.currencySign ?? ""}${data.closeBal.toSeparatorFormat()}",
                      style: TextStyle(
                        color: kMainTextColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.BOLD,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
