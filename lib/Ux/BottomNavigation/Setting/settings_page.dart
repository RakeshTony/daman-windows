
import 'package:daman/Ux/BottomNavigation/Setting/set_pin_page.dart';
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/dialog_change_language.dart';

import '../../../Utils/app_decorations.dart';
import 'change_password_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsBody();
  }
}

class SettingsBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends BasePageState<SettingsBody, ViewModelCommon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 320,
              maxHeight: 320,
              maxWidth: 320,
              minWidth: 320,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTitleBackground, width: 2)),
            child:Container(
              child: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kWalletBackground,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16,bottom: 16),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                  AppLocalizations.of(context)!.setting!,
                  style: TextStyle(
                      fontSize: 14,
                      color: kWhiteColor,
                      fontWeight: RFontWeight.LIGHT,
                      fontFamily: RFontFamily.POPPINS),
                ),
                Padding(
                padding: const EdgeInsets.only(left: 16),
                child: InkWell(
                  child: Icon(Icons.close, color: kWhiteColor),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),],),
            ),
            SizedBox(
              height: 16,
            ),
           /* _itemMenu(IC_CHANGE_LANGUAGE_1, "Change Language", onTap: () {
              var dialogChangeLanguage = DialogChangeLanguage(
                language: "en",
                onTap: (lang) {},
              );
              showDialog(
                  context: context, builder: (context) => dialogChangeLanguage);
            }),*/
            _itemMenu(IC_LOCK, AppLocalizations.of(context)!.changePassword!, onTap: () {
              var dialog = ChangePasswordPage();
              showDialog(
                context: context,
                builder: (context) => dialog,
              );
            }),
            _itemMenu(IC_LOCK, AppLocalizations.of(context)!.mPin!, onTap: () {
              //Navigator.pushNamed(context, PageRoutes.setPin);
              var dialog = SetPinPage();
              showDialog(
                context: context,
                builder: (context) => dialog,
              );
            }),
           /* _itemMenu(IC_ABOUT_US, "About Us", onTap: () {
              Navigator.pushNamed(context, PageRoutes.aboutUs);
            }),*/
            SizedBox(
              height: 36,
            )
          ],
        ),
      ),),),),
    );
  }

  _itemMenu(String icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: kOTPBackground,
            boxShadow: [
              BoxShadow(
                color: kShadow,
                offset: Offset(1.0, 1.0),
                blurRadius: 2,
                spreadRadius: 1.0,
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(26)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(.2),
                child: Image.asset(
                  icon,
                  width: 52,
                  height: 52,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                title,
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.LIGHT),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
