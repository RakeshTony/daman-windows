import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/CommissionResponseDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/recent_transaction.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_commission.dart';
import 'package:daman/Ux/Dialog/windows/dialog_my_transaction.dart';
import 'package:daman/Ux/Dialog/windows/dialog_reports_sales.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Utils/app_decorations.dart';

class DialogReportsCommission extends StatefulWidget {
  @override
  State<DialogReportsCommission> createState() =>
      _DialogReportsCommissionState();
}

class _DialogReportsCommissionState
    extends BasePageState<DialogReportsCommission, ViewModelCommission> {
  @override
  void initState() {
    super.initState();
    viewModel.requestCommission();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
            minWidth: 400,
            minHeight: 500,
            maxHeight: 500,
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
                    "Commission Reports",
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
              Expanded(
                child: StreamBuilder(
                  stream: viewModel.commissionStream,
                  initialData:
                      List<CommissionOperatorData>.empty(growable: true),
                  builder: (context,
                      AsyncSnapshot<List<CommissionOperatorData>> snapshot) {
                    var items =
                        List<CommissionOperatorData>.empty(growable: true);
                    if (snapshot.hasData && snapshot.data != null) {
                      var data = snapshot.data ?? [];
                      items.addAll(data);
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          _itemExpendable(items[index], index),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _itemExpendable(CommissionOperatorData data, int index) {
    var children = List<Widget>.empty(growable: true);
    children.add(_itemHeader());
    children.addAll(List<Widget>.generate(data.denominations.length,
        (index) => _itemContent(data.denominations[index])));

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            color: kColor_3,
            border: Border.all(color: kColor_2),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: ExpansionTile(
            backgroundColor: kColor_2,
            collapsedTextColor: kWhiteColor,
            textColor: kWhiteColor,
            collapsedBackgroundColor: kColor_2,
            iconColor: kWhiteColor,
            collapsedIconColor: kWhiteColor,
            title: Text(data.operatorTitle),
            leading: AppImage(
              data.operatorLogo,
              24,
              defaultImage: DEFAULT_OPERATOR,
              borderWidth: 1,
              borderColor: kHintColor,
            ),
            children: children,
          ),
        ),
      ),
    );
  }

  _itemHeader() {
    return Container(
      height: 46,
      color: kColor_3,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Title",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 11,
                  fontWeight: RFontWeight.SEMI_BOLD),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Amount",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 11,
                  fontWeight: RFontWeight.SEMI_BOLD),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Type",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 11,
                  fontWeight: RFontWeight.SEMI_BOLD),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Commission",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 11,
                  fontWeight: RFontWeight.SEMI_BOLD),
            ),
          ),
        ],
      ),
    );
  }

  _itemContent(CommissionDenominationData data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: kColor_3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.title,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 10,
                  fontWeight: RFontWeight.MEDIUM),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.denomination,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 10,
                  fontWeight: RFontWeight.MEDIUM),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.type,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 10,
                  fontWeight: RFontWeight.MEDIUM),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.commission,
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 10,
                  fontWeight: RFontWeight.MEDIUM),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration decoration = BoxDecoration(
    gradient: BUTTON_GRADIENT,
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  TextStyle title() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 13,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }
}
