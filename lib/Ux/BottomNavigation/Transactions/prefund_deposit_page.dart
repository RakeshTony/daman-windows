import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/PrefundDepositDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/sales_filter_page.dart';
import 'package:daman/main.dart';

import '../../../Utils/app_decorations.dart';
import 'ViewModel/view_model_prefund_deposit.dart';

class PreFundDepositPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreFundDepositBody();
  }
}

class PreFundDepositBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreFundDepositBodyState();
}

class _PreFundDepositBodyState
    extends BasePageState<PreFundDepositBody, ViewModelPrefundDeposit> {
  PrefundDepositData? data;
  late UserItem selectedUser;
  List<UserItem> users = [];
  DateTime? toDate;
  DateTime? fromDate;

  @override
  void initState() {
    super.initState();
    selectedUser = UserItem(
        id: mPreference.value.userData.id,
        name: mPreference.value.userData.name);
    users.add(selectedUser);
    _fetchReport();
  }

  _fetchReport() {
    viewModel.requestPrefundDeposit(selectedUser.id, fromDate, toDate);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: decorationBackground,
      child: Scaffold(
        appBar: AppBarCommonWidget(
          title: "Deposit Summary",
        ),
        // appBar: AppBar(),
        backgroundColor: kColorBackgroundReport,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    color: kMainColor,
                    child: Column(children: [
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
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
                              AppLocalizations.of(context)!
                                  .prefundDepositSummary!,
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
                              args["from_date_time"] = fromDate;
                              args["to_date_time"] = toDate;
                              args["filter_from"] = false;
                              var result = await Navigator.pushNamed(
                                  context, PageRoutes.salesFilter,
                                  arguments: args);
                              if (result != null) {
                                var success = result as Map<String, dynamic>;
                                selectedUser = success["user"];
                                fromDate = success["from"];
                                toDate = success["to"];
                                _fetchReport();
                                setState(() {});
                              }
                            },
                            child: Image.asset(
                              IC_FILTER_WHITE,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
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
                                  AppLocalizations.of(context)!.fromDate!,
                                  style: TextStyle(
                                      color: kTextColor3,
                                      fontSize: 12,
                                      fontWeight: RFontWeight.LIGHT),
                                ),
                                Text(
                                  fromDate == null ? "" : fromDate!.getDate(),
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
                                  AppLocalizations.of(context)!.toDate!,
                                  style: TextStyle(
                                      color: kTextColor3,
                                      fontSize: 12,
                                      fontWeight: RFontWeight.LIGHT),
                                ),
                                Text(
                                  toDate == null ? "" : toDate!.getDate(),
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
                    ]),
                  ),
                  _itemHeader(),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: viewModel.responseStream,
                      builder: (context,
                          AsyncSnapshot<PrefundDepositDataModel> snap) {
                        if (snap.hasData && snap.data != null) {
                          var items = snap.data?.data ?? [];
                          return ListView.separated(
                            itemCount: items.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                                _itemSales(items[index]),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    _itemDivider(),
                          );
                        }
                        return Container(
                          width: 0,
                          height: 0,
                        );
                      }),
                ],
              ),
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

  _itemHeader() {
    return Container(
      height: 46,
      color: kMainButtonColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.depositDate!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.debitNote!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.amount!,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: RFontWeight.LIGHT),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  _itemSales(PrefundDepositData data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              data.date,
              style: TextStyle(
                  color: kColor2, fontSize: 14, fontWeight: RFontWeight.LIGHT),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              "${data.debitNoteAmount}",
              style: TextStyle(
                  color: kColor2, fontSize: 14, fontWeight: RFontWeight.LIGHT),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${data.amount.toSeparatorFormat()}",
              style: TextStyle(
                  color: kColor2, fontSize: 14, fontWeight: RFontWeight.LIGHT),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
