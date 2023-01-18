import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/app_pages.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutUsBody();
  }
}

class AboutUsBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutUsBodyState();
}

class _AboutUsBodyState extends BasePageState<AboutUsBody, ViewModelCommon> {
  var _appPages = HiveBoxes.getAppPages();
  var tabs = List<Widget>.empty(growable: true);
  var pages = List<Widget>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _appPages.values.forEach((element) {
      tabs.add(Tab(
        text: element.title,
      ));
      pages.add(_widgetPage(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          length: tabs.length,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: kMainColor, //.withOpacity(0.73)
                child: TabBar(
                  tabs: tabs,
                  isScrollable: true,
                  indicatorColor: kMainButtonColor,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: pages,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetPage(AppPages page) {
    return SingleChildScrollView(
      child: Html(data: page.content),
    );
  }
}
