import 'dart:async';

import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/app_decorations.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Collection/remita_form_field.dart';
import 'package:daman/main.dart';

import '../../Database/hive_boxes.dart';
import '../../Database/models/push_notification.dart';
import '../../Utils/app_log.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends BasePageState<Splash, ViewModelCommon> {
  bool drop = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      navigateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      decoration: decorationBackground,
      child: Scaffold(
        backgroundColor: kTransparentColor,
        body: Center(
          child: Container(
            width: 192,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LOGO),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateUser() async {
    if (mPreference.value.isLogin) {
      if (mPreference.value.mPin.isEmpty) {
        await Navigator.pushNamed(context, PageRoutes.setPin);
        if (mPreference.value.mPin.isEmpty)
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        else
          askPin();
      } else {
        askPin();
      }
    } else {
      //await DesktopWindow.setMaxWindowSize(Size(600, 950));
      Navigator.pushNamed(context, PageRoutes.login);
    }
  }

  void askPin() async {
    var status = await Navigator.pushNamed(context, PageRoutes.enterPin);
    if (status == "SUCCESS") {
      Navigator.pushNamed(context, PageRoutes.bottomNavigation);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
