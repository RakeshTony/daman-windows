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

class UserItem {
  String id;
  String name;

  UserItem({required this.id, required this.name});
}

class SalesFilterPage extends StatelessWidget {
  List<UserItem> users;
  DateTime? toDate;
  DateTime? fromDate;
  UserItem selectedUser;
  Service? selectedService;
  Operator? selectedOperator;
  bool filter_from;

  SalesFilterPage({
    required this.users,
    required this.selectedUser,
    required this.selectedService,
    required this.selectedOperator,
    this.toDate,
    this.fromDate,
    required this.filter_from,
  });

  @override
  Widget build(BuildContext context) {
    return SalesFilterBody(
      users: users,
      toDate: toDate,
      fromDate: fromDate,
      selectedUser: selectedUser,
      selectedService: selectedService,
      selectedOperator: selectedOperator,
      filter_from:filter_from,
    );
  }
}

class SalesFilterBody extends StatefulWidget {
  List<UserItem> users;
  DateTime? toDate;
  DateTime? fromDate;
  UserItem selectedUser;
  Service? selectedService;
  Operator? selectedOperator;
  bool filter_from;
  SalesFilterBody({
    required this.users,
    required this.selectedUser,
    required this.selectedService,
    required this.selectedOperator,
    this.toDate,
    this.fromDate,
    required this.filter_from,
  });

  @override
  State<StatefulWidget> createState() => _SalesFilterBodyState();
}

class _SalesFilterBodyState
    extends BasePageState<SalesFilterBody, ViewModelCommon> {
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  FocusNode _toDateNode = FocusNode();
  FocusNode _fromDateNode = FocusNode();
  var _mService = HiveBoxes.getServices();
  var _mOperators = HiveBoxes.getOperators();
  var mDefaultService = Service(title: "Select Service");
  var mDefaultServiceAll = Service(title: "All");
  var mDefaultOperator = Operator(name: "Select Operator");
  var mDefaultOperatorAll = Operator(name: "All");

  List<Service> getServices() {
    var services = List<Service>.empty(growable: true);
    services.add(mDefaultService);
    services.add(mDefaultServiceAll);
    services.addAll(_mService.values.map((e) => e).toList());
    return services;
  }

  List<Operator> getOperators() {
    var operators = List<Operator>.empty(growable: true);
    operators.add(mDefaultOperator);
    operators.add(mDefaultOperatorAll);
    if (widget.selectedService != null &&
        (widget.selectedService?.id ?? "").isNotEmpty) {
      operators.addAll(_mOperators.values
          .where((element) =>
              element.serviceId == (widget.selectedService?.id ?? ""))
          .map((e) => e)
          .toList());
    }
    return operators;
  }

  @override
  void initState() {
    super.initState();
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
    AppLog.e("USERS", widget.users);
    AppLog.e("USER", widget.selectedUser);
    AppLog.e("DATE FROM", widget.fromDate ?? "NULL");
    AppLog.e("DATE TO", widget.toDate ?? "NULL");
    AppLog.e("SERVICE", widget.selectedService ?? "NULL");
    AppLog.e("OPERATOR", widget.selectedOperator ?? "NULL");
    if (widget.selectedService == null)
      widget.selectedService = mDefaultService;
    if (widget.selectedOperator == null)
      widget.selectedOperator = mDefaultOperator;
    return WillPopScope(
        onWillPop: () async => false,
        child:Dialog(
        backgroundColor: Colors.transparent,
        child:Container(
      constraints: BoxConstraints(
        maxWidth: 320,
        minWidth: 320,
      ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: kColor_1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
   child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: kMainButtonColor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child:Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.filter!,
                  style: title(),

                ),
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: InkWell(
                    child: Icon(Icons.close, color: kWhiteColor),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )),
            ListView(
              shrinkWrap: true,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    padding: EdgeInsets.only(top: 14, bottom: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: kTextInputInactive),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<UserItem>(
                        value: widget.selectedUser,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        isDense: true,
                        style: AppStyleText.inputFiledPrimaryText,
                        onChanged: (data) {
                          setState(() {
                            widget.selectedUser = data!;
                          });
                        },
                        items: widget.users
                            .map<DropdownMenuItem<UserItem>>((UserItem value) {
                          return DropdownMenuItem<UserItem>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
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
                  Visibility(
                    visible: widget.filter_from,
                      child: Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        padding: EdgeInsets.only(top: 14, bottom: 14),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(width: 1.0, color: kTextInputInactive),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Service>(
                            value: widget.selectedService,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText,
                            onChanged: (data) {
                              setState(() {
                                widget.selectedService = data!;
                                widget.selectedOperator = null;
                              });
                            },
                            items: getServices()
                                .map<DropdownMenuItem<Service>>((Service value) {
                              return DropdownMenuItem<Service>(
                                value: value,
                                child: Text(value.title),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ),
                  Visibility(
                    visible: widget.filter_from,
                    child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    padding: EdgeInsets.only(top: 14, bottom: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                        BorderSide(width: 1.0, color: kTextInputInactive),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Operator>(
                        value: widget.selectedOperator,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        isDense: true,
                        style: AppStyleText.inputFiledPrimaryText,
                        onChanged: (data) {
                          setState(() {
                            widget.selectedOperator = data!;
                          });
                        },
                        items: getOperators()
                            .map<DropdownMenuItem<Operator>>((Operator value) {
                          return DropdownMenuItem<Operator>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  ),

                ],
              ),
            Container(
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
                        widget.selectedService = null;
                        widget.selectedOperator = null;
                        _setDateTime();
                        widget.selectedUser = widget.users.firstWhere(
                                (element) => element.id == mPreference.value.userData.id);
                        var args = Map<String, dynamic>();
                        args["user"] = widget.selectedUser;
                        args["to"] = widget.toDate;
                        args["from"] = widget.fromDate;
                        args["service"] = widget.selectedService;
                        args["operator"] = widget.selectedOperator;
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
                        args["user"] = widget.selectedUser;
                        args["to"] = widget.toDate;
                        args["from"] = widget.fromDate;
                        args["service"] =
                        (widget.selectedService?.id ?? "").isNotEmpty ? widget.selectedService : null;
                        args["operator"] =
                        (widget.selectedOperator?.id ?? "").isNotEmpty
                            ? widget.selectedOperator
                            : null;
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
          ],
        ),
      ),
    )
    ));
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
  TextStyle title() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 13,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }
}
