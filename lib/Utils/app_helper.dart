import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daman/Utils/app_action.dart';

class Helper {
  late BuildContext _context;
  DateTime? currentBackPressTime;

  Helper.of(BuildContext context) {
    this._context = context;
  }
  
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? now) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      AppAction.showGeneralErrorMessage(_context, "Back press AGAIN to exit.");
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
