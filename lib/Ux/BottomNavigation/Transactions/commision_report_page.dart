import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CommissionResponseDataModel.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Ux/BottomNavigation/Transactions/ViewModel/view_model_commission.dart';

class CommissionReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommissionReportBody();
  }
}

class CommissionReportBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommissionReportBodyState();
}

class _CommissionReportBodyState
    extends BasePageState<CommissionReportBody, ViewModelCommission> {
  @override
  void initState() {
    super.initState();
    viewModel.requestCommission();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: kMainColor,
        image: DecorationImage(
          image: AssetImage(VOUCHER_BG),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          color: theme.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.commissionReport!,
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
          child: StreamBuilder(
            stream: viewModel.commissionStream,
            initialData: List<CommissionOperatorData>.empty(growable: true),
            builder:
                (context, AsyncSnapshot<List<CommissionOperatorData>> snapshot) {
              var items = List<CommissionOperatorData>.empty(growable: true);
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
    ),);
  }

  _itemExpendable(CommissionOperatorData data, int index) {
    var children = List<Widget>.empty(growable: true);
    children.add(_itemHeader());
    children.addAll(List<Widget>.generate(data.denominations.length,
        (index) => _itemContent(data.denominations[index])));

    return ExpansionTile(
      backgroundColor: kTitleBackground,
      collapsedTextColor: kMainTextColor,
      textColor: kWhiteColor,
      collapsedBackgroundColor: kColor1,
      iconColor: kWhiteColor,
      collapsedIconColor: kMainTextColor,
      tilePadding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      title: Text(data.operatorTitle),
      leading: AppImage(
        data.operatorLogo,
        24,
        defaultImage: DEFAULT_OPERATOR,
        borderWidth: 1,
        borderColor: kHintColor,
      ),
      children: children,
    );
  }

  _itemHeader() {
    return Container(
      height: 46,
      color: kWhiteColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Title",
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Amount",
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Type",
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Commission",
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ],
      ),
    );
  }

  _itemContent(CommissionDenominationData data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: kWhiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.title,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.denomination,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.type,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.commission,
              style: TextStyle(
                  color: kMainTextColor,
                  fontSize: 12,
                  fontWeight: RFontWeight.LIGHT),
            ),
          ),
        ],
      ),
    );
  }
}
