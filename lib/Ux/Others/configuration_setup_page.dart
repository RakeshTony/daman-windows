import 'package:daman/Database/models/offline_pin_stock.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/text_widget.dart';
import 'package:daman/Utils/app_helper.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/main.dart';

import '../../Database/hive_boxes.dart';
import '../../Locale/locales.dart';
import '../../Utils/app_decorations.dart';
import 'ViewModel/view_model_configuration_setup.dart';

class ConfigurationSetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConfigurationSetupBody();
  }
}

class ConfigurationSetupBody extends StatefulWidget {
  @override
  State createState() {
    return _ConfigurationSetupBodyState();
  }
}

class _ConfigurationSetupBodyState
    extends BasePageState<ConfigurationSetupBody, ViewModelConfigurationSetup> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    viewModel.requestSync();
    viewModel.progressStream.listen((event) {
      progress = event;
      setState(() {});
      if (progress == 0.95) {
        Future.delayed(Duration(seconds: 2), () async {
          if (mPreference.value.mPin.isEmpty) {
            await Navigator.pushNamed(context, PageRoutes.setPin);
            if (mPreference.value.mPin.isEmpty)
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            else
              askPin();
          } else {
            askPin();
          }
        });
      }
    }, cancelOnError: false);

    viewModel.responseStreamSettlement.listen((event) async {
      AppLog.e("LIST ITEMS VOUCHER", event.vouchers.length);
      var mDownloadPins =
          event.vouchers.map((e) => e.toOfflinePinStock).toList();
      await HiveBoxes.getOfflinePinStock().clear();
      mDownloadPins.forEach((element) async {
        AppLog.e("LIST ITEMS SINGLE", HiveBoxes.getOfflinePinStock().length);
        await HiveBoxes.getOfflinePinStock().put(element.recordId, element);
      });
      AppLog.e("LIST ITEMS", HiveBoxes.getOfflinePinStock().length);
    });
  }

  void askPin() async {
    var status = await Navigator.pushNamed(context, PageRoutes.enterPin);
    if (status == "SUCCESS") {
      Navigator.pushNamed(context, PageRoutes.bottomNavigation);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      child: Container(
        decoration: decorationBackground,
        child: Scaffold(
          backgroundColor: kTransparentColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                ),
                Image.asset(
                  LOGO,
                  width: 192,
                  height: 90,
                ),
                SizedBox(
                  height: 56,
                ),
                TextWidget.big(
                  AppLocalizations.of(context)!.setupBasicConfiguration!,
                  fontFamily: RFontWeight.REGULAR,
                  textAlign: TextAlign.center,
                  color: kWhiteColor,
                  fontSize: 27,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextWidget.big(
                        AppLocalizations.of(context)!.loading!,
                        fontFamily: RFontWeight.REGULAR,
                        textAlign: TextAlign.center,
                        color: kWhiteColor,
                        fontSize: 25,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        height: 40,
                        // padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: kProgressBarBackground,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          child: LinearProgressIndicator(
                            value: progress,
                            valueColor: AlwaysStoppedAnimation<Color>(kColor5),
                            backgroundColor: kTransparentColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: Helper.of(context).onWillPop,
    );
  }
}
