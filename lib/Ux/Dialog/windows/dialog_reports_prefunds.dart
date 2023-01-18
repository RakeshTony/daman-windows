import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/PrefundDepositDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_prefund_deposit.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/sales_filter_page.dart';
import 'package:daman/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DialogReportsPrefunds extends StatefulWidget {
  @override
  State<DialogReportsPrefunds> createState() => _DialogReportsPrefundsState();
}

class _DialogReportsPrefundsState
    extends BasePageState<DialogReportsPrefunds, ViewModelPrefundDeposit> {
  var wallet = HiveBoxes.getBalanceWallet();
  PrefundDepositData? data;
  late UserItem selectedUser;
  List<UserItem> users = [];
  DateTime? toDate;
  DateTime? fromDate;

  _fetchReport() {
    viewModel.requestPrefundDeposit(selectedUser.id, fromDate, toDate);
  }

  @override
  void initState() {
    super.initState();
    selectedUser = UserItem(
        id: mPreference.value.userData.id,
        name: mPreference.value.userData.name);
    users.add(selectedUser);
    _fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 480,
            maxHeight: 480,
            maxWidth: 320,
            minWidth: 320,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prefund Deposit Summery",
                    style: title(),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: Image.asset(
                          IC_WIN_PRINT,
                          height: 16,
                          fit: BoxFit.fitHeight,
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: Image.asset(
                          IC_WIN_FILTER,
                          fit: BoxFit.fitHeight,
                          height: 16,
                        ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          child:
                              Icon(Icons.close, size: 12, color: kWhiteColor),
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
                    _buildAmountWidget("${fromDate == null ? "" : fromDate!.getDate()}", "From Date"),
                    _buildDivider(),
                    _buildAmountWidget("${toDate == null ? "" : toDate!.getDate()}", "To Date"),
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
                              flex: 1,
                              child: Text(
                                "Deposit Date",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Debit Note",
                                style: title_1(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Amount",
                                style: title_1(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: viewModel.responseStream,
                          builder: (context,
                              AsyncSnapshot<PrefundDepositDataModel> snap) {
                            if (snap.hasData && snap.data != null) {
                              var items = snap.data?.data ?? [];
                              return ListView.separated(
                                itemCount: items.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        _itemSales(items[index]),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        _buildDivider(),
                              );
                            }
                            return Container(
                              width: 0,
                              height: 0,
                            );
                          },
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

  Widget _buildAmountWidget(String date, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$date",
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

  Widget _itemSales(PrefundDepositData data) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "${data.date}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${data.debitNoteAmount}",
              style: description_1(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${wallet?.currencySign ?? ''} ${data.amount.toSeparatorFormat()}",
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
