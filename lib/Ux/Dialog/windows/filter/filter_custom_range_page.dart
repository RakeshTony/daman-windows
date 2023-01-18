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
import '../../../../Utils/app_decorations.dart';

class DialogCustomRangeFilter extends StatefulWidget {
  DateTime _fromDate;
  DateTime _toDate;
  String typeDropdownValue;
  String number;
  String transactionId;

  DialogCustomRangeFilter(
    this._fromDate,
    this._toDate, {
    this.typeDropdownValue = 'Select Main Type',
    this.number = "",
    this.transactionId = "",
  });

  @override
  State<StatefulWidget> createState() => _DialogCustomRangeFilterState();
}

class _DialogCustomRangeFilterState
    extends BasePageState<DialogCustomRangeFilter, ViewModelCommon> {
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _transactionIDController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  FocusNode _toDateNode = FocusNode();
  FocusNode _fromDateNode = FocusNode();
  FocusNode _transactionNode = FocusNode();
  FocusNode _mobileNode = FocusNode();

  var _initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _transactionIDController.text = widget.transactionId;
    _mobileNumberController.text = widget.number;
    _setDateTime();
  }

  _setInitialDate() {
    if (_initialDate.isBefore(widget._fromDate)) {
      _initialDate = widget._fromDate;
      _initialDate.add(Duration(days: 1));
    } else if (_initialDate.isAfter(widget._toDate)) {
      _initialDate = widget._toDate;
      _initialDate.subtract(Duration(days: 1));
    }
  }

  _setDateTime() {
    _setInitialDate();
    _fromDateController.text = widget._fromDate.getDate();
    _toDateController.text = widget._toDate.getDate();
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 320,
            minWidth: 320,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.filter!,
                      style: title(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: InkWell(
                        child: Icon(Icons.close, color: kWhiteColor),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                ListView(
                    shrinkWrap: true,
                    children: [
                  GestureDetector(
                    onTap: () async {
                      var dateTime = await _pickFromDate(context);
                      widget._fromDate = dateTime ?? widget._fromDate;
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
                      widget._toDate = dateTime ?? widget._toDate;
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
                            bottom: BorderSide(
                                width: 1.0, color: kTextInputInactive),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: widget.typeDropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText,
                            onChanged: (data) {
                              setState(() {
                                widget.typeDropdownValue = data!;
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
                        AppLocalizations.of(context)!
                            .mobileNumberAccountNumber!,
                        margin: EdgeInsets.only(top: 14, left: 16, right: 16),
                        textEditingController: _mobileNumberController,
                        focusNode: _mobileNode,
                      ),
                    ],
                  ),
                ]),
                CustomButton(
                  text: AppLocalizations.of(context)!.apply!,
                  margin:
                      EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                  radius: BorderRadius.all(Radius.circular(34.0)),
                  onPressed: () {
                    var data = Map<String, dynamic>();
                    data["from_date_time"] = widget._fromDate;
                    data["to_date_time"] = widget._toDate;
                    data["type"] = widget.typeDropdownValue == "IssuedEpin"
                        ? "IssueEpin"
                        : widget.typeDropdownValue == "Wallet Topup"
                            ? 'Transfer'
                            : widget.typeDropdownValue;
                    data["number"] = _mobileNumberController.text.toString();
                    data["transaction_id"] =
                        _transactionIDController.text.toString();
                    Navigator.pop(context, data);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle title() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 13,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }

/*

* */
  Future<DateTime?> _pickFromDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(2021),
      lastDate: widget._toDate,
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
      firstDate: widget._fromDate,
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
