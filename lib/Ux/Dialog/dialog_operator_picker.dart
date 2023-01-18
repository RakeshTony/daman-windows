import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/pair.dart';

class DialogOperatorPicker extends StatelessWidget {
  List<String> operatorsIds;
  final bool isCancelable;
  var mOperators = HiveBoxes.getOperators();

  Pair<String, String> operatorInfo(String operatorId) {
    var mOperator = mOperators.values
        .firstWhereOrNull((element) => element.id == operatorId);
    var name = mOperator?.name ?? "";
    var icon = mOperator?.logo ?? "";
    return Pair(name, icon);
  }

  DialogOperatorPicker(
    this.operatorsIds, {
    this.isCancelable = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isCancelable,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: operatorsIds.length,
            itemBuilder: (context, index) {
              var operatorId = operatorsIds[index];
              var data = operatorInfo(operatorId);
              return ListTile(
                onTap: () {
                  Navigator.pop(context, operatorId);
                },
                leading: AppImage(
                  data.second,
                  48,
                  defaultImage: DEFAULT_OPERATOR,
                  borderColor: kMainColor,
                ),
                title: Text(
                  data.first,
                  style: TextStyle(
                    fontSize: 16,
                    color: kMainColor,
                    fontFamily: RFontFamily.SOFIA_PRO,
                    fontWeight: RFontWeight.MEDIUM,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ),
    );
  }
}
