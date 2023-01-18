import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/service.dart';
import 'package:daman/Database/models/services_child.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/firebase_node.dart';

import '../../Utils/app_decorations.dart';
import '../../main.dart';

class OperatorPage extends StatelessWidget {
  final ServiceChild service;

  OperatorPage(this.service);

  @override
  Widget build(BuildContext context) {
    return OperatorBody(service);
  }
}

class OperatorBody extends StatefulWidget {
  final ServiceChild service;

  OperatorBody(this.service);

  @override
  State<StatefulWidget> createState() => _OperatorBodyState();
}

class _OperatorBodyState extends BasePageState<OperatorBody, ViewModelCommon> {
  @override
  void initState() {
    super.initState();
/*
    databaseReference
        .child(FirebaseNode.SERVICE_OPERATOR_DENOMINATION)
        .child(mPreference.value.userData.firebasePlanId)
        .onValue
        .listen((data) async {
      // AppLog.e("SERVICE OP DE HOME", data.snapshot.value ?? "");
      if (data.snapshot.value is List) {
        var mServiceOperator = toList(data.snapshot.value)
            .map((e) => ServiceOperatorModel.fromJson(e))
            .toList();
        var mServices = mServiceOperator.map((e) => e.service).toList();
        List<OperatorData> mOperators = [];
        mServiceOperator.forEach((element) {
          mOperators.addAll(element.operator);
        });
        List<DenominationData> mDenominations = [];
        mServiceOperator.forEach((element) {
          element.operator.forEach((element) {
            mDenominations.addAll(element.denominations);
          });
        });
        var services = mServices.map((element) {
          return element.toService;
        }).toList();
        var operators = mOperators.map((element) {
          return element.toOperator;
        }).toList();
        var denominations = mDenominations.map((element) {
          return element.toDenomination;
        }).toList();
        // AppLog.e("SERVICE", services);
        final boxService = HiveBoxes.getServices();
        final boxOperator = HiveBoxes.getOperators();
        final boxDenomination = HiveBoxes.getDenomination();
        await boxService.clear();
        boxService.addAll(services);
        await boxOperator.clear();
        boxOperator.addAll(operators);
        await boxDenomination.clear();
        boxDenomination.addAll(denominations);
      }
    });
*/
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: decorationBackground,
      child:Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Select Operator",
                    style: TextStyle(
                        fontSize: 12,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: HiveBoxes.getOperators().listenable(),
                  builder: (context, Box<Operator> data, _) {
                    var mOperator = data.values
                        .where((e) => e.serviceId == widget.service.id)
                        .toList(growable: true);
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: mOperator.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16),
                        itemBuilder: (context, index) =>
                            _itemOperators(mOperator[index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    ),);
  }

  _itemOperators(Operator operator) {
    return InkWell(
      splashColor: kMainColor,
      onTap: () {
        switch (widget.service.type.toUpperCase()) {
          case 'VOUCHER':
            {
              Navigator.pushNamed(context, PageRoutes.voucherSearch,
                  arguments: operator);
              break;
            }
          case 'TOPUP':
            {
              Navigator.pushNamed(context, PageRoutes.mobileData,
                  arguments: operator);
              break;
            }
          case 'INTERNET':
            {
              Navigator.pushNamed(context, PageRoutes.mobileData,
                  arguments: operator);
              break;
            }
          case 'CABLETV':
            {
              Navigator.pushNamed(context, PageRoutes.cableTv,
                  arguments: operator);
              break;
            }
          case 'ELECTRICITY':
            {
              Navigator.pushNamed(context, PageRoutes.electricity,
                  arguments: operator);
              break;
            }
        }
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhiteColor,
                border: Border.all(
                  width: 1,
                  color: kWhiteColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: operator.logo,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(DEFAULT_OPERATOR),
                ),
                errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(DEFAULT_OPERATOR),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    operator.name,
                    style: TextStyle(fontSize: 16,color: kWhiteColor),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
