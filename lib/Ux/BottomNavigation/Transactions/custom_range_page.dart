import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_style_text.dart';

import '../../../Utils/app_decorations.dart';

class CustomRangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomRangeBody();
  }
}

class CustomRangeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomRangeBodyState();
}

class _CustomRangeBodyState
    extends BasePageState<CustomRangeBody, ViewModelCommon> {
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _transactionIDController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  FocusNode _toDateNode = FocusNode();
  FocusNode _fromDateNode = FocusNode();
  FocusNode _transactionNode = FocusNode();
  FocusNode _mobileNode = FocusNode();

  var _fromDate = DateTime.now();
  var _toDate = DateTime.now();
  var _initialDate = DateTime.now();
  var mainTypeDropdownValue = 'Select Main Type';

  @override
  void initState() {
    super.initState();
    _setDateTime();
  }

  _setInitialDate() {
    if (_initialDate.isBefore(_fromDate)) {
      _initialDate = _fromDate;
      _initialDate.add(Duration(days: 1));
    } else if (_initialDate.isAfter(_toDate)) {
      _initialDate = _toDate;
      _initialDate.subtract(Duration(days: 1));
    }
  }

  _setDateTime() {
    _setInitialDate();
    _fromDateController.text = _fromDate.getDate();
    _toDateController.text = _toDate.getDate();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    List<String> spinnerItems = [
    'Select Main Type',
      'All',
      'Wallet Topup',
      'Recharge',
      'Profit',
      'IssuedEpin',
      'Payout'
    ];

    return Container(
        decoration: decorationBackground,
        child:Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: kTitleBackground,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.filter!,
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(children: [
                GestureDetector(
                  onTap: () async {
                    var dateTime = await _pickFromDate(context);
                    _fromDate = dateTime ?? _fromDate;
                    _setDateTime();
                  },
                  child: AbsorbPointer(
                    child: InputFieldWidget.text(
                      AppLocalizations.of(context)!.fromDate!,
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _fromDateController,
                      focusNode: _fromDateNode,
                      readOnly: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var dateTime = await _pickToDate(context);
                    _toDate = dateTime ?? _toDate;
                    _setDateTime();
                  },
                  child: AbsorbPointer(
                    child: InputFieldWidget.text(
                      AppLocalizations.of(context)!.toDate!,
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _toDateController,
                      focusNode: _toDateNode,
                      readOnly: true,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16, right: 16, top: 14),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: kTextInputInactive),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: mainTypeDropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          isDense: true,
                          style: AppStyleText.inputFiledPrimaryText,
                          onChanged: (data) {
                            setState(() {
                              mainTypeDropdownValue = data!;
                            });
                          },
                          items: spinnerItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InputFieldWidget.number(
                      AppLocalizations.of(context)!.transactionsId!,
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _transactionIDController,
                      focusNode: _transactionNode,
                    ),
                    InputFieldWidget.number(
                      AppLocalizations.of(context)!.mobileNumberAccountNumber!,
                      margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                      textEditingController: _mobileNumberController,
                      focusNode: _mobileNode,
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: AppLocalizations.of(context)!.search!,
        margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        radius: BorderRadius.all(Radius.circular(34.0)),
        onPressed: () {
          var data = Map<String, dynamic>();
          data["from_date_time"] = _fromDate;
          data["to_date_time"] = _toDate;
          data["type"] = mainTypeDropdownValue == "IssuedEpin"
              ? "IssueEpin"
              : mainTypeDropdownValue == "Wallet Topup"
                  ? 'Transfer'
                  : mainTypeDropdownValue;
          data["number"] = _mobileNumberController.text.toString();
          data["transaction_id"] = _transactionIDController.text.toString();
          Navigator.pushNamed(context, PageRoutes.myTransaction,
              arguments: data);
        },
      ),
    ),);
  }

  Future<DateTime?> _pickFromDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(2021),
      lastDate: _toDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }

  Future<DateTime?> _pickToDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: _fromDate,
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }
}
