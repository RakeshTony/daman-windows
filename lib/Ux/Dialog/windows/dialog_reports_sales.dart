import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/SalesReportDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_sales_report.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/sales_filter_page.dart';
import 'package:daman/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Routes/routes.dart';
import '../../../Utils/Widgets/AppImage.dart';

class DialogReportsSales extends StatefulWidget {
  @override
  State<DialogReportsSales> createState() => _DialogReportsSalesState();
}

class _DialogReportsSalesState
    extends BasePageState<DialogReportsSales, ViewModelSalesReport> {
  var wallet = HiveBoxes.getBalanceWallet();
  SalesReportData? data;
  late UserItem selectedUser;
  List<UserItem> users = [];

  Service? selectedService;
  Operator? selectedOperator;

  DateTime? toDate;
  DateTime? fromDate;

  @override
  void initState() {
    super.initState();
    selectedUser = UserItem(
        id: mPreference.value.userData.id,
        name: mPreference.value.userData.name);
    users.add(selectedUser);

    viewModel.responseStream.listen((event) {
      data = event.report;
      setState(() {});
    });
    _fetchReport();
  }

  _fetchReport() {
    viewModel.requestSalesReport(
        selectedUser.id, fromDate, toDate, selectedService, selectedOperator);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 480,
            maxHeight: 480,
            maxWidth: 780,
            minWidth: 780,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.salesReport!,
                    style: title(),
                  ),
                  Text(
                    "${selectedUser.name}",
                    style: title(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          var args = Map<String, dynamic>();
                          args["users"] = users;
                          args["selectedUser"] = selectedUser;
                          args["selectedService"] = selectedService;
                          args["selectedOperator"] = selectedOperator;
                          args["from_date_time"] = fromDate;
                          args["to_date_time"] = toDate;
                          args["filter_from"] = true;
                          var result = await Navigator.pushNamed(
                              context, PageRoutes.salesFilter,
                              arguments: args);
                          if (result != null) {
                            var success = result as Map<String, dynamic>;
                            selectedUser = success["user"];
                            selectedService = success["service"];
                            selectedOperator = success["operator"];
                            fromDate = success["from"];
                            toDate = success["to"];
                            _fetchReport();
                          }
                        },
                        child: Image.asset(
                          IC_FILTER_WHITE,
                          width: 18,
                          height: 18,
                        ),
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
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: kOTPBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAmountWidget(
                      "${data?.openingBalance ?? ''}",
                      locale.openingBalance!,
                    ),
                    _buildDivider(),
                    _buildAmountWidget(
                        "${data?.totalSales ?? ''}", locale.totalSales!),
                    _buildDivider(),
                    _buildAmountWidget(
                        "${data?.totalProfit ?? ''}", locale.totalProfit!),
                    _buildDivider(),
                    _buildAmountWidget(
                        "${data?.totalFund ?? ''}", locale.totalWalletFunding!),
                    _buildDivider(),
                    _buildAmountWidget(
                        "${data?.total ?? ''}", locale.totalBalance!),
                    _buildDivider(),
                    _buildAmountWidget("${data?.closingBalance ?? ''}",
                        locale.closingBalance!),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: kOTPBackground,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kWalletBackground,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                locale.operator!,
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                locale.profit!,
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                locale.sales!,
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                locale.salesCount!,
                                style: title_1(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: data?.operatorRecords.length ?? 0,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              _itemSales((data?.operatorRecords ??
                                  List<SalesReportOperatorData>.empty(
                                      growable: true))[index]),
                          separatorBuilder: (BuildContext context, int index) =>
                              _itemDivider(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _itemDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: .5,
        color: kColor2.withOpacity(.18),
      ),
    );
  }

  BoxDecoration decoration = BoxDecoration(
    color: kTitleBackground,
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 25,
      color: kContainerTextColor.withOpacity(.5),
    );
  }

  Widget _buildAmountWidget(String amount, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$amount",
            style: title().copyWith(fontSize: 16),
          ),
          Text(
            "$label",
            style: description_1().copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _itemSales(SalesReportOperatorData data) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                AppImage(
                  data.logo,
                  36,
                  defaultImage: DEFAULT_OPERATOR,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${data.title}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${data.profit}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${data.sales}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${data.salesCount}",
              style: description_1(),
            ),
          ),
        ],
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

  TextStyle title_1() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 12,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }

  TextStyle description_1() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 11,
        fontWeight: RFontWeight.REGULAR,
        fontFamily: RFontFamily.POPPINS);
  }
}
