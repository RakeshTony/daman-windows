import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/RecentTransactionDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Database/models/services_child.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Ux/Dialog/dialog_country_picker.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:daman/Ux/Topup/ViewModel/view_model_top_up.dart';

class TopUpPage extends StatelessWidget {
  ServiceChild service;

  TopUpPage(this.service);

  @override
  Widget build(BuildContext context) {
    return TopUpBody(service);
  }
}

class TopUpBody extends StatefulWidget {
  ServiceChild service;

  TopUpBody(this.service);

  @override
  State<StatefulWidget> createState() => _TopUpBodyState();
}

class _TopUpBodyState extends BasePageState<TopUpBody, ViewModelTopUp> {
  TextEditingController _numberController = TextEditingController();
  FocusNode _numberNode = FocusNode();
  List<CountryData> countries = [];
  CountryData? _countrySelected;

  @override
  void initState() {
    super.initState();
    countries =
        HiveBoxes.getCountries().values.map((e) => e.toCountryData).toList();
    if (_countrySelected == null && countries.isNotEmpty) {
      var selected = countries.firstWhere(
          (element) => element.id.endsWith(AppSettings.COUNTRY_ID),
          orElse: null);
      if (selected == null)
        _countrySelected = countries.first;
      else
        _countrySelected = selected;
      setState(() {});
    }
    viewModel.responseStream.listen((event) {
      AppLog.i(event);
      var args = {};
      args["mobile"] = _numberController.text.toString();
      args["countryId"] = _countrySelected?.id ?? "";
      args["countryCode"] = _countrySelected?.phoneCode ?? "";
      args["countryFlag"] = _countrySelected?.flag ?? "";
      args["operatorId"] = event.operator?.operatorId ?? "";
      args["circleCode"] = event.operator?.circleCode ?? "";
      Navigator.pushNamed(context, PageRoutes.topUpOperator, arguments: args);
    });
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.requestRecentTopUps();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                "Welcome Back!",
                style: TextStyle(color: kMainTextColor, fontSize: 26),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Text(
                "Enter the phone number you want to top-up",
                style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 14,
                    fontWeight: RFontWeight.LIGHT),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Stack(
                children: [
                  InputFieldWidget.number(
                    locale.mobileNumber ?? "",
                    padding: EdgeInsets.only(
                        top: 16, right: 48, left: 48, bottom: 16),
                    textEditingController: _numberController,
                    focusNode: _numberNode,
                    maxLength: _countrySelected?.mobileNumberLength,
                  ),
                  InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      child: Text(
                        "+${_countrySelected?.phoneCode}",
                        style: AppStyleText.inputFiledPrimaryText,
                      ),
                    ),
                    onTap: () {
                      var dialogCountryPicker = DialogCountryPicker(
                        data: countries,
                        onTap: (country) {
                          _countrySelected = country;
                          setState(() {});
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (context) => dialogCountryPicker);
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        child: Image.asset(
                          IC_PHONE_BOOK,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      onTap: () async {
                        try {
                          if (await FlutterContactPicker.hasPermission()) {
                            final PhoneContact contact =
                                await FlutterContactPicker.pickPhoneContact();
                            AppLog.e("CONTACT", contact);
                            _numberController.text =
                                contact.phoneNumber?.number ?? "";
                          } else {
                            final granted =
                                await FlutterContactPicker.requestPermission();
                          }
                        } catch (e) {}
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: mediaQuery.size.width,
              child: CustomButton(
                text: "Next",
                margin:
                    EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                radius: BorderRadius.all(Radius.circular(34.0)),
                onPressed: () {
                  viewModel.requestAutoDetectOperator(
                      _countrySelected?.id ?? "0", _numberController);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                "Recent Topup",
                style: TextStyle(color: kMainTextColor, fontSize: 20),
              ),
            ),
            Container(
              height: 100,
              margin: EdgeInsets.only(left: 8, top: 12),
              child: StreamBuilder(
                stream: viewModel.recentTopUpStream,
                initialData: List<RecentTransactionModel>.empty(growable: true),
                builder: (context,
                    AsyncSnapshot<List<RecentTransactionModel>> snapshot) {
                  var items =
                      List<RecentTransactionModel>.empty(growable: true);
                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data ?? [];
                    items.addAll(data);
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _itemRecentTopUp(items[index], index),
                  );
                },
              ),
            ),
            Container(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    DUMMY_RECHARGE,
                    width: mediaQuery.size.width,
                    height: mediaQuery.size.width / 2.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemRecentTopUp(RecentTransactionModel data, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage(
            data.operatorLogo,
            72,
            defaultImage: DEFAULT_OPERATOR,
            borderColor: kProgressBarBackground,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              data.reloadNo,
              style: TextStyle(
                  color: kTextColor2,
                  fontSize: 13,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ],
      ),
    );
  }
}
