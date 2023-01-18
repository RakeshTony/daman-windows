import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';
import 'package:daman/DataBeans/ServiceOperatorDenominationDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/operator.dart';
import 'package:daman/Database/models/services_child.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/firebase_node.dart';
import 'package:daman/Utils/pair.dart';

import '../../Routes/routes.dart';
import '../../main.dart';

class ServicesPage extends StatelessWidget {
  final ServiceChild service;

  ServicesPage(this.service);

  @override
  Widget build(BuildContext context) {
    return ServicesPageBody(service);
  }
}

class ServicesPageBody extends StatefulWidget {
  final ServiceChild service;

  ServicesPageBody(this.service);

  @override
  State<StatefulWidget> createState() => _ServicesPageBodyState();
}

class _ServicesPageBodyState
    extends BasePageState<ServicesPageBody, ViewModelCommon> {
  @override
  void initState() {
    super.initState();
    /*databaseReference
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
    });*/
  }

  List<ServiceChild> getAllServices(
      List<ServiceChild> services, String serviceId) {
    List<ServiceChild> mService = [];
    var child = services.where((element) => element.parentId == serviceId);
    mService.addAll(child);
    child.forEach((element) async {
      var data = getAllServices(services, element.id);
      mService.addAll(data);
    });
    return mService;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kScreenBackground,
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: HiveBoxes.getServicesChild().listenable(),
            builder: (context, Box<ServiceChild> data, _) {
              var mServiceAll = getAllServices(
                  data.values.toList(growable: true), widget.service.id);
              var mServiceOperators =
                  List<Pair<ServiceChild, List<Operator>>>.empty(
                      growable: true);
              var operators = HiveBoxes.getOperators();
              mServiceAll.forEach((element) {
                var data = operators.values
                    .where((operator) => element.id == operator.serviceId)
                    .toList();
                if (data.isNotEmpty) {
                  mServiceOperators.add(Pair(element, data));
                }
              });
              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _widgetServiceOperators(mServiceOperators[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16,
                    );
                  },
                  itemCount: mServiceOperators.length);
/*
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: mServiceAll.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16),
                  itemBuilder: (context, index) =>
                      _itemService(mServiceAll[index]),
                ),
              );
*/
            }),
      ),
    );
  }

  _widgetServiceOperators(Pair<ServiceChild, List<Operator>> data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: kMainButtonColor,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Text(
              data.first.title,
              style: TextStyle(color: kWhiteColor, fontSize: 12),
            ),
          ),
          GridView.builder(
            itemCount: data.second.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1 / 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16),
            itemBuilder: (context, index) => _itemOperator(data.second[index]),
          ),
        ],
      ),
    );
  }

  _itemOperator(Operator operator) {
    return InkWell(
      splashColor: kMainColor,
      onTap: () {
        if (widget.service.title.toUpperCase() == 'COLLECTIONS') {
          Navigator.pushNamed(context, PageRoutes.electricity,
              arguments: operator);
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
              child: /*FadeInImage(
                image: NetworkImage(operator.logo),
                placeholder: AssetImage(DEFAULT_OPERATOR),
                imageErrorBuilder: ((context, error, stackTrace) {
                  return Image.asset(DEFAULT_OPERATOR);
                }),
              )*/
                  CachedNetworkImage(
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
                    style: TextStyle(fontSize: 10),
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
