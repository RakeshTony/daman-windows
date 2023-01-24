import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/DownlineUsersDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Enum/enum_sort_type.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/firebase_node.dart';
import 'package:daman/Ux/Dialog/dialog_success.dart';
import 'package:daman/main.dart';
import '../../Utils/app_decorations.dart';
import '../../Utils/app_log.dart';
import '../Payment/Send/pay_now_page.dart';
import 'ViewModel/view_model_my_down_line_users.dart';
import 'down_line_page.dart';

class MyDownLineUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDownLineUsersBody();
  }
}

class MyDownLineUsersBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyDownLineUsersBodyState();
}

class _MyDownLineUsersBodyState
    extends BasePageState<MyDownLineUsersBody, ViewModelMyDownLineUsers> {
  List<DownLineUser> mData = [];
  String selectedUserName = "";

  @override
  void initState() {
    super.initState();
    //viewModel.requestDownlineUsers();
    viewModel.downLineStream.listen((map) {
      if (mData.isNotEmpty) mData.clear();
      mData.addAll(map);
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    viewModel.userWalletStream.listen((map) {
      if (mounted) {
        /*Navigator.pushNamed(context, PageRoutes.payNow,
            arguments: map.userData);*/
        var dialog = PayNowPage(users: map.userData);
        showDialog(
          context: context,
          builder: (context) => dialog,
        );
      }
    }, cancelOnError: false);
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);

    viewModel.balanceResponseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: selectedUserName + " Wallet Balance!",
            message: "${map.balance.total}",
            actionText: "OK",
            isCancelable: false,
            onActionTap: () {});
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
/*
    databaseReference
        .child(FirebaseNode.USERS)
        .child(mPreference.value.userData.firebaseId)
        .child(FirebaseNode.DOWNLINE)
        .onValue
        .listen((data) {
      AppLog.e("USERS DOWNLINE", data.snapshot.value ?? "");
      if (data.snapshot.value is List) {
        var downlineUsers = toList(data.snapshot.value);
        if (mData.isNotEmpty) mData.clear();
        downlineUsers.forEach((element) async {
          var user = await databaseReference
              .child(FirebaseNode.USERS)
              .child(element.toString())
              .once();
          if (user.snapshot.value is Map) {
            mData.add(DownLineUser.fromJson(toMaps(user.snapshot.value)));
          }
          setState(() {});
          AppLog.e("USER", user.snapshot.value ?? "");
        });
      }
    }).onError((handleError) {
      viewModel.requestDownlineUsers();
    });
*/
    viewModel.requestDownlineUsers();
  }

  void sortData(SortTypeDownLine sort) {
    if (sort == SortTypeDownLine.RECENT_ADDED) {
      mData.sort((a, b) {
        return b.created.getDateTime().compareTo(a.created.getDateTime());
      });
    } else if (sort == SortTypeDownLine.RECENT_WALLET_TOPUP) {
      mData.sort((a, b) {
        if (a.lastWalletTopupDate.isNotEmpty &&
            b.lastWalletTopupDate.isNotEmpty) {
          return b.lastWalletTopupDate
              .getDateTime()
              .compareTo(a.lastWalletTopupDate.getDateTime());
        } else if (a.lastWalletTopupDate.isEmpty &&
            b.lastWalletTopupDate.isEmpty) {
          return 0;
        } else if (a.lastWalletTopupDate.isEmpty) {
          return 1;
        } else {
          return -1;
        }
      });
    } else if (sort == SortTypeDownLine.LOW_WALLET_BALANCE) {
      mData.sort((a, b) => a.walletBalance.compareTo(b.walletBalance));
    } else if (sort == SortTypeDownLine.RANK) {
      mData.sort((a, b) => a.groupRank.compareTo(b.groupRank));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            constraints: BoxConstraints(
              minHeight: 480,
              maxHeight: 480,
              maxWidth: 720,
              minWidth: 720,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: kColor_1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kWalletBackground, width: 2)),
            child: Container(
              color: kColor_1,
              child: Scaffold(
                backgroundColor: kColor_1,
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.myDOwnlineUsers!,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: kWhiteColor,
                                  fontWeight: RFontWeight.LIGHT,
                                  fontFamily: RFontFamily.POPPINS),
                            ),
                            Row(
                              children: [
                                PopupMenuButton(
                                  color: kWhiteColor,
                                  icon: Icon(
                                    Icons.filter_list,
                                    color: kWhiteColor,
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                          value: SortTypeDownLine.RANK,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.workspaces_outline,
                                                  color: kMainColor,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .rank!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: kMainColor,
                                                  fontFamily:
                                                      RFontFamily.POPPINS,
                                                  fontWeight:
                                                      RFontWeight.REGULAR,
                                                ),
                                              )
                                            ],
                                          )),
                                      PopupMenuItem(
                                          value: SortTypeDownLine.RECENT_ADDED,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.person_add,
                                                  color: kMainColor,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .recentlyAdded!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: kMainColor,
                                                  fontFamily:
                                                      RFontFamily.POPPINS,
                                                  fontWeight:
                                                      RFontWeight.REGULAR,
                                                ),
                                              )
                                            ],
                                          )),
                                      PopupMenuItem(
                                          value: SortTypeDownLine
                                              .RECENT_WALLET_TOPUP,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.account_balance_wallet,
                                                  color: kMainColor,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .recentWalletTopup!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: kMainColor,
                                                  fontFamily:
                                                      RFontFamily.POPPINS,
                                                  fontWeight:
                                                      RFontWeight.REGULAR,
                                                ),
                                              )
                                            ],
                                          )),
                                      PopupMenuItem(
                                          value: SortTypeDownLine
                                              .LOW_WALLET_BALANCE,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons
                                                      .account_balance_wallet_outlined,
                                                  color: kMainColor,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .lowWalletBalance!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: kMainColor,
                                                  fontFamily:
                                                      RFontFamily.POPPINS,
                                                  fontWeight:
                                                      RFontWeight.REGULAR,
                                                ),
                                              )
                                            ],
                                          ))
                                    ];
                                  },
                                  onSelected: (SortTypeDownLine value) {
                                    sortData(value);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: InkWell(
                                    child:
                                        Icon(Icons.close, color: kWhiteColor),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: mData.length,
                          itemBuilder: (context, index) =>
                              _itemDownLine(mData[index]),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: CustomButton(
                  text: AppLocalizations.of(context)!.addDownlineUser!,
                  radius: BorderRadius.all(Radius.circular(34.0)),
                  onPressed: () async {
                    // var result = await Navigator.pushNamed(context, PageRoutes.downLine);
                    /*if (result == 'RELOAD') {
            // viewModel.requestDownlineUsers();
          }*/
                    var dialog = DownLinePage();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }

  _itemDownLine(DownLineUser user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 12,
          ),
          ListTile(
            leading: AppImage(
              user.icon,
              50,
              defaultImage: DEFAULT_PERSON,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "${user.name}",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: kMainTextColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                          fontSize: 14),
                    ),
                    Text(
                      "${user.mobile}",
                      style: TextStyle(
                          color: kMainTextColor,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.LIGHT,
                          fontSize: 13),
                    ),
                  ],
                ),

                /*  Text(
                  "${user.groupRank}",
                  //textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: kColor4,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 12),
                ),*/
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        selectedUserName = user.name;
                        viewModel.requestUserBalanceEnquiry(user.id);
                      },
                      child: Container(
                        height: 32,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.balance!,
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 14,
                              fontWeight: RFontWeight.MEDIUM,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.requestUserWallet(user.mobile);
                      },
                      child: Container(
                        height: 32,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.sendMoney!,
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 14,
                              fontWeight: RFontWeight.MEDIUM,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            contentPadding: EdgeInsets.zero,
          ),
          SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
