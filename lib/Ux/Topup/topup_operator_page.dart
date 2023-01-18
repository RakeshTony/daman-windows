import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TopUpOperatorPage extends StatelessWidget {
  String mobileNumber;
  String countryId;
  String countryCode;
  String countryFlag;
  String operatorId;
  String circleCode;

  TopUpOperatorPage(
      {this.mobileNumber = "",
      this.countryId = "",
      this.countryCode = "",
      this.countryFlag = "",
      this.operatorId = "",
      this.circleCode = ""});

  @override
  Widget build(BuildContext context) {
    return TopUpOperatorBody(mobileNumber, countryId, countryCode, countryFlag,
        operatorId, circleCode);
  }
}

class TopUpOperatorBody extends StatefulWidget {
  String mobileNumber;
  String countryId;
  String countryCode;
  String countryFlag;
  String operatorId;
  String circleCode;

  TopUpOperatorBody(this.mobileNumber, this.countryId, this.countryCode,
      this.countryFlag, this.operatorId, this.circleCode);

  @override
  State<StatefulWidget> createState() => _TopUpOperatorBodyState();
}

class _TopUpOperatorBodyState
    extends BasePageState<TopUpOperatorBody, ViewModelCommon> {
  Operator? mOperatorSelected;

  @override
  void initState() {
    super.initState();
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
        child: ListView(
          children: [
            Container(
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mobile Number",
                          style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: RFontWeight.LIGHT,
                              fontSize: 14),
                        ),
                        InkWell(
                          child: Text(
                            "Edit",
                            style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: RFontWeight.LIGHT,
                                fontSize: 14),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        AppImage(
                          widget.countryFlag,
                          36,
                          backgroundColor: kWhiteColor,
                          defaultImage: DEFAULT_FLAG,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "+${widget.countryCode} ${widget.mobileNumber}",
                          style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: RFontWeight.LIGHT,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                "Operators",
                style: TextStyle(color: kMainTextColor, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                  valueListenable: HiveBoxes.getOperators().listenable(),
                  builder: (context, Box<Operator> data, _) {
                    var filterOperators = data.values
                        .where(
                            (element) => element.countryId == widget.countryId)
                        .toList();
                    if (filterOperators.isNotEmpty) {
                      for (Operator element in filterOperators) {
                        if (element.id == widget.operatorId) {
                          mOperatorSelected = element;
                          break;
                        }
                      }
                      return GridView.builder(
                        itemCount: filterOperators.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        physics: NeverScrollableScrollPhysics(),
                        // to disable GridView's scrolling
                        shrinkWrap: true,
                        // You won't see infinite size error
                        itemBuilder: (context, index) =>
                            _itemOperators(filterOperators[index]),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 100, horizontal: 16),
                        child: Center(
                            child: Text(
                          "No operator found this country",
                          style: TextStyle(
                            fontSize: 18,
                            color: kProgressBarBackground,
                            fontStyle: FontStyle.normal,
                            fontWeight: RFontWeight.REGULAR,
                          ),
                        )),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: CustomButton(
          text: "Next",
          margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          radius: BorderRadius.all(Radius.circular(34.0)),
          onPressed: () {
            if (mOperatorSelected == null) {
              AppAction.showGeneralErrorMessage(
                  context, "Please choose Operator");
            } else {
              var args = {};
              args["mobile"] = widget.mobileNumber;
              args["countryId"] = widget.countryId;
              args["countryCode"] = widget.countryCode;
              args["countryFlag"] = widget.countryFlag;
              args["circleCode"] = widget.circleCode;
              args["operatorServiceId"] = mOperatorSelected?.serviceId ?? "";
              args["operatorId"] = mOperatorSelected?.id ?? "";
              args["operatorName"] = mOperatorSelected?.name ?? "";
              args["operatorLogo"] = mOperatorSelected?.logo ?? "";
              Navigator.pushNamed(context, PageRoutes.mobile,
                  arguments: args);
            }
          },
        ),
      ),
    );
  }

  _itemOperators(Operator operator) {
    return InkWell(
      onTap: () {
        widget.operatorId = "";
        widget.circleCode = "";
        mOperatorSelected = operator;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage(
              operator.logo,
              56,
              borderWidth: (mOperatorSelected?.id ?? "") == operator.id ? 5 : 1,
              borderColor: (mOperatorSelected?.id ?? "") == operator.id
                  ? kMainColor
                  : kHintColor,
            )
          ],
        ),
      ),
    );
  }
}
