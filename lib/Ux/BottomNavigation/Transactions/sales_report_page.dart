import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/SalesReportDataModel.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_sales_report.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/sales_filter_page.dart';
import 'package:daman/main.dart';

import '../../../Utils/Enum/enum_r_font_family.dart';
import '../../../Utils/app_decorations.dart';

class SalesReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SalesReportBody();
  }
}

class SalesReportBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SalesReportBodyState();
}

class _SalesReportBodyState
    extends BasePageState<SalesReportBody, ViewModelSalesReport> {
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
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return
      Container(
        decoration: BoxDecoration(
          color: kMainColor,
          image: DecorationImage(
            image: AssetImage(VOUCHER_BG),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
      appBar: AppBarCommonWidget(
        title: AppLocalizations.of(context)!.salesReport!,
      ),
      // appBar: AppBar(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Stack(
          children: [

            ListView(
              children: [
                Container(
                  color: kTitleBackground,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child:
                  Row(
                    children: [
                      Visibility(
                        visible: false,
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            IC_PRINTER,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${selectedUser.name}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 16,
                              fontWeight: RFontWeight.REGULAR),
                        ),
                      ),
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
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kShadow,
                        offset: Offset(0.0, 1.0),
                        blurRadius: .5,
                        spreadRadius: .5,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.openingBalance!,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                          Text(
                            "${data?.openingBalance ?? ''}",
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                      _itemDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.totalSales!,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                          Text(
                            "${data?.totalSales ?? ''}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${data?.totalRefund ?? '0.0'} Refunded",
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                      _itemDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.totalProfit!,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                          Text(
                            "${data?.totalProfit ?? ''}",
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                      _itemDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.totalWalletFunding!,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                          Text(
                            "${data?.totalFund ?? ''}",
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                      _itemDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.totalBalance!,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                          Text(
                            "${data?.total ?? ''}",
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                      _itemDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.closingBalance!,
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                          Text(
                            "${data?.closingBalance ?? ''}",
                            style: TextStyle(
                                color: kTextColor3,
                                fontSize: 12,
                                fontWeight: RFontWeight.LIGHT),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _itemHeader(),
                SizedBox(
                  height: 10,
                ),
                ListView.separated(
                  itemCount: data?.operatorRecords.length ?? 0,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => _itemSales(
                      (data?.operatorRecords ??
                          List<SalesReportOperatorData>.empty(
                              growable: true))[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      _itemDivider(),
                ),
              ],
            ),
          ],
        ),
      ),
    ),);
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

  _itemHeader() {
    return Container(
      height: 46,
      color: kColor6,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              AppLocalizations.of(context)!.operator!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              AppLocalizations.of(context)!.profit!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              AppLocalizations.of(context)!.sales!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              AppLocalizations.of(context)!.salesCount!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ],
      ),
    );
  }

  _itemSales(SalesReportOperatorData data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                AppImage(
                  data.logo,
                  34,
                  defaultImage: DEFAULT_OPERATOR,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    "${data.title}",
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.LIGHT),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${data.profit}",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${data.sales}",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${data.salesCount}",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ],
      ),
    );
  }
}
