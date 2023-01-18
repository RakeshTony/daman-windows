import 'package:flutter/material.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/main.dart';

class AppBarCommonWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldState;
  final String? title;
  final bool isShowBalance;
  final bool isShowUser;
  final bool isShowShare;
  final GestureTapCallback? doShare;
  final Color backgroundColor;
  final bool isShowNotification;

  AppBarCommonWidget({
    Key? key,
    this.parentScaffoldState,
    this.title,
    this.isShowBalance = true,
    this.isShowUser = true,
    this.isShowShare = false,
    this.isShowNotification = true,
    this.doShare,
    this.backgroundColor = kWhiteColor,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

  @override
  State createState() => AppBarCommonWidgetState();
}

class AppBarCommonWidgetState extends State<AppBarCommonWidget> {
  var wallet = HiveBoxes.getBalanceWallet();

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var items = <Widget>[
      SizedBox(
        height: widget.preferredSize.height,
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
          color: kMainColor,
          child: Container(
            height: widget.preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [_getBackIcon()],
                ),
                _getAppLogo(),
                _getNotificationIcon(),
              ],
            ),
          ),
        ),
      )
    ];
    return Material(
      child: Container(
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget _getBackIcon() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8, top: 4, bottom: 4),
        child: Icon(
          Icons.arrow_back_ios,
          color: kWhiteColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _getAppLogo() {
    return Image.asset(
      LOGO,
      height: 30,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getTitle() {
    return Flexible(
      child: Text(
        "${widget.title}",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: kWhiteColor,
          fontSize: 16,
          fontWeight: RFontWeight.REGULAR,
        ),
      ),
    );
  }

  Widget _getUserIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PageRoutes.profile);
        },
        child: Stack(
          children: [
            Image.asset(
              CIRCLE_BACKGROUND,
              width: 30,
              height: 30,
            ),
            Container(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  mPreference.value.userData.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 13, color: kWhiteColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getChangeLanguage() {
    var isShow = true;
    if (isShow) {
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: InkWell(
          onTap: () {},
          child: Image.asset(
            IC_CHANGE_LANGUAGE,
            width: 30,
            height: 30,
          ),
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget _getShareIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: widget.doShare,
        child: Image.asset(
          IC_SHARE,
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _getNotificationIcon() {
    return Visibility(
      visible: widget.isShowNotification,
      child: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.notificationPage);
          },
          child: Icon(
            Icons.notifications_outlined,
            size: 30,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}
