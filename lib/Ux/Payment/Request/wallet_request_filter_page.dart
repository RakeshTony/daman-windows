import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/main.dart';

import '../../../Utils/app_decorations.dart';


class WalletRequestPage extends StatelessWidget {
  DateTime? toDate;
  DateTime? fromDate;
  String? status_type;

  WalletRequestPage({
    this.toDate,
    this.fromDate,
    this.status_type,
  });

  @override
  Widget build(BuildContext context) {
    return WalletRequestBody(
      toDate: toDate,
      fromDate: fromDate,
      status_type:status_type,
    );
  }
}

class WalletRequestBody extends StatefulWidget {
  DateTime? toDate;
  DateTime? fromDate;
  String? status_type;
  WalletRequestBody({
    this.toDate,
    this.fromDate,
    this.status_type,
  });

  @override
  State<StatefulWidget> createState() => _WalletRequestBodyState();
}

class _WalletRequestBodyState extends BasePageState<WalletRequestBody, ViewModelCommon> {
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  FocusNode _toDateNode = FocusNode();
  FocusNode _fromDateNode = FocusNode();
  var statusdropdownValue = 'Select Status';

  @override
  void initState() {
    super.initState();
    widget.status_type = statusdropdownValue.toString();
    _setDateTime();
  }

  _setDateTime() {
    _fromDateController.text = widget.fromDate?.getDate() ?? "";
    _toDateController.text = widget.toDate?.getDate() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    List<String> spinnerItems = [
      'Select Status',
      'All',
      'Approved',
      'Pending',
      'Rejected',
    ];

    AppLog.e("DATE FROM", widget.fromDate ?? "NULL");
    AppLog.e("DATE TO", widget.toDate ?? "NULL");
    return Container(
      decoration: decorationBackground,
      child: Scaffold(
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
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      var dateTime = await _pickFromDate(context);
                      widget.fromDate = dateTime;
                      _setDateTime();
                    },
                    child: AbsorbPointer(
                      child: InputFieldWidget.text(AppLocalizations.of(context)!.fromDate!,
                          margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                          textEditingController: _fromDateController,
                          focusNode: _fromDateNode,
                          readOnly: true),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var dateTime = await _pickToDate(context);
                      widget.toDate = dateTime;
                      _setDateTime();
                    },
                    child: AbsorbPointer(
                      child: InputFieldWidget.text(AppLocalizations.of(context)!.toDate!,
                          margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                          textEditingController: _toDateController,
                          focusNode: _toDateNode,
                          readOnly: true),
                    ),
                  ),
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
                        value: statusdropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        isDense: true,
                        style: AppStyleText.inputFiledPrimaryText,
                        onChanged: (data) {
                          setState(() {
                            statusdropdownValue = data!;
                            widget.status_type = statusdropdownValue;
                          });
                        },
                        items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: AppLocalizations.of(context)!.reset!,
                margin: EdgeInsets.only(top: 16, left: 16, bottom: 16),
                radius: BorderRadius.all(Radius.circular(34.0)),
                color: kProgressBarBackground,
                onPressed: () {
                  widget.fromDate = null;
                  widget.toDate = null;
                  _setDateTime();
                  var args = Map<String, dynamic>();
                  args["to"] = widget.toDate;
                  args["from"] = widget.fromDate;
                  args["status"] = widget.status_type;
                  AppLog.e("DATA", args);
                  Navigator.pop(context, args);
                },
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: CustomButton(
                text: AppLocalizations.of(context)!.apply!,
                margin: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                radius: BorderRadius.all(Radius.circular(34.0)),
                onPressed: () {
                  var args = Map<String, dynamic>();
                  args["to"] = widget.toDate;
                  args["from"] = widget.fromDate;
                  args["status"] = widget.status_type;
                  if (widget.fromDate != null || widget.toDate != null) {
                    if (widget.fromDate == null) {
                      AppAction.showGeneralErrorMessage(
                          context, "Please Choose From Date");
                    } else if (widget.toDate == null) {
                      AppAction.showGeneralErrorMessage(
                          context, "Please Choose To Date");
                    } else {
                      Navigator.pop(context, args);
                    }
                  } else {
                    Navigator.pop(context, args);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),);
  }

  Future<DateTime?> _pickFromDate(BuildContext context) {
    var mToDate = widget.toDate ?? DateTime.now();
    var mInitialDate = DateTime.now();
    if (mInitialDate.isAfter(mToDate)) {
      mInitialDate = mToDate;
      mInitialDate.subtract(Duration(days: 1));
    }
    return showDatePicker(
      context: context,
      initialDate: mInitialDate,
      firstDate: DateTime(2021),
      lastDate: mToDate,
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
    var mFromDate = widget.fromDate ?? DateTime(2021);
    var mInitialDate = DateTime.now();
    if (mInitialDate.isBefore(mFromDate)) {
      mInitialDate = mFromDate;
      mInitialDate.add(Duration(days: 1));
    }
    return showDatePicker(
      context: context,
      initialDate: mInitialDate,
      firstDate: mFromDate,
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
