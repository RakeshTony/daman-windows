import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/Dialog/windows/dialog_my_transaction.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_commission.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_prefunds.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_sales.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Utils/app_decorations.dart';

class DialogReports extends StatefulWidget {
  @override
  State<DialogReports> createState() => _DialogReportsState();
}

class _DialogReportsState
    extends BasePageState<DialogReports, ViewModelCommon> {
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reports",
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
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButtonWidget(IC_WIN_SALES_REPORT, "Sales Report", () {
                    var dialog = DialogReportsSales();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  }),
                  SizedBox(
                    height: 16,
                  ),
                  _buildButtonWidget(IC_WIN_TRANSACTION, "My Transaction", () {
                    var dialog = DialogMyTransactions();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  }),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButtonWidget(IC_WIN_COMMISSION, "Commission", () {
                    var dialog = DialogReportsCommission();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  }),
                  SizedBox(
                    height: 16,
                  ),
                  _buildButtonWidget(IC_WIN_PREFUND_DEPOSIT, "Prefund Deposit",
                      () {
                    var dialog = DialogReportsPrefunds();
                    showDialog(
                      context: context,
                      builder: (context) => dialog,
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration = BoxDecoration(
    gradient: BUTTON_GRADIENT,
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  Widget _buildButtonWidget(String image, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 133,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: decoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: 60),
            SizedBox(height: 5,),
            Text("$label", style: title()),
          ],
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
}
