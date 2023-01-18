import 'dart:io';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/default_config.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/dialog_change_language.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/app_decorations.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpAndSupportBody();
  }
}

class HelpAndSupportBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HelpAndSupportBodyState();
}

class _HelpAndSupportBodyState
    extends BasePageState<HelpAndSupportBody, ViewModelCommon> {
  var configs = HiveBoxes.getDefaultConfig();

  DefaultConfig? getConfig() {
    return configs.values.isNotEmpty ? configs.values.first : null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    var mConfig = getConfig();
    return Container(
      decoration: decorationBackground,
      child:Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: kTitleBackground,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Help & Support",
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _itemMenu(IC_FAQ, "FAQs", onTap: () {
              if (mConfig != null) {
                AppAction.openWebPage(context, "FAQs", mConfig.faq);
              }
            }),
            _itemMenu(IC_TIPS, "Complaints/Tickets Logging", onTap: () {
              if (mConfig != null) {
                AppAction.openWebPage(
                    context, "Complaints/Tickets Logging", mConfig.support);
              }
            }),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                "Contact Us",
                style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 16,
                  fontWeight: RFontWeight.LIGHT,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Visibility(
              visible: (mConfig?.contactNo ?? "").isNotEmpty,
              child:
                  _itemMenuSecond(IC_HELP_SUPPORT, "Customer Care", onTap: () {
                AppAction.makeCall(mConfig?.contactNo ?? "");
              }),
            ),
            Visibility(
              visible: (mConfig?.whatsAppNo ?? "").isNotEmpty,
              child: _itemMenuSecond(IC_HELP_SUPPORT, "Connect on Whatsapp",
                  onTap: () {
                openwhatsapp(mConfig?.whatsAppNo ?? "");
              }),
            ),
            _itemMenuSecond(IC_FACEBOOK, "Facebook", onTap: () {
              AppAction.launchUrl(context, mConfig?.facebookUrl ?? "");
            }),
            _itemMenuSecond(IC_TWITTER, "Twitter", onTap: () {
              AppAction.launchUrl(context, mConfig?.twitterUrl ?? "");
            }),
          ],
        ),
      ),
    ),);
  }

  openwhatsapp(String number) async {
    var whatsapp = number; //"+919144040888";
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=Hi!";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("Hi!")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  _itemMenu(String icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: kShadow,
            offset: Offset(1.0, 1.0),
            blurRadius: 2,
            spreadRadius: 1.0,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Image.asset(
          icon,
          width: 30,
          height: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: kMainTextColor,
              fontSize: 14,
              fontWeight: RFontWeight.LIGHT),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: kMainColor,
        ),
      ),
    );
  }

  _itemMenuSecond(String icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: kWhiteColor,
            boxShadow: [
              BoxShadow(
                color: kShadow,
                offset: Offset(1.0, 1.0),
                blurRadius: 2,
                spreadRadius: 1.0,
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 14,
                      fontWeight: RFontWeight.LIGHT),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
