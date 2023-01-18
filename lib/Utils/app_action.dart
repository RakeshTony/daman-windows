import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/dialog_progress.dart';
import 'package:daman/Ux/Others/page_web_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:another_flushbar/flushbar.dart';

class AppAction {
  AppAction._();
  static void showGeneralErrorMessage(BuildContext context, String message) {

    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 1),
    )..show(context);

    /*SnackBar snackBar =
    SnackBar(
      content: Container(
          padding: EdgeInsets.only( bottom:
          MediaQuery.of(context).viewInsets.bottom),
          child: Text(message)),
      duration: Duration(milliseconds:  800),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    */
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));*/
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 80, right: 0, left: 0),
    ));*/
  }

  static void rateUs() {
    if (Platform.isAndroid) {
      var appPackageName = "com.daman.ly";
      try {
        launch("market://details?id=" + appPackageName);
      } on PlatformException catch (e) {
        launch(
            "https://play.google.com/store/apps/details?id=" + appPackageName);
      } finally {
        launch(
            "https://play.google.com/store/apps/details?id=" + appPackageName);
      }
    }
  }

  static void makeCall(String phone) {
    launch("tel://$phone");
  }

  static void launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      showGeneralErrorMessage(context, "There was a problem to open the url");
    }
  }

  static void validateFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    if (nextNode != null) FocusScope.of(context).requestFocus(nextNode);
  }

  static DialogProgress showProgress(BuildContext context, String title) {
    DialogProgress dialog = DialogProgress(context, title);
    showDialog(
      context: context,
      builder: (context) => dialog,
      barrierDismissible: false,
    );
    return dialog;
  }

  static void openWebPage(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageWebView(title, url),
      ),
    );
  }

  static loadImage(String url, double width, double height,
      {String placeHolder = DEFAULT_FLAG}) {
    return FadeInImage(
      image: NetworkImage(url),
      width: width,
      height: height,
      placeholder: AssetImage(placeHolder),
      imageErrorBuilder: ((context, error, stackTrace) {
        return Image.asset(placeHolder);
      }),
    );
  }
}
