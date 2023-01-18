
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Ux/Payment/Request/request_money_page.dart';
import 'package:daman/Ux/Payment/Send/send_money_page.dart';

import '../../Utils/app_decorations.dart';

class ScanPayPage extends StatelessWidget {
  int? tabPosition;
  @override
  Widget build(BuildContext context) {
    return ScanPayBody(tabPosition: tabPosition ?? 0);
  }

  ScanPayPage({
    this.tabPosition,
  });
}

class ScanPayBody extends StatefulWidget {
  late int tabPosition;

  ScanPayBody({
    required this.tabPosition,
  });

  @override
  State<StatefulWidget> createState() => _ScanPayBodyState();
}

class _ScanPayBodyState extends BasePageState<ScanPayBody, ViewModelCommon>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        length: 2, vsync: this, initialIndex: widget.tabPosition);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
        decoration: decorationBackground,
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCommonWidget(),
        // appBar: AppBar(),
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: kTitleBackground, //.withOpacity(0.73)
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: "Payment",
                    ),
                    Tab(
                      text: "Wallet Topup",
                    ),
                  ],
                  indicatorColor: kMainButtonColor,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [SendMoneyPage(), RequestMoneyPage()],
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}
