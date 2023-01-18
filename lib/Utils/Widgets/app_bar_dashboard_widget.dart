import 'package:flutter/material.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/main.dart';

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

class AppBarDashboardWidgetState extends State<AppBarDashboardWidget> {
  var wallet = HiveBoxes.getBalanceWallet();
  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      SizedBox(
        height: widget.preferredSize.height,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            color: kWhiteColor,
            child: Container(
              height: widget.preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _getDrawerIcon()
                    ],
                  ),
                  _getAppLogo(),
                  _getNotificationIcon(),
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

  Widget _getDrawerIcon() {
    return InkWell(
      onTap: () {
        if (widget.parentScaffoldState.currentState?.hasDrawer == true) {
          if (widget.parentScaffoldState.currentState?.isDrawerOpen == true) {
            Navigator.of(widget.parentScaffoldState.currentState!.context)
                .pop();
          } else {
            widget.parentScaffoldState.currentState!.openDrawer();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8, top: 4, bottom: 4),
        child: Image.asset(
          IC_MENU,
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Widget _getAppLogo() {
    return Image.asset(
      LOGO_HEADER,
      height: 33,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getUserIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {},
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
  Widget _getNotificationIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PageRoutes.notificationPage);
        },
        child: Image.asset(
          IC_BELL_NOTIFICATION,
          width: 30,
          height: 30,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _getScanPay() {
    var isShow = true;
    if (isShow) {
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.scanPay);
          },
          child: Image.asset(
            IC_SCAN,
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
}
